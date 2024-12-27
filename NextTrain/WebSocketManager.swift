//
//  WebSocketManager.swift
//  NextTrain
//
//  Created by aimee rivers on 25/12/2024.
//

import Foundation

struct Root: Codable {
    let data: TrainData
}

struct TrainData: Codable {
    let trains: [Departure]

    enum CodingKeys: String, CodingKey {
        case trains = "Trains"
    }
}

struct Departure: Identifiable, Codable {
    let id: String
    let LineName: String
    let MinutesToDeparture: Float
    let TrainDelayed: Bool
    let TargetStation: [String]
    let TrackCurrent: String
    let IsCancelled: Bool
    let TrainArrived: String?
    let TrainDeparted: String?

    enum CodingKeys: String, CodingKey {
        case id = "TrainId"
        case LineName
        case MinutesToDeparture
        case TargetStation
        case TrackCurrent
        case IsCancelled
        case TrainArrived
        case TrainDeparted
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        LineName = try container.decode(String.self, forKey: .LineName)
        let minutesToDeparture = try container.decodeIfPresent(
            Float.self, forKey: .MinutesToDeparture)
        MinutesToDeparture = minutesToDeparture ?? 0
        TrainDelayed = minutesToDeparture == nil
        TargetStation = try container.decode(
            [String].self, forKey: .TargetStation)
        TrackCurrent = try container.decode(String.self, forKey: .TrackCurrent)
        IsCancelled = try container.decode(Bool.self, forKey: .IsCancelled)
        TrainArrived = try container.decodeIfPresent(
            String.self, forKey: .TrainArrived)
        TrainDeparted = try container.decodeIfPresent(
            String.self, forKey: .TrainDeparted)
    }
}

class WebSocketManager: NSObject, ObservableObject {
    private var webSocket: URLSessionWebSocketTask?
    @Published var departures: [Departure] = []

    override init() {
        super.init()
    }

    func connect(stationId: String) {
        let urlString =
            "wss://api.mittog.dk/api/ws/stog/departure/\(stationId)/"
        guard let url = URL(string: urlString) else {
            print("Invalid WebSocket URL for station \(stationId)")
            return
        }

        let session = URLSession(
            configuration: .default, delegate: self,
            delegateQueue: OperationQueue())
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()

        receive()
    }

    func receive() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(_):
                    print("Got data, don't know what to do with it")
                case .string(let string):
                    self?.handleString(string)
                @unknown default:
                    print("Received unknown message type")
                }
            case .failure(let error):
                print("WebSocket error: \(error.localizedDescription)")
            }

            // Keep listening for new messages
            self?.receive()
        }
    }

    func handleString(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            print("Failed to convert string to data")
            return
        }

        do {
            let root = try JSONDecoder().decode(Root.self, from: data)
            DispatchQueue.main.async {
                self.departures = root.data.trains
            }
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }

    func disconnect() {
        print("Disconnecting WebSocket")
        guard let webSocket = webSocket else {
            print("WebSocket is already nil")
            return
        }
        webSocket.cancel(with: .goingAway, reason: nil)
        self.webSocket = nil
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession, webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?
    ) {
        print("WebSocket closed: \(closeCode)")
    }
}

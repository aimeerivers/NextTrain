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
    let TargetStation: [String]
    let TrackCurrent: String
    let IsCancelled: Bool

    enum CodingKeys: String, CodingKey {
        case id = "TrainId"
        case LineName
        case MinutesToDeparture
        case TargetStation
        case TrackCurrent
        case IsCancelled
    }
}

class WebSocketManager: NSObject, ObservableObject {
    private var webSocket: URLSessionWebSocketTask?
    @Published var departures: [Departure] = []
    private let stationId: String

    init(stationId: String) {
        self.stationId = stationId
        super.init()
        connect()
    }

    func connect() {
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
        webSocket?.cancel(with: .goingAway, reason: nil)
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

//
//  Departure.swift
//  NextTrain
//
//  Created by aimee rivers on 30/12/2024.
//

struct Root: Codable {
    let data: TrainData
}

struct TrainData: Codable {
    let trains: [Departure]

    enum CodingKeys: String, CodingKey {
        case trains = "Trains"
    }
}

struct Route: Codable {
    let ViaStation: String?

    enum CodingKeys: String, CodingKey {
        case ViaStation
    }
}

struct Departure: Identifiable, Codable {
    let id: String
    let LineName: String
    let MinutesToDeparture: Float
    let TrainDelayed: Bool
    let TargetStation: [String]
    let TrackCurrent: String
    let TrackOriginal: String?
    let IsCancelled: Bool
    let TrainArrived: String?
    let TrainDeparted: String?
    let Routes: [Route]

    enum CodingKeys: String, CodingKey {
        case id = "TrainId"
        case LineName
        case MinutesToDeparture
        case TargetStation
        case TrackCurrent
        case TrackOriginal
        case IsCancelled
        case TrainArrived
        case TrainDeparted
        case Routes
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
        TrackOriginal = try container.decodeIfPresent(
            String.self, forKey: .TrackOriginal)
        IsCancelled = try container.decode(Bool.self, forKey: .IsCancelled)
        TrainArrived = try container.decodeIfPresent(
            String.self, forKey: .TrainArrived)
        TrainDeparted = try container.decodeIfPresent(
            String.self, forKey: .TrainDeparted)
        Routes = try container.decode([Route].self, forKey: .Routes)
    }
}

//
//  Departure.swift
//  NextTrain
//
//  Created by aimee rivers on 30/12/2024.
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
    let AwaitingTime: Bool
    let TargetStation: [String]
    let TrackCurrent: String
    let TrackOriginal: String?
    let IsCancelled: Bool
    let TrainArrived: String?
    let TrainDeparted: String?
    let Routes: [Route]
    let ScheduleTimeDeparture: Date?
    let EstimatedTimeDeparture: Date?
    let TrainDelayed: Bool

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
        case ScheduleTimeDeparture
        case EstimatedTimeDeparture
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        LineName = try container.decode(String.self, forKey: .LineName)
        let minutesToDeparture = try container.decodeIfPresent(
            Float.self, forKey: .MinutesToDeparture)
        MinutesToDeparture = minutesToDeparture ?? 0
        AwaitingTime = minutesToDeparture == nil
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

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

        if let scheduleTimeDepartureString = try container.decodeIfPresent(
            String.self, forKey: .ScheduleTimeDeparture)
        {
            ScheduleTimeDeparture = dateFormatter.date(
                from: scheduleTimeDepartureString)
        } else {
            ScheduleTimeDeparture = nil
        }

        if let estimatedTimeDepartureString = try container.decodeIfPresent(
            String.self, forKey: .EstimatedTimeDeparture)
        {
            EstimatedTimeDeparture = dateFormatter.date(
                from: estimatedTimeDepartureString)
        } else {
            EstimatedTimeDeparture = nil
        }

        TrainDelayed =
            formattedTime(from: ScheduleTimeDeparture)
            != formattedTime(from: EstimatedTimeDeparture)
    }
}

extension Departure {
    static var sample: Departure {
        let json = """
            {
                    "TrainId": "634149",
                    "TOC": "DSB",
                    "Product": "STRAIN",
                    "LineName": "C",
                    "ScheduleTimeArrival": "30-12-2024 16:03:45",
                    "ScheduleTimeDeparture": "30-12-2024 16:04:00",
                    "EstimatedTimeArrival": "30-12-2024 16:05:07",
                    "EstimatedTimeDeparture": "30-12-2024 16:05:22",
                    "DepartureDirection": "UP",
                    "MinutesToDeparture": 7.0,
                    "TargetStation": [
                      "KL"
                    ],
                    "TrackCurrent": "1",
                    "TrackOriginal": null,
                    "IsCancelled": false,
                    "Routes": [
                      {
                        "DestinationStationId": "KL",
                        "UnitType": "SA",
                        "ViaStation": "KH",
                        "Stations": [
                          {
                            "StationId": "HER",
                            "ExpectedDateTime": "30-12-2024 16:08:02",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "HUT",
                            "ExpectedDateTime": "30-12-2024 16:10:02",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "IST",
                            "ExpectedDateTime": "30-12-2024 16:12:07",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "JYT",
                            "ExpectedDateTime": "30-12-2024 16:14:12",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "VAN",
                            "ExpectedDateTime": "30-12-2024 16:14:57",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "FL",
                            "ExpectedDateTime": "30-12-2024 16:17:02",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "PBT",
                            "ExpectedDateTime": "30-12-2024 16:18:12",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "VAT",
                            "ExpectedDateTime": "30-12-2024 16:20:07",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "VAL",
                            "ExpectedDateTime": "30-12-2024 16:21:57",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "CB",
                            "ExpectedDateTime": "30-12-2024 16:24:02",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "DBT",
                            "ExpectedDateTime": "30-12-2024 16:26:02",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "KH",
                            "ExpectedDateTime": "30-12-2024 16:29:22",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "VPT",
                            "ExpectedDateTime": "30-12-2024 16:31:02",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "KN",
                            "ExpectedDateTime": "30-12-2024 16:32:57",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "KK",
                            "ExpectedDateTime": "30-12-2024 16:34:57",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "NHT",
                            "ExpectedDateTime": "30-12-2024 16:37:57",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "SAM",
                            "ExpectedDateTime": "30-12-2024 16:39:57",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "HL",
                            "ExpectedDateTime": "30-12-2024 16:41:52",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "CH",
                            "ExpectedDateTime": "30-12-2024 16:45:02",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "OP",
                            "ExpectedDateTime": "30-12-2024 16:47:02",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "KL",
                            "ExpectedDateTime": "30-12-2024 16:50:22",
                            "IsCancelled": false
                          }
                        ]
                      }
                    ],
                    "TrainArrived": null,
                    "TrainDeparted": null
                  }
            """
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        return try! decoder.decode(Departure.self, from: data)
    }
}

func formattedTime(from date: Date?) -> String {
    guard let date = date else {
        return ""
    }
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}

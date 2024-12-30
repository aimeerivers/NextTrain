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
    let TrainDelayed: Bool
    let TargetStation: [String]
    let TrackCurrent: String
    let TrackOriginal: String?
    let IsCancelled: Bool
    let TrainArrived: String?
    let TrainDeparted: String?
    let Routes: [Route]
    let EstimatedTimeDeparture: Date?

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
        case EstimatedTimeDeparture
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

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

        if let estimatedTimeDepartureString = try container.decodeIfPresent(
            String.self, forKey: .EstimatedTimeDeparture)
        {
            EstimatedTimeDeparture = dateFormatter.date(
                from: estimatedTimeDepartureString)
        } else {
            EstimatedTimeDeparture = nil
        }
    }
}

extension Departure {
    static var sample: Departure {
        let json = """
            {
                    "TrainId": "633143",
                    "TOC": "DSB",
                    "Product": "STRAIN",
                    "LineName": "C",
                    "EstimatedTimeDeparture": "30-12-2024 14:13:45",
                    "ScheduleTimeDeparture": "30-12-2024 14:14:00",
                    "EstimatedTimeArrival": "30-12-2024 14:14:52",
                    "EstimatedTimeDeparture": "30-12-2024 14:15:07",
                    "DepartureDirection": "UP",
                    "MinutesToDeparture": 1.0,
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
                            "ExpectedDateTime": "30-12-2024 14:17:47",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "HUT",
                            "ExpectedDateTime": "30-12-2024 14:19:47",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "IST",
                            "ExpectedDateTime": "30-12-2024 14:21:52",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "JYT",
                            "ExpectedDateTime": "30-12-2024 14:23:57",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "VAN",
                            "ExpectedDateTime": "30-12-2024 14:24:42",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "FL",
                            "ExpectedDateTime": "30-12-2024 14:26:47",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "PBT",
                            "ExpectedDateTime": "30-12-2024 14:27:57",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "VAT",
                            "ExpectedDateTime": "30-12-2024 14:29:52",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "VAL",
                            "ExpectedDateTime": "30-12-2024 14:31:42",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "CB",
                            "ExpectedDateTime": "30-12-2024 14:33:47",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "DBT",
                            "ExpectedDateTime": "30-12-2024 14:35:47",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "KH",
                            "ExpectedDateTime": "30-12-2024 14:39:07",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "VPT",
                            "ExpectedDateTime": "30-12-2024 14:40:47",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "KN",
                            "ExpectedDateTime": "30-12-2024 14:42:42",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "KK",
                            "ExpectedDateTime": "30-12-2024 14:44:42",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "NHT",
                            "ExpectedDateTime": "30-12-2024 14:47:42",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "SAM",
                            "ExpectedDateTime": "30-12-2024 14:49:42",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "HL",
                            "ExpectedDateTime": "30-12-2024 14:51:37",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "CH",
                            "ExpectedDateTime": "30-12-2024 14:54:47",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "OP",
                            "ExpectedDateTime": "30-12-2024 14:56:47",
                            "IsCancelled": false
                          },
                          {
                            "StationId": "KL",
                            "ExpectedDateTime": "30-12-2024 15:00:07",
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

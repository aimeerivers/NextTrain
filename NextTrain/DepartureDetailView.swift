//
//  DepartureDetailView.swift
//  NextTrain
//
//  Created by aimee rivers on 30/12/2024.
//

import SwiftUI

struct DepartureDetailView: View {
    let departure: Departure

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(departure.LineName.capitalized)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(
                        departure.LineName == "F"
                            ? .black : .white
                    )
                    .padding(.horizontal, 5.0)
                    .background(
                        Color(departure.LineName)
                    )

                VStack(alignment: .leading) {
                    Text(
                        stationName(for: departure.TargetStation[0])
                    )
                    .font(.headline)

                    if departure.Routes[0]
                        .ViaStation
                        != departure.TargetStation[0],
                        let viaStation =
                            viaStationName(
                                for: departure.Routes[0].ViaStation)
                    {
                        Text("via \(viaStation)")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
                .padding(.leading, 5.0)

                Spacer()
            }
            Text("Train ID: \(departure.id)")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding()
            Spacer()
        }
        .navigationTitle("Departure Details")
        .navigationBarTitleDisplayMode(.inline)
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
                    "ScheduleTimeArrival": "30-12-2024 14:13:45",
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

#Preview {
    DepartureDetailView(departure: .sample)
}

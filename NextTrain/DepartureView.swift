//
//  DepartureView.swift
//  NextTrain
//
//  Created by aimee rivers on 25/12/2024.
//

import SwiftUI

func nextTwoDeparturesPerTrack(from departures: [Departure]) -> [String:
    [Departure]]
{
    // Group by TrackCurrent
    let groupedByTrack = Dictionary(grouping: departures) { $0.TrackCurrent }

    // For each track, sort by MinutesToDeparture and pick the next two departures
    var result: [String: [Departure]] = [:]
    for (track, trackDepartures) in groupedByTrack {
        let sortedDepartures = trackDepartures.sorted {
            $0.MinutesToDeparture < $1.MinutesToDeparture
        }
        result[track] = Array(sortedDepartures.prefix(2))
    }
    return result
}

func stationName(for id: String) -> String {
    return allStations.first(where: { $0.id == id })?.name ?? id
}

struct DepartureView: View {
    @StateObject private var webSocketManager = WebSocketManager()

    let station: Station

    var body: some View {
        VStack {
            if webSocketManager.departures.isEmpty {
                Text("Loading departures...")
            } else {
                let groupedDepartures = nextTwoDeparturesPerTrack(
                    from: webSocketManager.departures)
                List {
                    ForEach(
                        groupedDepartures.keys.sorted {
                            let firstTrackParts = $0.split(separator: "-")
                            let secondTrackParts = $1.split(separator: "-")
                            let firstTrack =
                                Int(firstTrackParts.first ?? "") ?? 0
                            let secondTrack =
                                Int(secondTrackParts.first ?? "") ?? 0
                            if firstTrack == secondTrack {
                                return firstTrackParts.count
                                    < secondTrackParts.count
                            }
                            return firstTrack < secondTrack
                        }, id: \.self
                    ) { track in
                        Section(header: Text("Track \(track)")) {
                            ForEach(groupedDepartures[track]!) { departure in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(departure.LineName).font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 5.0)
                                            .background(
                                                Color(departure.LineName)
                                            )

                                        VStack(alignment: .leading) {
                                            Text(
                                                stationName(
                                                    for:
                                                        departure.TargetStation[
                                                            0])
                                            )
                                            .font(.headline)
                                            .foregroundColor(
                                                departure.IsCancelled
                                                    ? .red : .primary
                                            )
                                            .strikethrough(
                                                departure.IsCancelled)

                                            if departure.TrainArrived != nil {
                                                Text("Train arrived")
                                                    .foregroundColor(.green)
                                                    .font(.subheadline)
                                            }
                                            if departure.IsCancelled {
                                                Text("Cancelled")
                                                    .foregroundColor(.red)
                                                    .font(.subheadline)
                                            }
                                        }
                                        .padding(.leading, 5.0)

                                        Spacer()

                                        if departure.MinutesToDeparture
                                            .truncatingRemainder(dividingBy: 1)
                                            == 0
                                        {
                                            Text(
                                                "\(Int(departure.MinutesToDeparture)) min"
                                            )
                                        } else {
                                            Text(
                                                String(
                                                    format: "%.1f min",
                                                    departure.MinutesToDeparture
                                                ))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            webSocketManager.connect(stationId: station.id)
        }
        .onDisappear {
            webSocketManager.disconnect()
        }
        .navigationTitle(station.name)
    }
}

#Preview {
    DepartureView(
        station: Station(
            id: "KH", name: "København H", latitude: 55.672778,
            longitude: 12.564444))
}

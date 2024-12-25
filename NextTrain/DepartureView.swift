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

struct DepartureView: View {
    @StateObject private var webSocketManager = WebSocketManager(
        stationId: "MPT")

    let station: Station

    var body: some View {
        VStack {
            if webSocketManager.departures.isEmpty {
                Text("Loading departures...")
            } else {
                List(webSocketManager.departures.prefix(2)) { departure in
                    VStack(alignment: .leading) {
                        Text("Line \(departure.LineName)")
                            .font(.headline)
                        Text("To \(departure.TargetStation[0])")
                        if departure.MinutesToDeparture.truncatingRemainder(
                            dividingBy: 1) == 0
                        {
                            Text(
                                "In \(Int(departure.MinutesToDeparture)) minutes"
                            )
                        } else {
                            Text(
                                String(
                                    format: "In %.1f minutes",
                                    departure.MinutesToDeparture))
                        }
                    }
                }
            }
        }
        .onAppear {
            webSocketManager.connect()
        }
        .onDisappear {
            webSocketManager.disconnect()
        }
        .navigationTitle(station.name)
    }
}

#Preview {
    DepartureView(
        station: Station(id: "SKO", name: "Skovlunde Station", distance: 200))
}

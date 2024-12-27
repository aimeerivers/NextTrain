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
    // Filter out departures where TrainDeparted is not nil
    let filteredDepartures = departures.filter { $0.TrainDeparted == nil }

    // Group by TrackCurrent
    let groupedByTrack = Dictionary(grouping: filteredDepartures) {
        $0.TrackCurrent
    }

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

func timeFormatted(minutes: Float) -> String {
    if minutes.truncatingRemainder(dividingBy: 1) == 0 {
        return "\(Int(minutes)) min"
    } else {
        return String(format: "%.1f min", minutes)
    }
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
                            let firstHasDash = $0.contains("-")
                            let secondHasDash = $1.contains("-")

                            if firstHasDash && !secondHasDash {
                                return false
                            } else if !firstHasDash && secondHasDash {
                                return true
                            } else {
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
                            }
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

                                            if departure.TrainArrived != nil
                                                && Int(
                                                    departure.MinutesToDeparture
                                                ) <= 1
                                            {
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

                                        Text(
                                            timeFormatted(
                                                minutes: departure
                                                    .MinutesToDeparture)
                                        )
                                        .foregroundColor(
                                            departure.IsCancelled
                                                ? .red : .primary
                                        )
                                        .strikethrough(departure.IsCancelled)
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

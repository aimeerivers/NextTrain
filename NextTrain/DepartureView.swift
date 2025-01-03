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
    // Ensure not including when train has already departed
    let filteredDepartures = departures.filter { $0.TrainDeparted == nil }

    // Group by TrackCurrent
    let groupedByTrack = Dictionary(grouping: filteredDepartures) {
        $0.TrackCurrent
    }

    // For each track, sort by MinutesToDeparture and pick the next two departures
    var result: [String: [Departure]] = [:]
    for (track, trackDepartures) in groupedByTrack {
        result[track] = Array(trackDepartures.prefix(2))
    }
    return result
}

func stationName(for id: String) -> String {
    return allStations.first(where: { $0.id == id })?.name ?? id
}

func timeFormatted(awaitingTime: Bool, minutes: Float) -> String {
    if awaitingTime {
        return "? min"
    } else if minutes.truncatingRemainder(dividingBy: 1) == 0 {
        return "\(Int(minutes)) min"
    } else {
        return String(format: "%.1f min", minutes)
    }
}

func viaStationName(for id: String?) -> String? {
    guard let id = id else { return nil }
    return allStations.first(where: { $0.id == id })?.name
}

struct DepartureView: View {
    @StateObject private var webSocketManager = WebSocketManager()
    @State private var selectedDeparture: Departure?
    @State private var isLoading = true

    let station: Station

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading departures...")
            } else if webSocketManager.departures.isEmpty {
                Text("No departures available.")
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
                                Button(action: {
                                    selectedDeparture = departure
                                }) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(departure.LineName.capitalized)
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(
                                                    departure.LineName == "F"
                                                        ? .black : .white
                                                )
                                                .frame(width: 21.0)
                                                .padding(.horizontal, 5.0)
                                                .background(
                                                    Color(departure.LineName)
                                                )

                                            VStack(alignment: .leading) {
                                                Text(
                                                    stationName(
                                                        for:
                                                            departure
                                                            .TargetStation[
                                                                0])
                                                )
                                                .font(.headline)
                                                .foregroundColor(
                                                    departure.IsCancelled
                                                        ? .red : .primary
                                                )
                                                .strikethrough(
                                                    departure.IsCancelled)

                                                if departure.IsCancelled {
                                                    Text("Cancelled")
                                                        .foregroundColor(.red)
                                                        .font(.subheadline)
                                                } else {
                                                    if departure.Routes[0]
                                                        .ViaStation
                                                        != departure
                                                        .TargetStation[
                                                            0],
                                                        let viaStation =
                                                            viaStationName(
                                                                for:
                                                                    departure
                                                                    .Routes[
                                                                        0
                                                                    ]
                                                                    .ViaStation)
                                                    {
                                                        Text(
                                                            "via \(viaStation)"
                                                        )
                                                        .foregroundColor(.gray)
                                                        .font(.subheadline)
                                                    }
                                                    if departure.TrainArrived
                                                        != nil
                                                        && Int(
                                                            departure
                                                                .MinutesToDeparture
                                                        ) <= 1
                                                    {
                                                        Text("Train arrived")
                                                            .foregroundColor(
                                                                .green
                                                            )
                                                            .font(.subheadline)
                                                    }
                                                    if departure.TrainDelayed
                                                        && departure
                                                            .TrainArrived
                                                            == nil
                                                        && !departure
                                                            .AwaitingTime
                                                    {
                                                        Text("Train delayed")
                                                            .foregroundColor(
                                                                .orange
                                                            )
                                                            .font(.subheadline)
                                                    }
                                                    if departure.AwaitingTime
                                                        && departure
                                                            .TrainArrived
                                                            == nil
                                                    {
                                                        Text("Awaiting time")
                                                            .foregroundColor(
                                                                .orange
                                                            )
                                                            .font(.subheadline)
                                                    }
                                                    if departure.TrackOriginal
                                                        != nil
                                                        && departure
                                                            .TrackOriginal
                                                            != departure
                                                            .TrackCurrent
                                                    {
                                                        Text(
                                                            "Note: Track \(departure.TrackCurrent)"
                                                        )
                                                        .foregroundColor(
                                                            .orange
                                                        )
                                                        .font(.subheadline)
                                                    }
                                                }
                                            }
                                            .padding(.leading, 5.0)

                                            Spacer()

                                            Text(
                                                timeFormatted(
                                                    awaitingTime: departure
                                                        .AwaitingTime,
                                                    minutes: departure
                                                        .MinutesToDeparture)
                                            )
                                            .foregroundColor(
                                                departure.IsCancelled
                                                    ? .red : .primary
                                            )
                                            .strikethrough(
                                                departure.IsCancelled)
                                        }
                                    }
                                    .contentShape(Rectangle())  // Make the entire VStack tappable
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedDeparture) { departure in
            DepartureDetailView(departure: departure).padding()
        }
        .onAppear {
            isLoading = true
            webSocketManager.connect(stationId: station.id)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isLoading = false
            }
        }
        .onDisappear {
            webSocketManager.disconnect()
        }
        .navigationTitle(station.name)
    }
}

#Preview {
    DepartureView(
        // station: allStations.randomElement()!
        station: Station(
            id: "KH", name: "København H", latitude: 55.672778,
            longitude: 12.564444, lines: ["A", "B", "BX", "C", "E", "H"]))
}

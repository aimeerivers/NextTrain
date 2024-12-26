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

let stationLookup: [String: String] = [
    "BA": "Ballerup",
    "BI": "Birkerød",
    "BUD": "Buddinge",
    "DAH": "Danshøj",
    "DBT": "Dybbølsbro",
    "EMT": "Emdrup",
    "FL": "Flintholm",
    "FM": "Farum",
    "FS": "Frederikssund",
    "GL": "Glostrup",
    "HI": "Hillerød",
    "HL": "Hellerup",
    "HOT": "Holte",
    "HTÅ": "Høje Taastrup",
    "KH": "København H",
    "KN": "Nørreport",
    "KJ": "Køge",
    "KK": "Østerport",
    "KL": "Klampenborg",
    "MPT": "Malmparken",
    "NEL": "København Syd",
    "SAM": "Svanemøllen",
    "SKO": "Skovlunde",
    "SKT": "Skovbrynet",
    "SOL": "Solrød Strand",
    "UND": "Hundige",
    "VAL": "Valby",
    "VAN": "Vanløse",
    "ØL": "Ølstykke",
]

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
                    ForEach(groupedDepartures.keys.sorted(), id: \.self) {
                        track in
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
                                        Text(
                                            stationLookup[
                                                departure.TargetStation[0],
                                                default:
                                                    departure.TargetStation[0]]
                                        ).font(
                                            .headline)
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
            id: "SKO", name: "Skovlunde", latitude: 55.723,
            longitude: 12.390))
}

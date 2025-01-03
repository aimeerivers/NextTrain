//
//  ContentView.swift
//  NextTrain
//
//  Created by aimee rivers on 25/12/2024.
//

import CoreLocation
import SwiftUI

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (
        lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D
    ) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct StationRow: View {
    let station: Station

    var body: some View {
        VStack(alignment: .leading) {
            Text(station.name)
                .font(.headline)
            HStack {
                ForEach(station.lines, id: \.self) { line in
                    Text(line.capitalized)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(line == "F" ? .black : .white)
                        .frame(width: 17.0)
                        .padding(.horizontal, 4.0)
                        .background(Color(line))
                }
            }
            .padding(.all, 1.0)
        }
    }
}

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = NearbyStationsViewModel()
    @State private var lastUpdate = Date(timeIntervalSince1970: 0)
    @State private var searchText = ""

    var body: some View {
        VStack {
            NavigationView {
                List {
                    if searchText.isEmpty {
                        ForEach(viewModel.stations) { station in
                            NavigationLink(
                                destination: DepartureView(station: station)
                            ) {
                                StationRow(station: station)
                            }
                        }
                    } else {
                        ForEach(
                            allStations.filter {
                                $0.name.lowercased().contains(
                                    searchText.lowercased())
                            }
                        ) { station in
                            NavigationLink(
                                destination: DepartureView(station: station)
                            ) {
                                StationRow(station: station)
                            }
                        }
                    }
                }
                .navigationTitle("Stations")
                .searchable(text: $searchText)
            }

            if let coordinate = locationManager.lastKnownLocation {
                Spacer()
                    .onAppear {
                        viewModel.updateNearbyStations(
                            for: coordinate.latitude,
                            longitude: coordinate.longitude)
                    }
                    .onChange(of: locationManager.lastKnownLocation) {
                        oldLocation, newLocation in
                        if let newLocation = newLocation {
                            let now = Date()
                            if now.timeIntervalSince(lastUpdate) > 5 {
                                lastUpdate = now
                                viewModel.updateNearbyStations(
                                    for: newLocation.latitude,
                                    longitude: newLocation.longitude)
                            }
                        }
                    }
            } else {
                Text("Unknown Location")

                Button("Get location") {
                    locationManager.checkLocationAuthorization()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

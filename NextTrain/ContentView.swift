//
//  ContentView.swift
//  NextTrain
//
//  Created by aimee rivers on 25/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = NearbyStationsViewModel()

    var body: some View {
        VStack {

            NavigationView {
                List(viewModel.stations) { station in
                    NavigationLink(destination: DepartureView(station: station))
                    {
                        VStack(alignment: .leading) {
                            Text(station.name)
                                .font(.headline)
                            Text("\(station.distance) meters away")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("Nearby Stations")
            }

            if let coordinate = locationManager.lastKnownLocation {
                Text("Latitude: \(coordinate.latitude)")

                Text("Longitude: \(coordinate.longitude)")
            } else {
                Text("Unknown Location")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  NextTrain
//
//  Created by aimee rivers on 25/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = NearbyStopsViewModel()

    var body: some View {
        VStack {

            NavigationView {
                List(viewModel.stops) { stop in
                    NavigationLink(destination: DepartureView(stop: stop)) {
                        VStack(alignment: .leading) {
                            Text(stop.name)
                                .font(.headline)
                            Text("\(stop.distance) meters away")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("Nearby Stops")
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

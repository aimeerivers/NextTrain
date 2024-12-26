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
                            if let distance = station.distanceFormatted {
                                Text(distance)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .navigationTitle("Nearby Stations")
            }

            if let coordinate = locationManager.lastKnownLocation {
                Text(
                    "Location: \(coordinate.latitude), \(coordinate.longitude)"
                ).dynamicTypeSize(.xSmall)
                    .onAppear {
                        viewModel.updateNearbyStations(
                            for: coordinate.latitude,
                            longitude: coordinate.longitude)
                    }
                    .onChange(of: locationManager.lastKnownLocation) {
                        oldLocation, newLocation in
                        if let oldLocation = oldLocation,
                            let newLocation = newLocation
                        {
                            let distance = CLLocation(
                                latitude: oldLocation.latitude,
                                longitude: oldLocation.longitude
                            )
                            .distance(
                                from: CLLocation(
                                    latitude: newLocation.latitude,
                                    longitude: newLocation.longitude))
                            if distance > 5 {
                                viewModel.updateNearbyStations(
                                    for: newLocation.latitude,
                                    longitude: newLocation.longitude)
                            }
                        }
                    }
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

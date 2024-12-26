//
//  NearbyStationsViewModel.swift
//  NextTrain
//
//  Created by aimee rivers on 25/12/2024.
//

import Foundation

class NearbyStationsViewModel: ObservableObject {
    @Published var stations: [Station] = []

    func updateNearbyStations(for latitude: Double, longitude: Double) {
        let closestStations = findClosestStations(
            to: latitude, longitude: longitude, count: 10, from: allStations)
        DispatchQueue.main.async {
            self.stations = closestStations
        }
    }
}

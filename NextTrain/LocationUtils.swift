//
//  LocationUtils.swift
//  NextTrain
//
//  Created by aimee rivers on 26/12/2024.
//

import CoreLocation
import Foundation

// Station model
struct Station: Identifiable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double

    var distance: Double?  // To store the calculated distance for display
    var distanceFormatted: String? {
        guard let distance = distance else { return nil }
        return String(format: "%.1f meters", distance)
    }
}

// Utility functions
func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double)
    -> Double
{
    let earthRadius = 6371000.0  // Earth's radius in meters
    let dLat = (lat2 - lat1).degreesToRadians
    let dLon = (lon2 - lon1).degreesToRadians
    let a =
        sin(dLat / 2) * sin(dLat / 2) + cos(lat1.degreesToRadians)
        * cos(lat2.degreesToRadians) * sin(dLon / 2) * sin(dLon / 2)
    let c = 2 * atan2(sqrt(a), sqrt(1 - a))
    return earthRadius * c
}

extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
}

func findClosestStations(
    to latitude: Double, longitude: Double, count: Int, from stations: [Station]
) -> [Station] {
    let sortedStations = stations.map { station -> Station in
        var updatedStation = station
        updatedStation.distance = haversineDistance(
            lat1: latitude, lon1: longitude, lat2: station.latitude,
            lon2: station.longitude)
        return updatedStation
    }.sorted {
        ($0.distance ?? Double.greatestFiniteMagnitude)
            < ($1.distance ?? Double.greatestFiniteMagnitude)
    }
    return Array(sortedStations.prefix(count))
}

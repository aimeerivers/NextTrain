//
//  NearbyStationsViewModel.swift
//  NextTrain
//
//  Created by aimee rivers on 25/12/2024.
//

import SwiftUI

struct Station: Identifiable {
    let id: String
    let name: String
    let distance: Int
}

class NearbyStationsViewModel: ObservableObject {
    @Published var stations: [Station] = [
        Station(id: "MPT", name: "Malmparken", distance: 2180),
        Station(id: "SKO", name: "Skovlunde", distance: 2360),
        Station(id: "BA", name: "Ballerup", distance: 2650),
        Station(id: "KH", name: "København H", distance: 11910),
        Station(id: "KN", name: "Nørreport", distance: 12000),
    ]
}

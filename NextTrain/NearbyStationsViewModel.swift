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
        Station(id: "MPT", name: "Malmparken Station", distance: 2180),
        Station(id: "SKO", name: "Skovlunde Station", distance: 2360),
        Station(id: "BA", name: "Ballerup Station", distance: 2650),
    ]
}

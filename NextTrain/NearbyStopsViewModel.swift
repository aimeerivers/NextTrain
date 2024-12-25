//
//  NearbyStopsViewModel.swift
//  NextTrain
//
//  Created by aimee rivers on 25/12/2024.
//

import SwiftUI

struct Stop: Identifiable {
    let id: String
    let name: String
    let distance: Int
}

class NearbyStopsViewModel: ObservableObject {
    @Published var stops: [Stop] = [
        Stop(id: "MPT", name: "Malmparken Station", distance: 2180),
        Stop(id: "SKO", name: "Skovlunde Station", distance: 2360),
        Stop(id: "BA", name: "Ballerup Station", distance: 2650),
    ]
}

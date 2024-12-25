//
//  DepartureView.swift
//  NextTrain
//
//  Created by aimee rivers on 25/12/2024.
//

import SwiftUI

struct DepartureView: View {
    let station: Station

    var body: some View {
        VStack {
            Text("Departures for \(station.name)")
                .font(.title)
                .padding()

            // Simulate departure data
            List {
                Text("Train A - 5 minutes")
                Text("Train B - 10 minutes")
                Text("Train C - 15 minutes")
            }
        }
        .navigationTitle(station.name)
    }
}

#Preview {
    DepartureView(
        station: Station(id: "SKO", name: "Skovlunde Station", distance: 200))
}

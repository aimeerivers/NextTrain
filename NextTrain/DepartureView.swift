//
//  DepartureView.swift
//  NextTrain
//
//  Created by aimee rivers on 25/12/2024.
//

import SwiftUI

struct DepartureView: View {
    let stop: Stop

    var body: some View {
        VStack {
            Text("Departures for \(stop.name)")
                .font(.title)
                .padding()

            // Simulate departure data
            List {
                Text("Train A - 5 minutes")
                Text("Train B - 10 minutes")
                Text("Train C - 15 minutes")
            }
        }
        .navigationTitle(stop.name)
    }
}

#Preview {
    DepartureView(
        stop: Stop(id: "stop1", name: "Central Station", distance: 200))
}

//
//  DepartureDetailView.swift
//  NextTrain
//
//  Created by aimee rivers on 30/12/2024.
//

import SwiftUI

struct DepartureDetailView: View {
    let departure: Departure

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(departure.LineName.capitalized)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(
                        departure.LineName == "F"
                            ? .black : .white
                    )
                    .padding(.horizontal, 5.0)
                    .background(
                        Color(departure.LineName)
                    )

                VStack(alignment: .leading) {
                    Text(
                        stationName(for: departure.TargetStation[0])
                    )
                    .font(.headline)

                    if departure.Routes[0]
                        .ViaStation
                        != departure.TargetStation[0],
                        let viaStation =
                            viaStationName(
                                for: departure.Routes[0].ViaStation)
                    {
                        Text("via \(viaStation)")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
                .padding(.leading, 5.0)

                Spacer()
            }
            Text("Train ID: \(departure.id)")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding()
            Spacer()
        }
        .navigationTitle("Departure Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DepartureDetailView(departure: Departure.sample)
}

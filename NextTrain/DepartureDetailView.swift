//
//  DepartureDetailView.swift
//  NextTrain
//
//  Created by aimee rivers on 30/12/2024.
//

import SwiftUI

struct DepartureDetailView: View {
    let departure: Departure
    @State private var isLoading = true

    var body: some View {
        VStack(alignment: .leading) {
            if isLoading {
                ProgressView("Loading details...")
            } else {
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

                    VStack {
                        if departure.TrainDelayed {
                            Text(
                                formattedTime(
                                    from: departure.ScheduleTimeDeparture)
                            )
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .strikethrough()
                        }
                        Text(
                            formattedTime(
                                from: departure.EstimatedTimeDeparture)
                        ).bold()
                    }

                }
                Text("Train ID: \(departure.id)")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }
        }
        .navigationTitle("Departure Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                isLoading = false
            }
        }
    }
}

#Preview {
    DepartureDetailView(departure: Departure.sample)
}

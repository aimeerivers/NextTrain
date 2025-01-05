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
    @State private var stations: [RouteStation] = []
    @State private var animateTrainImages = false

    @Environment(\.colorScheme) var colorScheme

    var trainPicture: String {
        departure.Routes.map { $0.UnitType }.joined(separator: "-")
    }

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
                        .frame(width: 21.0)
                        .padding(.horizontal, 5.0)
                        .padding(.vertical, 3.0)
                        .background(
                            Color(departure.LineName)
                        )
                        .cornerRadius(3.0)

                    VStack(alignment: .leading) {
                        Text(
                            stationName(for: departure.TargetStation[0])
                        )
                        .font(.headline)
                        .foregroundColor(
                            departure.IsCancelled ? .red : .primary
                        )
                        .strikethrough(departure.IsCancelled)

                        if departure.IsCancelled {
                            Text("Cancelled")
                                .foregroundColor(.red)
                                .font(.subheadline)
                        } else {
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
                    }
                    .padding(.leading, 5.0)

                    Spacer()

                    if departure.IsCancelled {
                        Text(
                            formattedTime(
                                from: departure.ScheduleTimeDeparture)
                        )
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .strikethrough()
                    } else {
                        if !departure.AwaitingTime {
                            VStack {
                                if departure.DepartureTimeDifference {
                                    Text(
                                        formattedTime(
                                            from: departure
                                                .ScheduleTimeDeparture)
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
                    }

                }

                ScrollView {
                    if !departure.IsCancelled {
                        HStack {
                            Image(trainPicture)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 15.0)
                                .padding()
                                .adaptToColorScheme(colorScheme)
                                .scaleEffect(
                                    x: departure.DepartureDirection == "DOWN"
                                        ? -1 : 1, y: 1
                                )
                                .offset(
                                    x: animateTrainImages
                                        ? 0
                                        : (departure.DepartureDirection
                                            == "DOWN"
                                            ? UIScreen.main.bounds.width
                                            : -UIScreen.main.bounds.width)
                                )
                                .animation(
                                    .easeInOut(duration: 0.5),
                                    value: animateTrainImages
                                )
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(
                                        deadline: .now() + 0.1
                                    ) {
                                        animateTrainImages = true
                                    }
                                }
                        }

                        LazyVGrid(columns: [
                            GridItem(.fixed(50), alignment: .leading),
                            GridItem(.flexible(), alignment: .leading),
                        ]) {
                            ForEach(stations, id: \.StationId) { station in
                                Text(
                                    formattedTime(
                                        from: station.ExpectedDateTime)
                                )
                                .font(.subheadline)
                                .foregroundColor(
                                    station.IsCancelled ? .red : .primary
                                )
                                .strikethrough(station.IsCancelled)
                                Text(stationName(for: station.StationId))
                                    .font(.subheadline)
                                    .foregroundColor(
                                        station.IsCancelled ? .red : .primary
                                    )
                                    .strikethrough(station.IsCancelled)
                            }
                            .padding(.all, 1.0)
                        }
                    }

                    HStack {
                        Text("Train ID: \(departure.id)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.top)

                        Spacer()
                    }
                }

                Spacer()
            }
        }
        .navigationTitle("Departure Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                isLoading = false
                stations = departure.Routes[0].Stations
            }
        }
    }
}

extension View {
    func adaptToColorScheme(_ colorScheme: ColorScheme = .light) -> some View {
        switch colorScheme {
        case .dark:
            return AnyView(self.colorInvert())
        default:
            return AnyView(self)
        }
    }
}

#Preview {
    DepartureDetailView(departure: Departure.sample)
}

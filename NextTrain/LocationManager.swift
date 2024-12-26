//
//  LocationManager.swift
//  NextTrain
//
//  Created by aimee rivers on 25/12/2024.
//

import CoreLocation
import Foundation
import UIKit

final class LocationManager: NSObject, CLLocationManagerDelegate,
    ObservableObject
{

    @Published var lastKnownLocation: CLLocationCoordinate2D?
    var manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()  // Start location updates automatically
    }

    func checkLocationAuthorization() {

        manager.delegate = self
        manager.startUpdatingLocation()

        switch manager.authorizationStatus {
        case .notDetermined:  //The user choose allow or denny your app to get the location yet
            manager.requestWhenInUseAuthorization()

        case .restricted:  //The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print("Location restricted")

        case .denied:  //The user dennied your app to get location or disabled the services location or the phone is in airplane mode
            print("Location denied")
            promptToOpenSettings()

        case .authorizedAlways:  //This authorization allows you to use all location services and receive location events whether or not your app is in use.
            print("Location authorizedAlways")

        case .authorizedWhenInUse:  //This authorization allows you to use all location services and receive location events only when your app is in use
            print("Location authorized when in use")
            lastKnownLocation = manager.location?.coordinate

        @unknown default:
            print("Location service disabled")

        }
    }

    private func promptToOpenSettings() {
        let alert = UIAlertController(
            title: "Location Permission Denied",
            message: "Please enable location permissions in Settings.",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(
            UIAlertAction(title: "Settings", style: .default) { _ in
                guard
                    let settingsUrl = URL(
                        string: UIApplication.openSettingsURLString)
                else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(
                        settingsUrl, options: [:], completionHandler: nil)
                }
            })

        if let topController = UIApplication.shared.windows.first?
            .rootViewController
        {
            topController.present(alert, animated: true, completion: nil)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {  //Trigged every time authorization status changes
        checkLocationAuthorization()
    }

    func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        lastKnownLocation = locations.first?.coordinate
    }
}

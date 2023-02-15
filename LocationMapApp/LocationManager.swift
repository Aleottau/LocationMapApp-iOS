//
//  LocationManager.swift
//  LocationMapApp
//
//  Created by alejandro on 17/01/23.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationManagerDelegate: AnyObject {
    func currentLocation(location: CLLocation, placeMark: CLPlacemark)
}
protocol LocationManagerProtocol: AnyObject {
    var delegate: LocationManagerDelegate? { get set }
    func requestAutorization()
    func startLocation()
    func validateStatusAuthorization()
}

class LocationManager: NSObject {
    
    weak var delegate: LocationManagerDelegate?
    let locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
    }
    private func setUpLocation() {
        locationManager.delegate = self
        locationManager.distanceFilter = 5
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
    }
}

extension LocationManager: LocationManagerProtocol {
    func validateStatusAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            requestAutorization()
            startLocation()
        case .restricted:
            requestAutorization()
            startLocation()
        case .denied:
             requestAutorization()
             startLocation()
        case .authorizedAlways:
            startLocation()
        case .authorizedWhenInUse:
            startLocation()
        @unknown default:
            print("unknow values in authorization status")
        }
    }
    func startLocation() {
        setUpLocation()
        locationManager.startUpdatingLocation()
    }
    func requestAutorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
       let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard error == nil, let placemark = placemarks?.last else {
                print("reverse geodcode fail: \(String(describing: error?.localizedDescription))")
                return
            }
            self?.delegate?.currentLocation(location: location, placeMark: placemark)
        }
    }
}

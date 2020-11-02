//
//  LocationManager.swift
//  MapKitAndCoreLocation
//
//  Created by Jijo Pulikkottil on 20/09/20.
//  Copyright © 2020 MVoc. All rights reserved.
//

//1. Remember to add privacy key in info.plist
//2. Request as per you need Always or WhenInUse. Remember that from iOS 13, OS won't display 'Always' prompt immediatly. Instead OS will ask 'Always' promt for your app later.

import Foundation
import CoreLocation
import Contacts

protocol LocationUpdateDelegate: class {
    func updateToLocation(_ location: CLLocationCoordinate2D)
}

protocol RegionMonitoringDelegate: class {
    func enteredToRegion(identifier: String)
    func exitedFromRegion(identifier: String)
}

class LocationManager: NSObject {
    
    enum Address: String {
        case street
        case subLocality
        case city
        case subAdministrativeArea
        case state
        case postalCode
        case country
    }
    
    let locationManager = CLLocationManager()
    weak var locationUpdateDelegate: LocationUpdateDelegate?
    open weak var regionMonitoringDelegate: RegionMonitoringDelegate? {
        didSet {
            locationManager.allowsBackgroundLocationUpdates = true
        }
    }
    var monitoringRegions: [String: CLRegion] = [:]
    
    open var coordinate: CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }
    
    open func initializeWithLocationUpdate(delegate: LocationUpdateDelegate) {
        self.locationUpdateDelegate = delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorize()
        locationManager.startUpdatingLocation()
    }
    
    open func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    open func initializeWithReginMonitoring(delegate: RegionMonitoringDelegate) {
        self.regionMonitoringDelegate = delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorize()
        locationManager.startUpdatingLocation()
    }
    
    open func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String, radius: CLLocationDistance) {
        // Make sure the app is authorized.
        // Make sure region monitoring is supported.
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // Register the region.
            let maxDistance = min(radius, locationManager.maximumRegionMonitoringDistance)
            let region = CLCircularRegion(center: center,
                                          radius: maxDistance, identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            monitoringRegions[identifier] = region
            
            locationManager.startMonitoring(for: region)
            locationManager.requestState(for: region)
        }
    }
    
    open func stopMonitoringRegion(identifier: String) {
        guard let region = monitoringRegions[identifier] else { return }
        locationManager.stopMonitoring(for: region)
    }
}


//MARK: - Private functions
private extension LocationManager {
    func authorize() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        switch CLLocationManager.authorizationStatus() {
        
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationUpdateDelegate?.updateToLocation(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorize()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let identifier = region.identifier
        regionMonitoringDelegate?.enteredToRegion(identifier: identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        regionMonitoringDelegate?.exitedFromRegion(identifier: region.identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(String(describing: region)) \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        //print("didDetermineState \(state.rawValue)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
    }
}


//MARK: Geocoder
extension LocationManager {
    class func addressForCoordinate(from coordinate: CLLocationCoordinate2D, completion: @escaping (_ addresDict: [LocationManager.Address: String?], _ error: Error?) -> Void) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en")) { placemarks, error in
            
            var address: [LocationManager.Address: String?] = [:]
            
            
            let pAddress = placemarks?.first?.postalAddress
            
            address[LocationManager.Address.street] = pAddress?.street
            address[LocationManager.Address.subLocality] = pAddress?.subLocality
            address[LocationManager.Address.city] = pAddress?.city
            address[LocationManager.Address.subAdministrativeArea] = pAddress?.subAdministrativeArea
            address[LocationManager.Address.state] = pAddress?.state
            address[LocationManager.Address.postalCode] = pAddress?.postalCode
            address[LocationManager.Address.country] = pAddress?.country
            completion(address, error)
        }
    }
    
    class func coordinatesFromAddress(_ address: String, handler: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) {(placemarks, _ ) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                handler(nil)
                return
            }
            handler(location.coordinate)
        }
    }
}

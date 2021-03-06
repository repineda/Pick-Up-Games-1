//
//  MapScreen.swift
//  Pick-Up Games
//
//  Created by Amir Babaei on 11/5/18.
//  Copyright © 2018 Amir Babaei. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapScreen: UIViewController {

  @IBOutlet var MapView: MKMapView!
  @IBOutlet var addressLabel: UILabel!
  
  let locationManager = CLLocationManager()
  let regionInMeters: Double = 5000
  var previousLocation: CLLocation?
  
  override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
  
  func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  
  func centerViewOnUserLocation() {
    if let location = locationManager.location?.coordinate {
      let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
      MapView.setRegion(region, animated: true)
    }
  }
  
  
  func checkLocationServices() {
    if CLLocationManager.locationServicesEnabled() {
      setupLocationManager()
      checkLocationAuthorization()
    } else {
      // Show alert letting the user know they have to turn this on.
    }
  }
  
  
  func checkLocationAuthorization() {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedWhenInUse:
      startTackingUserLocation()
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
    }
  }
  
  func startTackingUserLocation() {
    MapView.showsUserLocation = true
    centerViewOnUserLocation()
    locationManager.startUpdatingLocation()
    previousLocation = getCenterLocation(for: MapView)
  }
  
  
  
  func getCenterLocation(for mapView: MKMapView) -> CLLocation {
    let latitude = mapView.centerCoordinate.latitude
    let longitude = mapView.centerCoordinate.longitude
    
    return CLLocation(latitude: latitude, longitude: longitude)
  }
}



extension MapScreen: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //needs work
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkLocationAuthorization()
  }
}



extension MapScreen: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    let center = getCenterLocation(for: mapView)
    let geoCoder = CLGeocoder()
    
    guard let previousLocation = self.previousLocation else { return }
    
    guard center.distance(from: previousLocation) > 50 else { return }
    self.previousLocation = center
    
    geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
      guard let self = self else { return }
      
      if let _ = error {
        //TODO: Show alert informing the user
        return
      }
      
      guard let placemark = placemarks?.first else {
        //TODO: Show alert informing the user
        return
      }
      
      let streetNumber = placemark.subThoroughfare ?? ""
      let streetName = placemark.thoroughfare ?? ""
      let cityName = placemark.locality ?? ""
      let locationName = placemark.name ?? ""
      
      DispatchQueue.main.async {
       // if (locationName != (" \(streetNumber) \(streetName)")){
           //self.addressLabel.text = " \(locationName) \n"
       // }
        self.addressLabel.text = " \(streetNumber) \(streetName)\n \(cityName)"
      }
    }
  }
}

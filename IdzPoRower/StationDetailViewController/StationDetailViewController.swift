//
//  StationDetailViewController.swift
//  IdzPoRower
//
//  Created by Mateusz Danieluk on 12/11/2020.
//

import UIKit
import MapKit
import CoreLocation

class StationDetailViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bikeStationView: BikeStationView!
    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    let regionInMeters: Double = 1000
    var properties: Properties!
    var street = ""
    var city = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    var distance = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        prepareData()
        
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        mapView.addAnnotation(annotation)
    }
    
    func prepareData() {
        bikeStationView.configureData(station: properties, street: street, city: city, stationDistance: distance)
    }
    
}

extension StationDetailViewController: CLLocationManagerDelegate {
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
}

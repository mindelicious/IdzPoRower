//
//  StationsViewController.swift
//  IdzPoRower
//
//  Created by Mateusz Danieluk on 10/11/2020.
//

import UIKit
import Alamofire
import MapKit
import CoreLocation

class StationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let locationManager = CLLocationManager()
    
    var activityView: UIActivityIndicatorView?
    var stationArray: [Feature] = []
    var responseData: [Feature] = []
    var distance = 0.0
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        getStation()
        prepareTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationServices()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    
    func geocode(latitude: Double,  longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }
    
    func getStation() {
        let stationFetched: (Result<Station, AFError>) -> Void = { [weak self] result in
            self?.gotResponse(result: result)
            }
        NetworkManager().getBikeStation(onStationGet: stationFetched)
    }
    
    func gotResponse(result: Result<Station, AFError>) {
       showActivityIndicator()
        switch result {
        case .success(let station):
            responseData = station.features
        
            responseData.forEach { feature in
                geocode(latitude: feature.geometry.coordinates[1], longitude: feature.geometry.coordinates[0]) { [weak self] placemark, error in
                    DispatchQueue.main.async { [self] in
                        
                        let stationDistance = CLLocation(latitude: feature.geometry.coordinates[1], longitude: feature.geometry.coordinates[0])
                        var stationLoc = feature
                        
                        stationLoc.geometry.streetAddress = placemark?.thoroughfare
                        stationLoc.geometry.city = placemark?.locality
                        self?.stationArray.append(stationLoc)
                        if let currentLocation = self?.currentLocation {
                            let roundedDistance = (stationDistance.distance(from: currentLocation)).rounded()
                            self?.distance = Double(roundedDistance)
                        }
                       
                        if self?.stationArray.count == self?.responseData.count {
                            self?.tableView.reloadData()
                        }
                        
                    }
                }
            }
            
            hideActivityIndicator()
        case .failure(_):
            presentAlert(title: "somethings_goes_wrong".localized(), message: nil)
        }
    }

    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .gray)
        tableView.isHidden = true
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    func hideActivityIndicator() {
        if (activityView != nil) {
            tableView.isHidden = false
            activityView?.stopAnimating()
        }
    }
    
    func presentAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: { [weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }

}

extension StationsViewController: UITableViewDelegate, UITableViewDataSource {

    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: Constants.bikeStationCell, bundle: nil), forCellReuseIdentifier: Constants.bikeStation)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let station = stationArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bikeStation, for: indexPath) as! BikeStationCell
        
        cell.showData(station: station.properties,
                      stationStreet: station.geometry.streetAddress,
                      stationCity: station.geometry.city,
                      stationDistance: distance)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = stationArray[indexPath.row]
        let storyboard = UIStoryboard(name: "StationDetail", bundle: nil)
        let stationDetailViewController = storyboard.instantiateViewController(withIdentifier: Constants.stationDetail) as! StationDetailViewController
        
        stationDetailViewController.properties = station.properties
        stationDetailViewController.street = station.geometry.streetAddress ?? "no_data".localized()
        stationDetailViewController.city = station.geometry.city ?? ""

        stationDetailViewController.lat = station.geometry.coordinates[1]
        stationDetailViewController.lon = station.geometry.coordinates[0]
        stationDetailViewController.distance = distance
        
        navigationController?.pushViewController(stationDetailViewController, animated: true)
    }

}

extension StationsViewController: CLLocationManagerDelegate {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            presentAlert(title: "location_disabled_title".localized(), message: "location_disabled_message".localized())
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            presentAlert(title: "location_disabled_title".localized(), message: "location_disabled_message".localized())
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkLocationAuthorization()
            }
        }
}

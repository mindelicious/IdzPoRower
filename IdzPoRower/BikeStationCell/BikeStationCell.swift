//
//  BikeStationCell.swift
//  IdzPoRower
//
//  Created by Mateusz Danieluk on 10/11/2020.
//

import UIKit

class BikeStationCell: UITableViewCell {
    
    @IBOutlet weak var bikeStationView: BikeStationView!

    func showData(station: Properties, stationStreet: String?, stationCity: String?, stationDistance: Double) {
        bikeStationView.configureData(station: station, street: stationStreet, city: stationCity, stationDistance: stationDistance)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bikeStationView.stationName.text = nil
        bikeStationView.bikes.text = nil
        bikeStationView.freeRacks.text = nil
        bikeStationView.bikes.textColor = .systemGreen
        bikeStationView.stationAddress.text = nil
    }
}

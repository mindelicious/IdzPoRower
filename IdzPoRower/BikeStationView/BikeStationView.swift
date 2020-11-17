//
//  BikeStationView.swift
//  IdzPoRower
//
//  Created by Mateusz Danieluk on 12/11/2020.
//

import UIKit

final class BikeStationView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var stationAddress: UILabel!
    @IBOutlet weak var bikes: UILabel!
    @IBOutlet weak var freeRacks: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var availableBikes: UILabel!
    @IBOutlet weak var availablePlaces: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var noBikeAvaiableColor: UIColor {
        if Int(bikes.text!) == 0 {
            return .systemRed
        } else {
            return .systemGreen
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
    
    
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "BikeStationView") else { return }
        view.frame = bounds
        self.addSubview(view)
    }
    
    func configureData(station: Properties, street: String?, city: String?, stationDistance: Double) {
        availableBikes.text = "available_bikes".localized()
        availablePlaces.text = "available_places".localized()
        stationName.text = station.label
        bikes.text = station.bikes
        freeRacks.text = station.freeRacks
        stationAddress.text = street
        cityLabel.text = city
        
        let stringDistance = String(stationDistance)
        distance.text = String(format: "distance".localized(), stringDistance)
        bikes.textColor = noBikeAvaiableColor
    }
}

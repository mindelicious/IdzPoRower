//
//  Properties.swift
//  IdzPoRower
//
//  Created by Mateusz Danieluk on 11/11/2020.
//

import Foundation

struct Properties: Codable {
    var bikes: String
    var freeRacks: String
    var label: String
    
    enum CodingKeys: String, CodingKey {
        case bikes
        case label
        case freeRacks = "free_racks"
    }
}

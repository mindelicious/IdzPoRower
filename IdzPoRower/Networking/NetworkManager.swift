//
//  NetworkManager.swift
//  IdzPoRower
//
//  Created by Mateusz Danieluk on 11/11/2020.
//

import UIKit
import Alamofire

class NetworkManager {
    
    func getBikeStation(onStationGet: @escaping (Result<Station, AFError>) -> Void) {
        let url: URL = URL(string: "http://www.poznan.pl/mim/plan/map_service.html?mtype=pub_transport&co=stacje_rowerowe")!
        
        AF.request(url).responseDecodable(of: Station.self) { response in
            onStationGet(response.result)
        }
    }
}


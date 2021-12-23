//
//  SportsRespones.swift
//  Sports2
//
//  Created by Manish raj(MR) on 23/12/21.
//

import Foundation

struct Stadium: Codable {
    let stadiumID: Int
    let name: String
    let city: String
    let state: String?
    let geoLat: Double
    let geoLon: Double
    
    
    enum CodingKeys: String, CodingKey {
        case stadiumID = "StadiumID"
        case name = "Name"
        case city = "City"
        case state = "State"
        case geoLat = "GeoLat"
        case geoLon = "GeoLong"
        
    }
}

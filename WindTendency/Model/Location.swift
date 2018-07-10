//
//  Location.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 29..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import Foundation

struct Location: Codable, Equatable {
    
    
    let name: String
    let coordinates: Coordinates
    
    init(_ name: String, coordinates: Coordinates) {
        self.name = name
        self.coordinates = coordinates
    }
    
    init(_ name: String, coordinates: (Double, Double)) {
        self.name = name
        self.coordinates = Coordinates(coordinates)
    }
}

struct Coordinates: Codable, Comparable {
    
    let latitude: Double
    let longitude: Double
    
    private var length: Double {
        let powLatitude = pow(latitude, 2)
        let powLongitude = pow(longitude, 2)
        return sqrt(powLatitude + powLongitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ coordinates: (Double, Double)) {
        self.init(latitude: coordinates.0, longitude: coordinates.1)
    }
    
    static func +(lhs: Coordinates, rhs: Coordinates) -> Coordinates {
        return Coordinates((lhs.latitude + rhs.latitude, lhs.longitude + rhs.longitude))
    }
    
    static func -(lhs: Coordinates, rhs: Coordinates) -> Coordinates {
        return Coordinates((lhs.latitude - rhs.latitude, lhs.longitude - rhs.longitude))
    }
    
    static func < (lhs: Coordinates, rhs: Coordinates) -> Bool {
        return lhs.length < rhs.length
    }
}


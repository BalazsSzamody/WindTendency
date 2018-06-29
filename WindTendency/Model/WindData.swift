//
//  WindMeasurement.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 10. 14..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import Foundation
import UIKit

struct WindData: Codable {
    var spotName: String
    var data: [MeasurementData]
    
    init(spotName: String, data: [MeasurementData]) {
        self.spotName = spotName
        self.data = data
    }
    
    init() {
        spotName = ""
        data = []
    }
    
    mutating func setSpotName(_ name: String) {
        spotName = name
    }
    
    mutating func addMeasurement(_ data: MeasurementData) {
        self.data.append(data)
    }
}

struct MeasurementData: Codable, Equatable {
    let direction: CGFloat
    let speed: CGFloat
    let date: Date
    
    static func ==(lhs: MeasurementData, rhs: MeasurementData) -> Bool {
        return lhs.date == rhs.date && lhs.direction == rhs.direction && lhs.speed == rhs.speed
    }
}



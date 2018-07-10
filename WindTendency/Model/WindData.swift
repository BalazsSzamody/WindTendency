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
    private var _data: [MeasurementData]
    
    var data: [MeasurementData] {
        return _data
    }
    
    init(data: [MeasurementData]) {
        self._data = data
    }
    
    init() {
        _data = []
    }
    
    mutating func addMeasurement(_ data: MeasurementData) {
        self._data.append(data)
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



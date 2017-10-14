//
//  WindMeasurement.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 10. 14..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import Foundation

struct WindData {
    let direction: Double
    let speed: Double
    let date: Date
    
    init(rawDirection: Double, speed: Double, date: Date) {
        direction = WindData.setDirection(rawDirection)
        self.speed = speed
        self.date = date
    }
    
    static func setDirection(_ rawDirection: Double) -> Double {
        if rawDirection > 360 {
            return rawDirection.truncatingRemainder(dividingBy: 360)
        } else if rawDirection < 0 {
            return setDirection(rawDirection)
        } else {
            return rawDirection
        }
    }
}

//
//  WindMeasurement.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 10. 14..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import Foundation
import UIKit

struct WindData {
    let direction: CGFloat
    let speed: CGFloat
    let date: Date
    
    init(rawDirection: CGFloat, speed: CGFloat, date: Date) {
        direction = WindData.setDirection(rawDirection)
        self.speed = speed
        self.date = date
    }
    
    static func setDirection(_ rawDirection: CGFloat) -> CGFloat {
        if rawDirection > 360 {
            return rawDirection.truncatingRemainder(dividingBy: 360)
        } else if rawDirection < 0 {
            return setDirection(360 - rawDirection)
        } else if rawDirection == 360 {
            return 0
        } else {
            return rawDirection
        }
    }
    static func convertDirection(_ windData: [WindData]) -> [CircleChartPoint]? {
        guard !windData.isEmpty else { return nil }
        var points: [CircleChartPoint] = []
        
        for entry in windData {
            points.append(CircleChartPoint(direction: entry.direction, date: entry.date))
        }
        return points
    }
    
    static func convertSpeed(_ windData: [WindData]) -> [CGPoint]? {
        guard !windData.isEmpty else { return nil }
        var points: [CGPoint] = []
        let startDate = windData[0].date
        
        for entry in windData {
            let x = CGFloat(entry.date.timeIntervalSince(startDate))
            let y = entry.speed
            
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }
}


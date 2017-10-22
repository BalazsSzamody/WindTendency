//
//  CircleChartPoint.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 10. 21..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import Foundation
import UIKit

struct CircleChartPoint{
    let direction: CGFloat
    let date: Date
    
    static func convertToPoint(_ input: [CircleChartPoint]?) -> [CGPoint]? {
        guard let input = input else { return nil }
        guard !input.isEmpty else { return nil }
        var points: [CGPoint] = []
        
        let dates = input.map() { $0.date }
        let dateMax = dates.max()!
        for entry in input{
            points.append(CGPoint(angle: entry.direction, length: CircleChart.max * CGFloat(entry.date.timeIntervalSinceReferenceDate / dateMax.timeIntervalSinceReferenceDate)))
        }
        return points
    }
}

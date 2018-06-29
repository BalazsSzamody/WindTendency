//
//  StubWindData.swift
//  WindTendencyTests
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 27..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import UIKit
@testable import WindTendency

struct StubWindData {
    static var stubData: WindData {
        let measurement: [(CGFloat, CGFloat)] = [(45, 10), (50, 7), (60, 6), (65, 2), (70, 19), (75, 3), (80, 7), (85, 7), (90, 6), (95, 12)]
        
        let measurementWithDate: [(CGFloat, CGFloat, Date)] = measurement.enumerated().map { (arg) -> (CGFloat, CGFloat, Date) in
            
            let (i, element) = arg
            return (element.0, element.1, Date(timeIntervalSinceReferenceDate: 0).addingTimeInterval(TimeInterval(i) * 120))
        }
        
        let data = measurementWithDate.map { MeasurementData(direction: $0.0, speed: $0.1, date: $0.2)}
        
        let name = "Test Location"
        
        return WindData(spotName: name, data: data)
    }
}

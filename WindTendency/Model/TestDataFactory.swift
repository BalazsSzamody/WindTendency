//
//  TestDataFactory.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 26..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import Foundation
import UIKit

struct TestDataFactory {
    enum TestDataType {
        case random
        case spiral
        case peeked
    }
    
    typealias TestAlgorithm = (CGFloat) -> CGFloat
    
    let type: TestDataType
    
    let dataCount: Int
    
    let startAngle: CGFloat
    
    let startSpeed: CGFloat
    
    var testData: WindData {
        let testData: [MeasurementData]
        switch type {
        case .random:
            testData = randomWindData()
        case .spiral:
            testData = spiralWindData()
        case .peeked:
            testData = peekedWindData()
        }
        
        return WindData(data: testData)
    }
    
    func randomWindData() -> [MeasurementData] {
        return simulateWindData(count: dataCount, directionAlgo: followingRandom(_:), speedAlgo: followingRandom(_:), angle: startAngle, speed: startSpeed)
    }
    
    func spiralWindData() -> [MeasurementData] {
        return simulateWindData(count: dataCount, directionAlgo: linearChange(_:), speedAlgo: followingRandom(_:), angle: startAngle, speed: startSpeed)
    }
    
    func peekedWindData() -> [MeasurementData] {
        return []
    }
    
    private func simulateWindData(count: Int, directionAlgo: TestAlgorithm, speedAlgo: TestAlgorithm, angle: CGFloat, speed: CGFloat, date: Date = Date()) -> [MeasurementData] {
        guard count != 0 else {
            return [MeasurementData(direction: angle, speed: speed, date: date)]
        }
        let nextAngle = normalisedDirectionResult(of: directionAlgo, input: angle)
        let nextSpeed = normalisedSpeedResult(of: speedAlgo, input: speed)
        let nextDate = date.addingTimeInterval(120)
        let currentData = MeasurementData(direction: angle, speed: speed, date: date)
        
        return [currentData] + simulateWindData(count: count - 1, directionAlgo: directionAlgo, speedAlgo: speedAlgo, angle: nextAngle, speed: nextSpeed, date: nextDate)
        
    }
    
    private func normalisedSpeedResult(of speedAlgo: TestAlgorithm, input: CGFloat) -> CGFloat {
        let speed = speedAlgo(input)
        if speed < 0 {
            return normalisedSpeedResult(of: speedAlgo, input: input)
        } else {
            return speed
        }
    }
    
    private func normalisedDirectionResult(of directionAlgo: TestAlgorithm, input: CGFloat) -> CGFloat {
        let angle = directionAlgo(input)
        
        if angle > 360 {
            return angle.truncatingRemainder(dividingBy: 360)
        } else if angle < 0 {
            return normalisedDirectionResult(of: directionAlgo, input: 360 - angle)
        } else if angle == 360 {
            return 0
        } else {
            return angle
        }
    }
    
    // Test Algorithms
    
    func linearChange(_ input: CGFloat) -> CGFloat {
        return input + 5
    }
    
    func followingRandom(_ input: CGFloat) -> CGFloat {
        let random = drand48()
        switch random {
        case 0 ..< 0.125:
            return input - CGFloat(arc4random_uniform(20))
        case 0.125 ..< 0.25:
            return input - CGFloat(arc4random_uniform(15))
        case 0.25 ..< 0.375:
            return input - CGFloat(arc4random_uniform(10))
        case 0.375 ..< 0.5:
            return input - CGFloat(arc4random_uniform(5))
        case 0.5 ..< 0.625:
            return input + CGFloat(arc4random_uniform(5))
        case 0.625 ..< 0.75:
            return input + CGFloat(arc4random_uniform(10))
        case 0.75 ..< 0.875:
            return input + CGFloat(arc4random_uniform(15))
        case 0.875 ..< 1:
            return input + CGFloat(arc4random_uniform(20))
        default:
            return input
        }
    }
    
    func peeked(_ input: CGFloat) -> CGFloat {
        if !PeekAlgo.reachedPeek {
            if input >= PeekAlgo.peek - 5 {
                PeekAlgo.reachedPeek = true
            }
            return input + 5
        } else {
            if input <= 6 {
                PeekAlgo.reachedPeek = false
            }
            return input - 5
        }
    }
    
}

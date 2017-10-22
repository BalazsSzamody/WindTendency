//
//  ViewController.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 10. 14..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var circleChart: CircleChart!
    var windData: [WindData] = [] {
        didSet{
            if windData.isEmpty {
                CircleChart.max = 3600
                circleChart.circleSizeMultiplier = 0
                lineChart.xMax = 3600
                lineChart.yMax = 100
                lineChart.circleSizeMultiplier = 0
                let startWind = WindData(rawDirection: 0, speed: 0, date: Date())
                chartWind([startWind])
            } else {
                circleChart.circleSizeMultiplier = 5
                lineChart.circleSizeMultiplier = 5
                chartWind(windData)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        windData = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func newButtonPressed(_ sender: UIButton) {
        
        windData.append(windDataSimulation(directionAlgo: followingRandom(_:), speedAlgo: followingRandom(_:)))
        
    }
    
    func chartWind(_ windData: [WindData]) {
        lineChart.plot(windData)
        circleChart.plot(windData)
    }
    
    func windDataSimulation(directionAlgo: (CGFloat) -> CGFloat, speedAlgo: (CGFloat) -> CGFloat) -> WindData {
        var direction: CGFloat
        var speed: CGFloat
        var date: Date
        if !windData.isEmpty{
            direction = windData[windData.count - 1].direction
            speed = windData[windData.count - 1].speed
            date = windData[windData.count - 1].date.addingTimeInterval(120)
        } else {
            date = Date()
            direction = CGFloat(drand48()) * 360
            speed = CGFloat(drand48()) * 30
        }
        speed = speedAlgorithm(speedAlgo, input: speed)
        direction = directionAlgo(direction)
        
        return WindData(rawDirection: direction, speed: speed, date: date)
    }
    
    func windDataSimulation(dataCount: Int, directionAlgo: (CGFloat) -> CGFloat, startAngle: CGFloat, speedAlgo: (CGFloat) -> CGFloat, startSpeed: CGFloat) -> [WindData] {
        var data: [WindData] = []
        var angle: CGFloat = startAngle
        var speed: CGFloat = startSpeed
        for i in 0 ... dataCount {
            if i != 0 {
                let newDate = data[0].date.addingTimeInterval(TimeInterval(i) * 120)
                data.append(WindData(rawDirection: angle, speed: speed, date: newDate))
            } else {
                data.append(WindData(rawDirection: angle, speed: speed, date: Date()))
            }
            
            speed = speedAlgorithm(speedAlgo, input: speed)
            angle = directionAlgo(angle)
        }
        return data
    }
    
    func speedAlgorithm(_ speedAlgo: (CGFloat) -> CGFloat, input: CGFloat) -> CGFloat {
        var speed: CGFloat = speedAlgo(input)
        while speed < 0 {
            speed = speedAlgo(input)
        }
        
        return speed
    }
    
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
    
    func resetGraphs() {
        windData = []
    }
}


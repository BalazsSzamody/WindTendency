//
//  WindDataViewModel.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 25..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import Foundation
import UIKit

struct ViewViewModel {
    
    var location: Location?
    
    var windData: WindData = WindData() {
        didSet{
            guard speedChart != nil, directionChart != nil else {
                return
            }
            handleCharts()
            chartWind(windData.data)
        }
    }
    
    weak var speedChart: LineChart!
    
    weak var directionChart: CircleChart!
    
    
    var spotName: String {
        return location?.name ?? ""
    }
    
    mutating func addMeasurement(_ data: MeasurementData) {
        windData.addMeasurement(data)
    }
    
    mutating func chartSetup(speedChart: LineChart, directionChart: CircleChart) {
        self.speedChart = speedChart
        self.directionChart = directionChart
        handleCharts()
    }
    
    mutating func resetData() {
        location = nil
        windData = WindData()
    }
    
    private func handleCharts() {
        let data = windData.data
        if data.isEmpty {
            CircleChart.max = 3600
            directionChart.circleSizeMultiplier = 0
            speedChart.xMax = 3600
            speedChart.yMax = 100
            speedChart.circleSizeMultiplier = 0
            let startWind = MeasurementData(direction: 0, speed: 0, date: Date())
            chartWind([startWind])
        } else {
            directionChart.circleSizeMultiplier = 5
            speedChart.circleSizeMultiplier = 5
        }
    }
    
    private func chartWind(_ data: [MeasurementData]) {
        directionChart.plot(data)
        speedChart.plot(data)
    }
    
    func getCellViewModel(for indexPath: Int) -> WindDataCellViewModel {
        let data = windData.data[indexPath]
        
        return WindDataCellViewModel(measurementData: data)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        guard let jsonData = try? jsonEncoder.encode(windData) else {
            print("Unencodable data")
            return
        }
        UserDefaults.standard.set(jsonData, forKey: UserDefaultKeys.windDataKey)
     }
    
    mutating func load() {
        guard let jsonData = UserDefaults.standard.value(forKey: UserDefaultKeys.windDataKey) as? Data else {
            print("No data")
            return
        }
        let jsonDecoder = JSONDecoder()
        
        guard let loadedData = try? jsonDecoder.decode(WindData.self, from: jsonData) else {
            print("Undecodable data")
            return
        }
        windData = loadedData
    }
}

extension ViewViewModel {
    mutating func getRandomChart(_ elements: Int) {
        windData = TestDataFactory(type: .random, dataCount: elements, startAngle: 45, startSpeed: 15).testData
    }
    
    mutating func getSpiralChart(_ elements: Int) {
        windData = TestDataFactory(type: .spiral, dataCount: elements, startAngle: 0, startSpeed: 10).testData
    }
}

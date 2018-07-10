//
//  DataHandler.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 22..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    
    func loadLocations() -> [Location]? {
        guard let locationsData =  loadData(for: UserDefaultKeys.locationsKey) else {
            print("No locations Data")
            return nil
        }
        
        return try? jsonDecoder.decode([Location].self, from: locationsData)
        
    }
    
    func add(location: Location) {
        guard var locations = loadLocations() else {
            save(locations: [location])
            return
        }
        
        locations.append(location)
        
        save(locations: locations)
     }
    
    private func save(locations: [Location]) {
        guard let jsonData = try? jsonEncoder.encode(locations) else {
            print("LocationData not Encodable")
            return
        }
        
        save(data: jsonData, for: UserDefaultKeys.locationsKey)
    }
    
    func loadMeasurementData(for location: Location) -> [[MeasurementData]]? {
        guard let jsonData = loadData(for: location.name) else {
            print("No measurementData for \(location.name)")
            return nil
        }
        
        return try? jsonDecoder.decode([[MeasurementData]].self, from: jsonData)
    }
    
    func add(measurementData: [MeasurementData], for location: Location) {
        guard var measurementDataList = loadMeasurementData(for: location) else {
            save(measurementDataList: [measurementData], for: location)
            return
        }
        
        measurementDataList.append(measurementData)
        
        save(measurementDataList: measurementDataList, for: location)
    }
    
    private func save(measurementDataList: [[MeasurementData]], for location: Location) {
        guard let jsonData = try? jsonEncoder.encode(measurementDataList) else {
            print("MeasurementDataList not Encodable")
            return
        }
        
        save(data: jsonData, for: location.name)
    }
    
    private func loadData(for key: String) -> Data? {
        return UserDefaults.standard.value(forKey: key) as? Data
    }
    
    private func save(data: Data, for key: String) {
        UserDefaults.standard.set(data, forKey: key)
    }
}

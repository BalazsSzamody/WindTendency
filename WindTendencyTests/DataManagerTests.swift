//
//  DataManagerTests.swift
//  WindTendencyTests
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 29..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import XCTest
@testable import WindTendency

class DataManagerTests: XCTestCase {
    
    let dataManager = DataManager.shared
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.locationsKey)
        super.tearDown()
    }
    
    func testAddLocation() {
        let location = Location("Sydney", coordinates: (10, 10))
        
        dataManager.add(location: location)
        
        let data = UserDefaults.standard.value(forKey: UserDefaultKeys.locationsKey) as! Data
        let jsonDecoder = JSONDecoder()
        let locations = try! jsonDecoder.decode([Location].self, from: data)
        let result = locations.first!
        
        
        XCTAssertEqual(result, location)
    }
    
    func addLocations() {
        _ = StubLocations.locations.map { dataManager.add(location: $0)}
    }
    
    func testLoadLocations() {
        addLocations()
        let locations = dataManager.loadLocations()
        
        XCTAssertNotNil(locations)
        XCTAssertEqual(locations?.count, 5)
        
        let firstLocation = locations?.first!
        
        let name = "Sydney"
        let coordinates: (Double, Double) = (0,0)
        let expected = Location(name, coordinates: coordinates)
        XCTAssertEqual(firstLocation, expected)
    }
    
    func addMeasurementData() {
        addLocations()
        
        
        let measurementData = StubWindData.stubData.data
        //dataManager.add(measurementData: measurementData, for: "Sydney")
    }
    
    func testAddMeasurementData() {
        
        
    }
    
    
}

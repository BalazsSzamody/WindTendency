//
//  WindDataCellViewModelTests.swift
//  WindTendencyTests
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 27..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import XCTest
@testable import WindTendency

class WindDataCellViewModelTests: XCTestCase {
    
    let measurementData = MeasurementData(direction: 45, speed: 10, date: Date(timeIntervalSinceReferenceDate: 0))
    
    var viewModel: WindDataCellViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = WindDataCellViewModel(measurementData: measurementData)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDateLabel() {
        let expected = "2001. január 1. 11:00"
        
        XCTAssertEqual(viewModel.dateLabel, expected)
    }
    
    func testDirectionLabel() {
        let expected = "045"
        let result = viewModel.directionLabel
        
        XCTAssertEqual(result, expected)
    }
    
    func testSpeedLabel() {
        let expected = "10.0"
        let result = viewModel.speedLabel
        
        XCTAssertEqual(result, expected)
    }
    
}

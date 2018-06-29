//
//  ViewViewModelTests.swift
//  WindTendencyTests
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 27..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import XCTest
@testable import WindTendency

class ViewViewModelTests: XCTestCase {
    
    var windData = StubWindData.stubData
    
    var viewModel = ViewViewModel()
    
    let lineChart = LineChart(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)))
    let circleChart = CircleChart(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)))
    
    override func setUp() {
        super.setUp()
        
        viewModel.chartSetup(speedChart: lineChart, directionChart: circleChart)
        viewModel.windData = windData
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSpotName() {
        let expected = "Test Location"
        XCTAssertEqual(viewModel.spotName, expected)
    }
    
    func testResetData() {
        let expectedCount = 0
        let expectedName = ""
        viewModel.resetData()
        
        XCTAssertEqual(viewModel.windData.data.count, expectedCount)
        XCTAssertEqual(viewModel.windData.spotName, expectedName)
    }
    
    func testSpeedChartNotNil() {
        XCTAssertNotNil(viewModel.speedChart)
    }
    
    func testDirectionChartNotNil() {
        XCTAssertNotNil(viewModel.directionChart)
    }
    
    func testSpeedChart_DotCount() {
        let expectedCount: Int? = 10
        let result = viewModel.speedChart.data?.count
        
        XCTAssertEqual(result, expectedCount)
    }
    
    func testDirectionChart_DorCount() {
        let expectedCount: Int? = 10
        let result = viewModel.directionChart.data?.count
        
        XCTAssertEqual(result, expectedCount)
    }
    
    func testAddMeasurement() {
        let newMeasurement = MeasurementData(direction: 100, speed: 12, date: Date(timeIntervalSinceReferenceDate: TimeInterval(10) * 120))
        viewModel.addMeasurement(newMeasurement)
        let expectedCount = 11
        let expectedSpeed: CGFloat = 12
        let expectedDirection: CGFloat = 100
        let expectedDate = Date(timeIntervalSinceReferenceDate: 1200)
        XCTAssertEqual(viewModel.windData.data.count, expectedCount)
        XCTAssertEqual(viewModel.speedChart.data!.count, expectedCount)
        
        let lastData = viewModel.windData.data.last!
        XCTAssertEqual(lastData.speed, expectedSpeed)
        XCTAssertEqual(lastData.direction, expectedDirection)
        XCTAssertEqual(lastData.date, expectedDate)
    }
    
    func testGetCellViewModel() {
        let cellViewModel: WindDataCellViewModel = viewModel.getCellViewModel(for: 0)
        let expected: MeasurementData = MeasurementData(direction: 45, speed: 10, date: Date(timeIntervalSinceReferenceDate: 0))
        
        XCTAssertEqual(cellViewModel.measurementData, expected)
    }
    
}

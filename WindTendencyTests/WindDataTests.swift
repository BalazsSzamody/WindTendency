//
//  WindDataTests.swift
//  WindTendencyTests
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 26..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import XCTest
@testable import WindTendency

class WindDataTests: XCTestCase {
    
    var windData: WindData = StubWindData.stubData
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFirstData() {
        let expectedWindDirection = CGFloat(45.0)
        let expectedWindSpeed = CGFloat(10.0)
        let expectedDate = Date(timeIntervalSinceReferenceDate: 0)
        XCTAssertEqual(windData.data[0].direction, expectedWindDirection)
        XCTAssertEqual(windData.data[0].speed, expectedWindSpeed)
        XCTAssertEqual(windData.data[0].date, expectedDate)
    }
    
    
}

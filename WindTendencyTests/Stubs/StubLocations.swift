//
//  StubLocations.swift
//  WindTendencyTests
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 29..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import Foundation
@testable import WindTendency

struct StubLocations {
    private static let names: [String] = ["Sydney", "Manly", "Budapest", "Kuta", "Maui"]
    static let locations = names.enumerated().map { (arg) -> Location in
        let (i, name) = arg
        return Location(name, coordinates: (Double(i) * 1, Double(i) * 3))
    }
    
}

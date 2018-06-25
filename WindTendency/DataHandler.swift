//
//  DataHandler.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 22..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import Foundation

class DataHandler {
    static let shared = DataHandler()
    
    let encoder = JSONEncoder()
    
    func save(_ data: WindData) {
        
    }
    
    func load(_ forKey: String) -> [MeasurementData] {
        return []
    }
}

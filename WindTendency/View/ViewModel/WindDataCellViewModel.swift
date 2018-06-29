//
//  WindDataCellViewModel.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 25..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import Foundation
import UIKit

struct WindDataCellViewModel {
    
    private let dateFormatter = DateFormatter()
    
    var measurementData: MeasurementData
    
    var directionLabel: String {
        return String(format: "%03.0f", measurementData.direction)
    }
    
    var speedLabel: String {
        return String(format: "%.1f", measurementData.speed)
    }
    
    var dateLabel: String {
        return formatDate(format: .letters)
    }
    
    func formatDate(format: DateFormats) -> String {
        dateFormatter.locale = Locale(identifier: "hu_HU")
        dateFormatter.setLocalizedDateFormatFromTemplate(format.rawValue)
        
        return dateFormatter.string(from: measurementData.date)
    }
}

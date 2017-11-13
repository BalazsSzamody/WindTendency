//
//  WindMeasurement.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 10. 14..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import Foundation
import UIKit

struct WindData {
    let direction: CGFloat
    let speed: CGFloat
    let date: Date
    
    init(rawDirection: CGFloat, speed: CGFloat, date: Date) {
        direction = WindData.setDirection(rawDirection)
        self.speed = speed
        self.date = date
    }
    
    static func setDirection(_ rawDirection: CGFloat) -> CGFloat {
        if rawDirection > 360 {
            return rawDirection.truncatingRemainder(dividingBy: 360)
        } else if rawDirection < 0 {
            return setDirection(360 - rawDirection)
        } else if rawDirection == 360 {
            return 0
        } else {
            return rawDirection
        }
    }
    static func convertDirection(_ windData: [WindData]) -> [CircleChartPoint]? {
        guard !windData.isEmpty else { return nil }
        var points: [CircleChartPoint] = []
        
        for entry in windData {
            points.append(CircleChartPoint(direction: entry.direction, date: entry.date))
        }
        return points
    }
    
    static func convertSpeed(_ windData: [WindData]) -> [CGPoint]? {
        guard !windData.isEmpty else { return nil }
        var points: [CGPoint] = []
        let startDate = windData[0].date
        
        for entry in windData {
            let x = CGFloat(entry.date.timeIntervalSince(startDate))
            let y = entry.speed
            
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }
    
    func formatDate(format: DateFormats) -> String {
        let dateFormatter =  DateFormatter()
        dateFormatter.locale = Locale(identifier: "hu_HU")
        dateFormatter.setLocalizedDateFormatFromTemplate(format.rawValue)
        
        return dateFormatter.string(from: date)
    }
    
    static func formatDate(at date: Date, format: DateFormats) -> String {
        let dateFormatter =  DateFormatter()
        dateFormatter.locale = Locale(identifier: "hu_HU")
        dateFormatter.setLocalizedDateFormatFromTemplate(format.rawValue)
        
        return dateFormatter.string(from: date)
    }
}

extension WindData {
    //JSON conversion
    static func convertToWindDataDict(_ windData: WindData) -> [String:Any] {
        var windDict: [String:Any] = [:]
        windDict["direction"] = windData.direction as Any
        windDict["speed"] = windData.speed as Any
        windDict["date"] = windData.formatDate(format: .numbersOnly) as Any
        return windDict
    }
    
    static func convertToJSONObject(_ allWindData: [WindData]) -> [Any] {
        var json: [Any] = []
        for winData in allWindData {
            json.append(convertToWindDataDict(winData) as Any)
        }
        
        return json
    }
    
    static func jsonStringify(_ data: AnyObject, prettyPrinted: Bool = false) -> String {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        
        if JSONSerialization.isValidJSONObject(data){
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: options)
                
                if let string = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            } catch {
                print("error")
            }
        }
        return ""
    }
}
//Export - Import
extension WindData {
    static func importData(from url: URL) {
        
    }
    
    static func exportToFileURL(_ data: String) -> URL? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let date = formatDate(at: Date(), format: .fileName)
        let saveFileURL = path.appendingPathComponent("\(date).json")
        do{
            try (data as NSString).write(to: saveFileURL, atomically: true, encoding: 1)
        }catch{
            print(error)
            print("write failed")
        }
        return saveFileURL
    }
}


//
//  WindMeasurement.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 10. 14..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import Foundation
import UIKit

struct AllData: Codable {
    let spotName: String
    let windData: [MeasurementData]
}

struct MeasurementData: Codable {
    let direction: CGFloat
    let speed: CGFloat
    let date: Date
    
    static var jsonFromURL: [String : AnyObject]? = [:]
    
    init(rawDirection: CGFloat, speed: CGFloat, date: Date) {
        direction = MeasurementData.setDirection(rawDirection)
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
    static func convertDirection(_ windData: [MeasurementData]) -> [CircleChartPoint]? {
        guard !windData.isEmpty else { return nil }
        var points: [CircleChartPoint] = []
        
        for entry in windData {
            points.append(CircleChartPoint(direction: entry.direction, date: entry.date))
        }
        return points
    }
    
    static func convertSpeed(_ windData: [MeasurementData]) -> [CGPoint]? {
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
    
    static func formatDate(_ string: String) -> Date? {
        let dateFormatter =  DateFormatter()
        dateFormatter.locale = Locale(identifier: "hu_HU")
        //dateFormatter.setLocalizedDateFormatFromTemplate(format.rawValue)
        
        guard let date = dateFormatter.date(from: string) else { return nil }
        return date
    }
}

extension MeasurementData {
    //JSON conversion
    static func convertToWindDataDict(_ windData: MeasurementData) -> [String:Any] {
        var windDict: [String:Any] = [:]
        windDict["direction"] = windData.direction as Any
        windDict["speed"] = windData.speed as Any
        windDict["date"] = windData.formatDate(format: .numbersOnly) as Any
        return windDict
    }
    
    static func convertToJSONObject(_ allWindData: [MeasurementData]) -> [String : Any] {
        var json: [Any] = []
        for winData in allWindData {
            json.append(convertToWindDataDict(winData) as Any)
        }
        
        return ["windData" : json] as [String : Any]
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
extension MeasurementData {
    static func importWindData(from url: URL) -> [MeasurementData]?{
        guard let nsDictionary = NSDictionary(contentsOf: url) else {
            print("ns dictionary creation failed")
            return nil }
        print(nsDictionary.allKeys)
        guard let dictionary = nsDictionary as? [String:AnyObject] else { return nil }
        print(dictionary)
        guard let json = dictionary["windData"] as? [AnyObject] else { return nil }
        print(json)
        var allWindData: [MeasurementData] = []
        for object in json {
            guard let dateString = object["date"] as? String,
                let date = formatDate(dateString),
                let speed = object["speed"] as? CGFloat,
                let direction = object["direction"] as? CGFloat else { return nil }
            
            allWindData.append(MeasurementData(rawDirection: direction, speed: speed, date: date))
        }
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Failed to delete file at: \(url)")
        }
        
        return allWindData
    }
    
    static func importWithURLSession(from url: URL, completion: (_ url: URL) -> [MeasurementData]?) -> [MeasurementData]? {
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        var resultData: [String:AnyObject]? = nil
        
        let task = defaultSession.dataTask(with: url) {(data, response, error) in
            if let error = error {
                print(error)
                return
            } else {
                guard let data = data else {
                    print("No data")
                    return
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers ) as? [String:AnyObject] else {
                    print("data not json")
                    return
                }
                MeasurementData.jsonFromURL = json
            }
        }
        
        task.resume()
        
        return completion(url)
    }
    
    static func handleImportedJSON(_ url: URL) -> [MeasurementData]? {
        guard let json = jsonFromURL?["windData"]  as? [AnyObject] else {
            
            print("no resultData")
            print(jsonFromURL ?? "nil")
            return nil
        }
        var allWindData: [MeasurementData] = []
        for object in json {
            guard let dateString = object["date"] as? String,
                let date = formatDate(dateString),
                let speed = object["speed"] as? CGFloat,
                let direction = object["direction"] as? CGFloat else { return nil }
            
            allWindData.append(MeasurementData(rawDirection: direction, speed: speed, date: date))
        }
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Failed to delete file at: \(url)")
        }
        
        return allWindData
    }
    
    static func exportJSON(_ allWindData: [MeasurementData]) -> URL? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        
        var _: NSErrorPointer
        let fileName = formatDate(at: Date(), format: .fileName) + ".json"
        let jsonObject = convertToJSONObject(allWindData)
        let jsonString = jsonStringify(jsonObject as AnyObject)
        let saveFileURL = path.appendingPathComponent(fileName)
        
        do{
            try (jsonString as NSString).write(to: saveFileURL, atomically: true, encoding: 1)
        }catch{
            print(error)
            print("write failed")
        }
        return saveFileURL
    }
}


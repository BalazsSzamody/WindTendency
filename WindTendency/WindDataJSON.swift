//
//  JSONConverter.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 11. 11..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import Foundation

struct WindDataJSON{
    
    let currentJSON: String!
    
    init(_ allWindData: [WindData]) {
       let jsonObjects = WindDataJSON.convertToJSONObject(allWindData) as AnyObject
        currentJSON = WindDataJSON.jsonStringify(jsonObjects, prettyPrinted: true)
    }
    
   private static func convertToWindDataDict(_ windData: WindData) -> [String:Any] {
        var windDict: [String:Any] = [:]
        windDict["direction"] = windData.direction as Any
        windDict["speed"] = windData.speed as Any
        windDict["date"] = "\(windData.date)" as Any
        return windDict
    }
    
   private static func convertToJSONObject(_ allWindData: [WindData]) -> [Any] {
        var json: [Any] = []
        for winData in allWindData {
            json.append(convertToWindDataDict(winData) as Any)
        }
        
        return json
    }
    
    private static func jsonStringify(_ data: AnyObject, prettyPrinted: Bool = false) -> String {
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

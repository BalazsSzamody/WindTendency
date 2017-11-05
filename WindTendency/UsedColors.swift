//
//  UsedColors.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 11. 05..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import Foundation
import UIKit

struct UsedColors {
    static var lightOrange: UIColor = UIColor(red: 238/255, green: 164/255, blue: 119/255, alpha: 0.7)
    static var darkOrange: UIColor = UIColor(red: 222/255, green: 85/255, blue: 0/255, alpha: 1)
    
    static var graphBackgroundColor: UIColor {
        return lightOrange
    }
    static var speedMaxColor: UIColor {
        return UIColor.red
    }
    static var speedMidColor: UIColor {
        return UIColor.yellow
    }
    static var speedMinColor: UIColor {
        return UIColor.green
    }
}

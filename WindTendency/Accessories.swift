//
//  Accessories.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 10. 15..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    init(angle rawAngle: CGFloat, length: CGFloat) {
        let angleDegree = rawAngle.truncatingRemainder(dividingBy: 90)
        let angle = angleDegree * ( CGFloat.pi / 180)
        let y = cos(angle) * length
        let x = tan(angle) * y
        
        switch rawAngle {
        case 0 ..< 90:
            self.init(x: x, y: y)
        case 90 ..< 180:
            self.init(x: y, y: -x)
        case 180 ..< 270:
            self.init(x: -x, y: -y)
        default:
            self.init(x: -y, y: x)
        }
    }
    
    
    func add(_ point: CGPoint) -> CGPoint {
        let x = self.x + point.x
        let y = self.y + point.y
        return CGPoint(x: x, y: y)
    }
    
    func add(_ float: CGFloat) -> CGPoint {
        return self.add(CGPoint(x: float, y: float))
    }
    
    func add(x float: CGFloat) -> CGPoint {
        return self.add(CGPoint(x: float, y: 0))
    }
    
    func add(y float: CGFloat) -> CGPoint {
        return self.add(CGPoint(x: 0, y: float))
    }
    
    func subtract(_ point: CGPoint) -> CGPoint {
        let x = self.x - point.x
        let y = self.y - point.y
        return CGPoint(x: x, y: y)
    }
    
    func subtract(_ float: CGFloat) -> CGPoint {
        return self.subtract(CGPoint(x: float, y: float))
    }
}

extension CGRect {
    func scale(adding float: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x - ( float / 2), y: self.origin.y - ( float / 2), width: self.width + float, height: self.height + float)
    }
    
    func scale(by float: CGFloat) -> CGRect {
        let size: CGSize = CGSize(width: self.width * float, height: self.height * float)
        let origin = CGPoint(x: self.origin.x - (( size.width - self.width ) / 2), y: self.origin.y - (( size.height - self.height ) / 2))
        
        return CGRect(origin: origin, size: size)
    }
}

extension UIView {
    func absoluteOrigin() -> CGPoint {
        var origin = self.frame.origin
        
        guard let superview = self.superview else { return origin }
        
        origin = origin.add(superview.absoluteOrigin())
        
        return origin
    }
    
    func origin(in parentView: UIView) -> CGPoint {
        return self.absoluteOrigin().subtract(parentView.absoluteOrigin())
    }
    
}

extension String {
    func size(withSystemFontSize pointSize: CGFloat) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: pointSize)])
    }
}

struct PeekAlgo {
    static let peek: CGFloat = 30
    static var reachedPeek = false
}


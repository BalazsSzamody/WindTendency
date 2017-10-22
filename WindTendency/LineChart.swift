//
//  LineChart.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 10. 21..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import Foundation
import UIKit

class LineChart: UIView {
    
    let lineLayer = CAShapeLayer()
    let circleLayer = CAShapeLayer()
    
    var chartTransfrom: CGAffineTransform?
    
    @IBInspectable var lineWidth: CGFloat = 1
    
    @IBInspectable var showPoints: Bool = true {
        didSet {
            circleLayer.isHidden = !showPoints
        }
    }
    
    @IBInspectable var lineColor: UIColor = .red  {
        didSet{
            lineLayer.strokeColor = lineColor.cgColor
        }
    }
    
    @IBInspectable var circleColor: UIColor = UIColor.red {
        didSet{
            circleLayer.fillColor = circleColor.cgColor
        }
    }
    
    @IBInspectable var circleSizeMultiplier: CGFloat = 3
    
    @IBInspectable var axisColor: UIColor = .black
    @IBInspectable var showInnerLines: Bool = true
    @IBInspectable var labelFontSize: CGFloat = 10
    
    var axisLineWidth: CGFloat = 1
    var deltaX: CGFloat = 300
    var deltaY: CGFloat = 2
    var xMax: CGFloat = 3600
    var xMin: CGFloat = 0
    var yMax: CGFloat = 100
    var yMin: CGFloat = 0
    var data: [WindData]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        combinedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        combinedInit()
    }
    
    func combinedInit() {
        layer.addSublayer(lineLayer)
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = lineColor.cgColor
        
        layer.addSublayer(circleLayer)
        circleLayer.fillColor = circleColor.cgColor
        
        layer.borderWidth = 1
        layer.borderColor = axisColor.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineLayer.frame = bounds
        circleLayer.frame = bounds
        
        if let data = data {
            setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
            plot(data)
        }
    }
    
    func setAxisRange(forPoints points: [CGPoint]) {
        guard !points.isEmpty else { return }
        
        let xs = points.map() { $0.x }
        let minX = xs.min()!
        let maxX = xs.max()!
        let ys = points.map() { $0.y }
        
        switch maxX - minX {
        case 0 ..< (3600):
            deltaX = 300
        case 3600 ..< 3600*3:
            deltaX = 600
        default:
            deltaX = 1800
        }
        
        
        
        if maxX > CGFloat(3600) {
            xMax = ceil(maxX / deltaX) * deltaX
        }
        let maxY = ys.max()!
        
        switch maxY {
        case 0 ..< 20:
            deltaY = 2
        case 20 ..< 50:
            deltaY = 5
        default:
            deltaY = 10
        }
        
        if maxY > 10 {
            yMax = ceil(maxY / deltaY) * deltaY
        } else {
            yMax = 10
        }
        
        
        yMin = 0
        setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
    }
    
    func setAxisRange(xMin: CGFloat, xMax: CGFloat, yMin: CGFloat, yMax: CGFloat) {
        self.xMin = xMin
        self.xMax = xMax
        self.yMin = yMin
        self.yMax = yMax
        setTransform(minX: xMin, maxX: xMax, minY: yMin, maxY: yMax)
    }
    
    func setTransform(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        let xLabelSize = "\(Int(maxX))".size(withSystemFontSize: labelFontSize)
        let yLabelSize = "\(Int(maxY))".size(withSystemFontSize: labelFontSize)
        
        let xOffset = xLabelSize.height + 2
        let yOffset = yLabelSize.width + 5
        
        let xScale = ( bounds.width - yOffset - xLabelSize.width/2 - 2) / ( maxX - minX )
        let yScale = ( bounds.height - xOffset - yLabelSize.height/2 - 2) / ( maxY - minY )
        
        chartTransfrom = CGAffineTransform(a: xScale, b: 0, c: 0, d: -yScale, tx: yOffset, ty: bounds.height - xOffset)
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), let transform = chartTransfrom else { return }
        drawAxes(in: context, usingTransform: transform)
    }
    
    func drawAxes(in context: CGContext, usingTransform transform: CGAffineTransform) {
        context.saveGState()
        
        let thickerLines = CGMutablePath()
        let thinnerLines = CGMutablePath()
        
        let xAxisPoints = [CGPoint(x: xMin, y: 0), CGPoint(x: xMax, y: 0)]
        let yAxisPoints = [CGPoint(x: 0, y: yMin), CGPoint(x: 0, y: yMax)]
        
        thickerLines.addLines(between: xAxisPoints, transform: transform)
        thickerLines.addLines(between: yAxisPoints, transform: transform)
        
        for x in stride(from: xMin, to: xMax, by: deltaX) {
            
            let tickPoints = showInnerLines ? [CGPoint(x: x, y: yMin).applying(transform), CGPoint(x: x, y: yMax).applying(transform)] : [CGPoint(x: x, y: 0).applying(transform), CGPoint(x: x, y: 0).applying(transform).add(y: -5)]
            
            thinnerLines.addLines(between: tickPoints)
            
            if x != xMin {
                let label = "\(Int(x / 60))" as NSString
                let labelSize = "\(Int(x / 60))".size(withSystemFontSize: labelFontSize)
                let labelDrawPoint = CGPoint(x: x, y: 0).applying(transform).add(x: -labelSize.width/2).add(y: 1)
                
                label.draw(at: labelDrawPoint, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize), NSAttributedStringKey.foregroundColor: axisColor])
            }
        }
        
        for y in stride(from: yMin, to: yMax, by: deltaY) {
            
            let tickPoints = showInnerLines ? [CGPoint(x: xMin, y: y).applying(transform), CGPoint(x: xMax, y: y).applying(transform)] : [CGPoint(x: 0, y: y).applying(transform), CGPoint(x: 0, y: y).applying(transform).add(x: 5)]
            
            thinnerLines.addLines(between: tickPoints)
            
            if y != yMin {
                let label = "\(Int(y))" as NSString
                let labelSize = "\(Int(y))".size(withSystemFontSize: labelFontSize)
                let labelDrawPoint = CGPoint(x: 0, y: y).applying(transform).add(x: -labelSize.width - 1).add(y: -labelSize.height/2)
                
                label.draw(at: labelDrawPoint, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize), NSAttributedStringKey.foregroundColor: axisColor])
            }
        }
        
        context.setStrokeColor(axisColor.cgColor)
        context.setLineWidth(axisLineWidth)
        context.addPath(thickerLines)
        context.strokePath()
        
        context.setStrokeColor(axisColor.withAlphaComponent(0.5).cgColor)
        context.setLineWidth(axisLineWidth/2)
        context.addPath(thinnerLines)
        context.strokePath()
        
        context.restoreGState()
    }
    
    func plot(_ input: [WindData]) {
        lineLayer.path = nil
        circleLayer.path = nil
        
        data = nil
        
        guard !input.isEmpty else { return }
        
        self.data = input
        
        guard let points = convertToPoint(input) else { return }
        
        setAxisRange(forPoints: points)
        
        guard let chartTransform = chartTransfrom else { return }
        
        if points.count > 1 {
            let linePath = CGMutablePath()
            linePath.addLines(between: points, transform: chartTransform)
            
            lineLayer.path = linePath
        }
        
        
        if showPoints {
            circleLayer.path = circles(atPoints: points, withTransform: chartTransform)
        }
        
    }
    
    func circles(atPoints points: [CGPoint], withTransform transform: CGAffineTransform) -> CGPath {
        let path = CGMutablePath()
        let radius = lineLayer.lineWidth * circleSizeMultiplier/2
        
        for i in points {
            let p = i.applying(transform)
            let rect = CGRect(x: p.x - radius, y: p.y - radius, width: radius * 2, height: radius * 2)
            path.addEllipse(in: rect)
        }
        
        return path
    }
    
    func convertToPoint(_ input: [WindData]?) -> [CGPoint]? {
        guard let input = input else { return nil }
        guard !input.isEmpty else { return nil }
        var points: [CGPoint] = []
        let startDate = input[0].date
        
        for entry in input {
            let x = CGFloat(entry.date.timeIntervalSince(startDate))
            let y = entry.speed
            
            points.append(CGPoint(x: x, y:y))
        }
        return points
    }
}

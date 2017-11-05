//
//  CircleChart.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 10. 21..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import Foundation
import UIKit

class CircleChart: UIView {
    
    static var delta: CGFloat = 300
    static var max: CGFloat = 3600
    
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
    
    
    var deltaX: CGFloat { return CircleChart.delta }
    var deltaY: CGFloat { return CircleChart.delta }
    
    var xMax: CGFloat {
        return CircleChart.max
    }
    var xMin: CGFloat {
        return -CircleChart.max
    }
    var yMax: CGFloat {
        return CircleChart.max
    }
    var yMin: CGFloat {
        return -CircleChart.max
    }
    
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
            setTransform()
            plot(data)
        }
    }
    
    func setAxisRange(forData data: [WindData]) {
        guard !data.isEmpty else { return }
        
        let dates = data.map() { $0.date }
        let maxDate = dates.max()!
        let minDate = dates.min()!
        if CGFloat(maxDate.timeIntervalSince(minDate)) > CircleChart.max {
            CircleChart.max = CGFloat(maxDate.timeIntervalSince(minDate))
        }
        
        switch CircleChart.max {
        case 0 ..< (3600):
            CircleChart.delta = 300
        case 3600 ..< 3600*3:
            CircleChart.delta = 600
        default:
            CircleChart.delta = 1800
        }
        
        CircleChart.max = ceil(CircleChart.max / CircleChart.delta) * CircleChart.delta
        setTransform()
    }
    
    func setAxisRange(max: CGFloat) {
        CircleChart.max = max
        setTransform()
    }
    
    func setTransform() {
        let xLabelSize = "\(Int(xMax / 60))".size(withSystemFontSize: labelFontSize)
        let yLabelSize = "\(Int(yMax / 60))".size(withSystemFontSize: labelFontSize)
        
        let xOffset = xLabelSize.height + 5
        let yOffset = yLabelSize.width + 5
        
        let xScale = ( bounds.width - (2 * yOffset) - xLabelSize.width/2 - 2) / ( xMax - xMin )
        let yScale = ( bounds.height - (2 * xOffset) - yLabelSize.height/2 - 2) / ( yMax - yMin )
        
        chartTransfrom = CGAffineTransform(a: xScale, b: 0, c: 0, d: -yScale, tx: bounds.width / 2, ty: bounds.height / 2)
        
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
        
        let thickCircleRect = CGRect(x: -CircleChart.max, y: -CircleChart.max, width: 2 * CircleChart.max, height: 2 * CircleChart.max).applying(transform)
        thickerLines.addEllipse(in: thickCircleRect)
        
        for x in stride(from: 0, to: CircleChart.max, by: CircleChart.delta) {
            let center = CGPoint(x: -x, y: -x)
            let size = CGSize(width: 2 * x, height: 2 * x)
            let rect = CGRect(origin: center, size: size).applying(transform)
            
            thinnerLines.addEllipse(in: rect)
        }
        
        let radialMax: CGFloat = 360
        let radialDiff: CGFloat = 15
        let centerPoint = CGPoint(x: 0, y: 0).applying(transform)
        
        for angle in stride(from: 0, to: radialMax, by: radialDiff) {
            
            let point = CGPoint(angle: angle, length: CircleChart.max)
            
            thinnerLines.addLines(between: [ point.applying(transform), centerPoint ])
            
            
            let label = "\(Int(angle))" as NSString
            let labelSize = "\(Int(angle))".size(withSystemFontSize: labelFontSize)
            let labelDrawPoint = CGPoint(x: point.x + ((labelSize.width / 2) * (point.x / CircleChart.max)) , y: point.y + (labelSize.height / 2) * (point.y / CircleChart.max)).applying(transform).add(x: -labelSize.width / 2).add(y: -labelSize.height / 2)
            
            label.draw(at: labelDrawPoint, withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: labelFontSize), NSAttributedStringKey.foregroundColor: axisColor])
            
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
    
    func plot(_ points: [WindData]) {
        lineLayer.path = nil
        circleLayer.path = nil
        
        data = nil
        
        guard !points.isEmpty else { return }
        
        self.data = points
        guard let cgPoints = convertToPoint(data) else { return }
        
        //setAxisRange(forPoints: cgPoints)
        guard let chartTransform = chartTransfrom else { return }
        
        let linePath = CGMutablePath()
        linePath.addLines(between: cgPoints, transform: chartTransform)
        
        lineLayer.path = linePath
        
        if showPoints {
            circleLayer.path = circles(atPoints: cgPoints, withTransform: chartTransform)
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
        setAxisRange(forData: input)
        
        let dates = input.map() { $0.date }
        let dateMax = dates.max()!
        let dateMin = dates.min()!
        let axisStartDate = dateMax.addingTimeInterval(-TimeInterval(CircleChart.max))
        for entry in input{
            let length = entry.date.timeIntervalSince(axisStartDate) / dateMax.timeIntervalSince(axisStartDate)
            
            points.append(CGPoint(angle: entry.direction, length: CircleChart.max * CGFloat(length)))
        }
        return points
    }
}

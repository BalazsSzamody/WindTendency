//
//  ViewController.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 10. 14..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var circleChart: CircleChart!
    @IBOutlet weak var newEntryView: UIView!
    @IBOutlet weak var directionPickerView: UIPickerView!
    @IBOutlet weak var speedPickerView: UIPickerView!
    @IBOutlet weak var dataTableButton: UIButton!
    @IBOutlet weak var windDataTableView: UITableView!
    
    var speedPickerData: [[String]] = []
    var directionPickerData: [[String]] = []
    var windData: [WindData] = [] {
        didSet{
            if windData.isEmpty {
                CircleChart.max = 3600
                circleChart.circleSizeMultiplier = 0
                lineChart.xMax = 3600
                lineChart.yMax = 100
                lineChart.circleSizeMultiplier = 0
                let startWind = WindData(rawDirection: 0, speed: 0, date: Date())
                chartWind([startWind])
                dataTableButton.isHidden = true
            } else {
                circleChart.circleSizeMultiplier = 5
                lineChart.circleSizeMultiplier = 5
                chartWind(windData)
                dataTableButton.isHidden = false
            }
        }
    }
    
    var entryDate: Date?
    var entryDirection: CGFloat?
    var entrySpeed: CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        circleChart.backgroundColor = UsedColors.graphBackgroundColor
        lineChart.backgroundColor = UsedColors.graphBackgroundColor
        newEntryView.isHidden = true
        pickerProtocolSetup()
        windData = []
        windDataTableView.delegate = self
        windDataTableView.dataSource = self
        windDataTableView.isHidden = true
        windDataTableView.layer.cornerRadius = 10
        windDataTableView.layer.borderColor = UsedColors.darkOrange.cgColor
        windDataTableView.layer.borderWidth = 2
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if !newEntryView.isHidden && touch?.view != newEntryView {
            newEntryIsVisible()
        } else if !windDataTableView.isHidden && touch?.view != windDataTableView {
            tableViewIsVisible()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func newButtonPressed(_ sender: UIButton) {
        newEntryView.isHidden = false
        
        entryDate = Date()
     }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        guard let date = entryDate, let direction = entryDirection, let speed = entrySpeed else {
            newEntryIsVisible()
            return
        }
        windData.append(WindData(rawDirection: direction, speed: speed, date: date))
        newEntryIsVisible()
    }
    @IBAction func resetButtonPressed(_ sender: Any) {
        windData = []
        newEntryIsVisible()
    }
    
    @IBAction func dataTableButtonPressed(_ sender: Any) {
        windDataTableView.reloadData()
        windDataTableView.isHidden = false
        dataTableButton.isHidden = true
    }
    
    
    func chartWind(_ windData: [WindData]) {
        lineChart.plot(windData)
        circleChart.plot(windData)
    }
    
    func windDataSimulation(directionAlgo: (CGFloat) -> CGFloat, speedAlgo: (CGFloat) -> CGFloat) -> WindData {
        var direction: CGFloat
        var speed: CGFloat
        var date: Date
        if !windData.isEmpty{
            direction = windData[windData.count - 1].direction
            speed = windData[windData.count - 1].speed
            date = windData[windData.count - 1].date.addingTimeInterval(120)
        } else {
            date = Date()
            direction = CGFloat(drand48()) * 360
            speed = CGFloat(drand48()) * 30
        }
        speed = speedAlgorithm(speedAlgo, input: speed)
        direction = directionAlgo(direction)
        
        return WindData(rawDirection: direction, speed: speed, date: date)
    }
    
    func windDataSimulation(dataCount: Int, directionAlgo: (CGFloat) -> CGFloat, startAngle: CGFloat, speedAlgo: (CGFloat) -> CGFloat, startSpeed: CGFloat) -> [WindData] {
        var data: [WindData] = []
        var angle: CGFloat = startAngle
        var speed: CGFloat = startSpeed
        for i in 0 ... dataCount {
            if i != 0 {
                let newDate = data[0].date.addingTimeInterval(TimeInterval(i) * 120)
                data.append(WindData(rawDirection: angle, speed: speed, date: newDate))
            } else {
                data.append(WindData(rawDirection: angle, speed: speed, date: Date()))
            }
            
            speed = speedAlgorithm(speedAlgo, input: speed)
            angle = directionAlgo(angle)
        }
        return data
    }
    
    func speedAlgorithm(_ speedAlgo: (CGFloat) -> CGFloat, input: CGFloat) -> CGFloat {
        var speed: CGFloat = speedAlgo(input)
        while speed < 0 {
            speed = speedAlgo(input)
        }
        
        return speed
    }
    
    func linearChange(_ input: CGFloat) -> CGFloat {
        return input + 5
    }
    
    func followingRandom(_ input: CGFloat) -> CGFloat {
        let random = drand48()
        switch random {
        case 0 ..< 0.125:
            return input - CGFloat(arc4random_uniform(20))
        case 0.125 ..< 0.25:
            return input - CGFloat(arc4random_uniform(15))
        case 0.25 ..< 0.375:
            return input - CGFloat(arc4random_uniform(10))
        case 0.375 ..< 0.5:
            return input - CGFloat(arc4random_uniform(5))
        case 0.5 ..< 0.625:
            return input + CGFloat(arc4random_uniform(5))
        case 0.625 ..< 0.75:
            return input + CGFloat(arc4random_uniform(10))
        case 0.75 ..< 0.875:
            return input + CGFloat(arc4random_uniform(15))
        case 0.875 ..< 1:
            return input + CGFloat(arc4random_uniform(20))
        default:
            return input
        }
    }
    
    func peeked(_ input: CGFloat) -> CGFloat {
        if !PeekAlgo.reachedPeek {
            if input >= PeekAlgo.peek - 5 {
                PeekAlgo.reachedPeek = true
            }
            return input + 5
        } else {
            if input <= 6 {
                PeekAlgo.reachedPeek = false
            }
            return input - 5
        }
    }
    
    func resetGraphs() {
        windData = []
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerProtocolSetup() {
        directionPickerData = fillPickerData(max: 360, decimal: false)
        speedPickerData = fillPickerData(max: 99, decimal: true)
        
        directionPickerView.delegate = self
        directionPickerView.dataSource = self
        
        speedPickerView.delegate = self
        speedPickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == speedPickerView {
            return speedPickerData.count
        } else {
            return directionPickerData.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == speedPickerView {
            return speedPickerData[component].count
        } else {
            return directionPickerData[component].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == speedPickerView {
            return speedPickerData[component][row]
        } else {
            return directionPickerData[component][row]
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.width / CGFloat(pickerView.numberOfComponents + 4)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateEntry()
    }
 
    func fillPickerData(max: CGFloat, decimal: Bool) -> [[String]] {
        let hundredsMax = Int(max / 100)
        var tensMax = (Int(max) - hundredsMax * 100) / 10
        var onesMax = Int(max) - hundredsMax * 100 - tensMax * 10
        
        var components: [[String]] = []
        var numbers: [Int] = []
        if hundredsMax != 0 {
            numbers.append(hundredsMax)
        }
        
        if hundredsMax != 0 || tensMax != 0 {
            if hundredsMax != 0 {
                tensMax = 9
            }
            numbers.append(tensMax)
        }
        
        if hundredsMax != 0 || tensMax != 0 || onesMax != 0 {
            if tensMax != 0 {
                onesMax = 9
            }
            numbers.append(onesMax)
        }
        
        if decimal {
            numbers.append(0)
            numbers.append(9)
            
        }
        
        for number in numbers {
            var rows: [String] = []
            if number == 0 {
                components.append([","])
            } else {
                for i in stride(from: 0, to: number + 1, by: 1) {
                    rows.append("\(i)")
                }
                components.append(rows)
            }
        }
        
        return components
    }
    
    func updateEntry() {
        entrySpeed = getPickerValue(speedPickerView)
        entryDirection = getPickerValue(directionPickerView)
    }
    
    func getPickerValue(_ pickerView: UIPickerView) -> CGFloat {
        let dataSource: [[String]]
        if pickerView == directionPickerView {
            dataSource = directionPickerData
        } else {
            dataSource = speedPickerData
        }
        var value: CGFloat = 0
        for i in 0 ..< pickerView.numberOfComponents {
            let power: CGFloat = CGFloat(pickerView.numberOfComponents - i)
            var multiplier: CGFloat = 1
            for _ in stride(from: 1, to: power, by: 1) {
                multiplier *= 10
            }
            if let data = Int(dataSource[i][pickerView.selectedRow(inComponent: i)]) {
               value += CGFloat(data) * multiplier
            }
        }
        if dataSource[dataSource.count - 2] == [","] {
            let decimal = value.truncatingRemainder(dividingBy: 10)
            value -= decimal
            value = (value / 100 ) + (decimal / 10)
            
        }
        return value
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return windData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "windDataCell", for: indexPath) as! WindDataTableViewCell
        cell.windData = windData[indexPath.row]
        
        return cell
    }
}

extension ViewController {
    //Tap actions
    
    func newEntryIsVisible() {
        newEntryView.isHidden = true
        entryDate = nil
        entryDirection = nil
        entrySpeed = nil
    }
    
    func tableViewIsVisible() {
        windDataTableView.isHidden = true
        dataTableButton.isHidden = false
    }
}

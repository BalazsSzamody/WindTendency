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
    
    var viewModel: ViewViewModel = ViewViewModel()
    
    var entryDate: Date?
    var entryDirection: CGFloat?
    var entrySpeed: CGFloat? 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // viewModel setup
        viewModel.chartSetup(speedChart: lineChart, directionChart: circleChart)
        // Do any additional setup after loading the view, typically from a nib.
        circleChart.backgroundColor = UsedColors.graphBackgroundColor
        lineChart.backgroundColor = UsedColors.graphBackgroundColor
        newEntryView.isHidden = true
        pickerProtocolSetup()
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
        entryDirection = getPickerValue(directionPickerView)
        entrySpeed = getPickerValue(speedPickerView)
     }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        guard let date = entryDate, let direction = entryDirection, let speed = entrySpeed else {
            newEntryIsVisible()
            return
        }
        viewModel.addMeasurement(MeasurementData(direction: direction, speed: speed, date: date))
        newEntryIsVisible()
    }
    @IBAction func resetButtonPressed(_ sender: Any) {
        viewModel.resetData()
        newEntryIsVisible()
    }
    
    @IBAction func dataTableButtonPressed(_ sender: Any) {
        windDataTableView.reloadData()
        windDataTableView.isHidden = false
        dataTableButton.isHidden = true
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if viewModel.windData.data.isEmpty {
            viewModel.load()
        } else {
            viewModel.save()
        }
    }
    
    @IBAction func rndButtonPressed(_ sender: Any) {
        viewModel.getRandomChart(50)
        newEntryIsVisible()
    }
    
    @IBAction func sprButtonPressed(_ sender: Any) {
        viewModel.getSpiralChart(50)
        newEntryIsVisible()
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
        return viewModel.windData.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "windDataCell", for: indexPath) as! WindDataTableViewCell
        
        let cellViewModel = viewModel.getCellViewModel(for: indexPath.row)
        cell.configure(with: cellViewModel)
        
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

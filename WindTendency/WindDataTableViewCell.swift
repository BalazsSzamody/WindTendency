//
//  WindDataTableViewCell.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2017. 11. 05..
//  Copyright © 2017. Fr3qFly. All rights reserved.
//

import UIKit




class WindDataTableViewCell: UITableViewCell {
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var windData: WindData? {
        didSet{
            guard let windData = windData else { return }
            directionLabel.text = "\(windData.direction)"
            speedLabel.text = "\(windData.speed)"
            
            dateLabel.text = windData.formatDate(format: .letters)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter =  DateFormatter()
        dateFormatter.locale = Locale(identifier: "hu_HU")
        dateFormatter.setLocalizedDateFormatFromTemplate(DateFormats.letters.rawValue)
        
        return dateFormatter.string(from: date)
    }
}

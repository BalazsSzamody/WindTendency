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
    
    var windData: MeasurementData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with viewModel: WindDataCellViewModel) {
        directionLabel.text = viewModel.directionLabel
        speedLabel.text = viewModel.speedLabel
        dateLabel.text = viewModel.dateLabel
    }
}

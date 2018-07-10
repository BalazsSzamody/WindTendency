//
//  SavedItemsTableViewController.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 29..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SavedSpotsTableViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let dataManager = DataManager.shared
    
    var viewModel: SavedSpotsViewViewModel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    func setUpTableView() {
        viewModel.spotNames
            .asObservable()
            .bind(to: tableView.rx
                .items(cellIdentifier: "savedSpotCell",
                       cellType: UITableViewCell.self)) {
                        row, spotName, cell in
                        cell.textLabel?.text = spotName
            }
        .disposed(by: disposeBag)
    }

}

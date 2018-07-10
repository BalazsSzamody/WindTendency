//
//  SavedSpotsViewViewModel.swift
//  WindTendency
//
//  Created by Szamódy Zs. Balázs on 2018. 06. 29..
//  Copyright © 2018. Fr3qFly. All rights reserved.
//

import Foundation
import RxSwift

struct SavedSpotsViewViewModel {
    var locations: [Location]
    
    var spotNames: Variable<[String]> {
        return Variable( locations.map { $0.name } )
    }
    
    init(locations: [Location]) {
        self.locations = locations
    }
}

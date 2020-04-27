//
//  LunchList.swift
//  FredsLunch
//
//  Created by MichaelBurns on 10/22/19.
//  Copyright © 2019 MichaelBurns. All rights reserved.
//

import Foundation
import CoreData

class LunchList
{
    
    var lunches = [Lunch]()
    var context : LunchData?
    
    init( _ : LunchData )
    {
        self.context = lunchData
    }
    
    func add(lunch: Lunch)
    {
        lunches.append(lunch)
    }
}

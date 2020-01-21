//
//  BarEntry.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 2/2/18.
//  Copyright © 2018 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit

struct BarEntry {
    let color: UIColor
    
    /// Ranged from 0.0 to 1.0
    let height: Double
    
    /// To be shown on top of the bar
    let textValue: String
    
    /// To be shown at the bottom of the bar
    let title: String
}


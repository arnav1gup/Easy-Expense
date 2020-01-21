//
//  MainTableViewCell.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 6/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//


import Foundation
import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var expenseLabel:UILabel!
    @IBOutlet weak var expenseCategory:UILabel!
    @IBOutlet weak var expenseAmount: UILabel!
    @IBOutlet weak var expenseCollection: UILabel!    
    @IBOutlet weak var cashOrCredit: UIImageView!
    @IBOutlet weak var convertedAmountLabel: UILabel!
    
}

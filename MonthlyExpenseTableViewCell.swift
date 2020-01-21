//
//  MonthlyExpenseTableViewCell.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 9/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MonthlyExpenseTableViewCell:UITableViewCell {
    
    @IBOutlet weak var expenseName2:UILabel!
    @IBOutlet weak var expenseAmount2:UILabel!
    @IBOutlet weak var  expenseCategory2:UILabel!
    @IBOutlet weak var  expenseCollection2:UILabel!
    @IBOutlet weak var cashOrCredit:UIImageView!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var dateLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var convertedAmountLabel:UILabel!
    
}

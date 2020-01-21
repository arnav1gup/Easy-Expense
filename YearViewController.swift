//
//  YearViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 6/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class YearViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var months:[String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December","Total"]
    var monthTotals:[Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var totalSum: Double = 0.0
    var currentDate = Date()
    var currentYear = Calendar.current.component(.year, from: Date())
    
    @IBOutlet weak var navigationBarIphoneRest: UIImageView!
    @IBOutlet weak var navigationBarIphoneX: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yearLabel: UILabel! 
    @IBAction func unwindToYearViewController(_ segue: UIStoryboardSegue) {
    }
    
    var monthPassed:String = ""
    
    var totalAmountDisplayed:String = ""
    
    var totalFinalAmount:Double = 0
    
    var monthExpenses = [Expense]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    @IBAction func moveBackToMonth(_sender:AnyObject){
        
        _ = navigationController?.popViewController(animated: true);
        
    }
    
    @IBAction func increaseYear(_sender:AnyObject){
        currentDate = Calendar.current.date(byAdding: .year, value: 1, to: currentDate)!
        currentYear = Calendar.current.component(.year, from: currentDate)
        yearLabel.text = "\(currentYear)"
        tableView.reloadData()
    }
    
    @IBAction func decreaseYear(_sender:AnyObject){
        currentDate = Calendar.current.date(byAdding: .year, value: -1, to: currentDate)!
        currentYear = Calendar.current.component(.year, from: currentDate)
        yearLabel.text = "\(currentYear)"
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.white
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentYear = Calendar.current.component(.year, from: currentDate)
        yearLabel.text = "\(currentYear)"
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.monthExpenses = CoreDataHelper.retrieveExpenses()
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 63.5;//Creating custom row height
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthCell", for: indexPath) as! YearTableViewCell
        
        totalSum = ExpensesAdditions().retrieveYearlySum2(year: "\(currentYear)")
        
        cell.monthLabel.text = months[indexPath.row]
        var temporary = ExpensesAdditions().retrieveMonthlyCashSum(month: months[indexPath.row],year: "\(currentYear)")
        var temporary2 = ExpensesAdditions().convertToMoney(temporary)
        cell.monthAmountLabel.text = "Cash Balance: "+ExpensesAdditions().defaultCurrencySymbol!+temporary2
        
        if indexPath.row == 12 {
            cell.totalSpentLabel.text = "Total Spent: "+ExpensesAdditions().defaultCurrencySymbol!+ExpensesAdditions().convertToMoney(ExpensesAdditions().retrieveYearlySum(year: "\(currentYear)"))
            cell.totalAmountLabel.text = "Cash Balance: "+ExpensesAdditions().defaultCurrencySymbol!+ExpensesAdditions().convertToMoney(totalSum)
            if totalSum < 0 {
                cell.totalAmountLabel.textColor = UIColor.red
            }
                
            else if totalSum >= 0 {
                cell.totalAmountLabel.textColor = UIColor(red:0.49, green:0.83, blue:0.13, alpha:1.0)
            }
            totalSum = 0
            cell.totalAmountLabel.isHidden = false
            cell.monthAmountLabel.isHidden = true
            cell.isUserInteractionEnabled = false
        } else {
            cell.totalSpentLabel.text = "Total Spent:"+ExpensesAdditions().defaultCurrencySymbol!+ExpensesAdditions().convertToMoney(ExpensesAdditions().retrieveMonthlySpent(month: months[indexPath.row],year:"\(currentYear)"))
            cell.totalAmountLabel.isHidden = true
            cell.monthAmountLabel.isHidden = false
        }
        
        if temporary < 0 {
            cell.monthAmountLabel.textColor = UIColor.red
        }
            
        else if temporary >= 0 {
            cell.monthAmountLabel.textColor = UIColor(red:0.49, green:0.83, blue:0.13, alpha:1.0)
        }
        
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
        if identifier=="displayMonth"{
        let monthlyDisplayController = segue.destination as! MonthlyDisplayViewController
        monthlyDisplayController.month = monthPassed
        monthlyDisplayController.year = "\(currentYear)"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 12{
        monthPassed = months[indexPath.row]
        
        performSegue(withIdentifier: "displayMonth", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 12{
            return false
        }
        else{
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let refreshAlert = UIAlertController(title: "Delete All Expense in Month", message: "All expenses in this month will also be deleted.", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                tableView.reloadData()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                let month = self.months[indexPath.row]
                for expense in self.monthExpenses{
                    if expense.modificationDate?.convertToMonth() == self.months[indexPath.row]{
                        if let expenseDeleter = self.monthExpenses.index(of: expense) {
                            self.monthExpenses.remove(at: expenseDeleter)
                            CoreDataHelper.deleteExpense(expense: expense)
                            self.monthExpenses = CoreDataHelper.retrieveExpenses()
                        }
                    }
                }
                tableView.reloadData()
            }))
            

            present(refreshAlert, animated: true, completion: nil)
            tableView.reloadData()
        }
        
    }

}



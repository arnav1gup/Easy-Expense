//
//  CollectionDisplayViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 8/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CollectionDisplayViewController:UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate{
    
    var currencyRates = [String: Double]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionDisplayed: UILabel!
    
    @IBAction func unwindToCollectionController(_ segue: UIStoryboardSegue) {
    }
    

    @IBOutlet weak var navigationBarIphoneX: UIImageView!
    @IBOutlet weak var navigationBarIphoneRest: UIImageView!
    
    var expensePerCollection = [Expense](){
        didSet {
            tableView.reloadData()
        }
    }
    @IBOutlet weak var noExpenseLabel: UILabel!
    
    var collectionNow:String?
    
    var collectionSum:Double = 0.00
    var newMode:Bool? = nil
    var expenses = [Expense]()
    var expensesRecieved:[[Expense]] = []
    var expensesKeys:[String] = []
    var filteredExpenses:[[Expense]] = []
    var filteredDates:[String] = []
    @IBOutlet weak var searchBar:UISearchBar!
    var isSearching = false

    @IBOutlet weak var cashFilter:UIButton!
    @IBOutlet weak var creditFilter:UIButton!
    @IBOutlet weak var otoN:UIButton!
    
    @IBAction func otoNTapped(_ sender:Any){
        if isSearching{
            filteredDates.reverse()
            filteredExpenses.reverse()
        }
        else{
            expensesRecieved.reverse()
            expensesKeys.reverse()
        }
        if otoN.backgroundColor == UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0){
            otoN.backgroundColor = UIColor.clear
            otoN.tintColor = UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0)
        }
        else{
            otoN.backgroundColor = UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0)
            otoN.tintColor = UIColor.white
            
        }
        tableView.reloadData()
    }
    
    @IBAction func cashButtonTapped(_ sender:Any){
        if cashFilter.backgroundColor == UIColor.clear {
            cashFilter.backgroundColor = UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0)
            cashFilter.tintColor = UIColor.white
            if creditFilter.backgroundColor == UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0){
                creditFilter.backgroundColor = UIColor.clear
                creditFilter.tintColor = UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0)
            }
            getExpenses(mode:2)
            tableView.reloadData()
            
        }
        else if cashFilter.backgroundColor == UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0) {
            cashFilter.backgroundColor = UIColor.clear
            cashFilter.tintColor = UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0)
            getExpenses(mode:1)
            tableView.reloadData()
        }
    }
    @IBAction func creditButtonTapped(_ sender:Any){
        if creditFilter.backgroundColor == UIColor.clear {
            creditFilter.backgroundColor = UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0)
            creditFilter.tintColor = UIColor.white
            if cashFilter.backgroundColor == UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0){
                cashFilter.backgroundColor = UIColor.clear
                cashFilter.tintColor = UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0)
            }
            getExpenses(mode:3)
            tableView.reloadData()
        }
        else if creditFilter.backgroundColor == UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0) {
            creditFilter.backgroundColor = UIColor.clear
            creditFilter.tintColor = UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0)
            getExpenses(mode:1)
            tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cashFilter.backgroundColor = UIColor.clear
        creditFilter.backgroundColor = UIColor.clear
        otoN.backgroundColor = UIColor.clear
        otoN.tintColor = UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0)
        cashFilter.layer.cornerRadius = 10
        creditFilter.layer.cornerRadius = 10
        otoN.layer.cornerRadius = 10
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.placeholder = "Search Expenses"
        isSearching = false
        cashFilter.tintColor = UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0)
        creditFilter.tintColor = UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0)
        
        collectionDisplayed.text = collectionNow
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        self.navigationController?.navigationBar.backItem?.title = "Back"
        noExpenseLabel.isHidden = true
        
        getExpenses(mode:1)
    }
    
    func getExpenses(mode:Int){
        if mode==1{
    GroupingOperations().getCollectionExpenses(collection: collectionNow!, completionHandler: { expenses, keys in
    self.expensesRecieved = expenses
    self.expensesKeys = keys
    })
        }
        else if mode==2{
            GroupingOperations().getCollectionCashExpenses(collection: collectionNow!, completionHandler: { expenses, keys in
                self.expensesRecieved = expenses
                //            self.filteredExpenses = expenses
                self.expensesKeys = keys
                
            })
        }
        else if mode==3{
            GroupingOperations().getCollectionCreditExpenses(collection: collectionNow!, completionHandler: { expenses, keys in
                self.expensesRecieved = expenses
                //            self.filteredExpenses = expenses
                self.expensesKeys = keys
                
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredExpenses = expensesRecieved
        filteredDates = expensesKeys
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }
        else{
            isSearching = true
            for i in 0..<expensesRecieved.count{
                filteredExpenses[i] = expensesRecieved[i].filter{ $0.name!.localizedCaseInsensitiveContains((searchBar.text)!)||$0.categories!.title!.localizedCaseInsensitiveContains((searchBar.text)!)}
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        expenses = CoreDataHelper.self.retrieveExpenses()
        var count = 0
        for expense in expenses{
            if expense.collections?.title == collectionNow {
                count += 1
            }
        }
        if count > 0{
            noExpenseLabel.isHidden = true
        }
        else {
            noExpenseLabel.isHidden = false
        }
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "changeTransaction3" {
                //let indexPath = tableView.indexPathForSelectedRow!
                let expense = sender as! Expense
                
                let displayNewTransactionController = segue.destination as! NewTransactionController
                displayNewTransactionController.newExpenses = expense
                displayNewTransactionController.transitioningController = "collectionController"
                
                UserDefaults.standard.set(expense.categories?.title, forKey: "selectedCategory")
                
                UserDefaults.standard.set(expense.collections?.title, forKey: "selectedCollection")
                
                UserDefaults.standard.set(expense.currencyName, forKey: "selectedCurrencyName")
                
                UserDefaults.standard.set(expense.currency, forKey: "selectedCurrencyCode")
                
                UserDefaults.standard.set(expense.currencySymbol, forKey: "selectedCurrencySymbol")
                
            }
            
        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching{
            return self.filteredDates.count
        }
        else{
            return self.expensesKeys.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expensesRecieved.count == 0{
            noExpenseLabel.isHidden = false
            return 0
        }
        if isSearching{
            return self.filteredExpenses[section].count
        }
        else {
            return self.expensesRecieved[section].count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionGroupCell", for: indexPath) as! CollectionDisplayTableViewCell
        
        let expense:Expense?
        
        if isSearching{
            expense = self.filteredExpenses[indexPath.section][indexPath.row]
        }
        else{
            expense = self.expensesRecieved[indexPath.section][indexPath.row]
            
        }

        tableView.rowHeight = 64

        
        var expenseAmountCalculating:Double = expense!.amount
        var expenseAmountDisplayed:String = ExpensesAdditions().convertToMoney(expenseAmountCalculating)
        
        var finalDisplayed:String = expense!.currencySymbol! + " " + expenseAmountDisplayed
        cell.expenseName.text = expense!.name
        cell.expenseName.adjustsFontSizeToFitWidth = true
        cell.expenseAmount.adjustsFontSizeToFitWidth = true
        cell.expenseAmount.text = finalDisplayed
        cell.expenseCategory.text = expense?.categories?.title
        cell.convertedAmountLabel.text = "("+ExpensesAdditions().defaultCurrencyCode!+" "+ExpensesAdditions().convertToMoney((expense?.convertedAmount)!)+")"
        
        if (expense?.expense)! {
            cell.expenseAmount.textColor = UIColor.red
        }
        else if (expense?.income)! {
            cell.expenseAmount.textColor = UIColor(red:0.49, green:0.83, blue:0.13, alpha:1.0)
            
        }
        
        if !(expense?.credit)! && (expense?.expense)!{
            cell.cashOrCredit.image = #imageLiteral(resourceName: "Cash-Expense Icon")
        }
        else if !(expense?.credit)! && (expense?.income)!{
            cell.cashOrCredit.image = #imageLiteral(resourceName: "Cash-Income Icon")
        }
        else if (expense?.credit)! && (expense?.income)!{
            cell.cashOrCredit.image = #imageLiteral(resourceName: "Credit-Income Icon")
        }
        else if (expense?.credit)! && (expense?.expense)!{
            cell.cashOrCredit.image = #imageLiteral(resourceName: "Credit-Expense Icon")
        }
    
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var a = 0.0
        if isSearching{
            if filteredExpenses[section].count==0{
                a = 0.0
            }
            else{
                a = 32.0
            }
        }
        else{
            a = 32.0
        }
        return CGFloat(a)    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var expenseSelected: Expense?
        
        if isSearching{
            expenseSelected = self.filteredExpenses[indexPath.section][indexPath.row]
        }
        else{
            expenseSelected = self.expensesRecieved[indexPath.section][indexPath.row]
            
        }
        self.performSegue(withIdentifier: "changeTransaction3", sender: expenseSelected)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let collection = self.expensesRecieved[indexPath.section][indexPath.row]
            CoreDataHelper.deleteExpense(expense: collection)
            if isSearching{
                filteredExpenses[indexPath.section].remove(at: indexPath.row)
            }
            else{
                expensesRecieved[indexPath.section].remove(at: indexPath.row )
            }
            getExpenses(mode:1)
            cashFilter.backgroundColor = UIColor.clear
            creditFilter.backgroundColor = UIColor.clear
            cashFilter.tintColor = UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0)
            creditFilter.tintColor = UIColor(red:0.25, green:0.65, blue:0.68, alpha:1.0)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderTableViewCell", owner: self, options: nil)?.first as! HeaderTableViewCell
        if isSearching{
            headerView.titleLabel.text = self.filteredDates[section].convertToHeaderCollectionString().capitalized
            headerView.totalLabel.text = String(describing:UserDefaults.standard.value(forKey: "chosenCurrencySymbol")!)+ExpensesAdditions().convertToMoney(ExpensesAdditions().retrieveDailySpent(date:self.filteredDates[section].convertToHeaderDate()))
            if filteredExpenses[section].count==0{
                headerView.isHidden = true
            }
        }
        else{
            headerView.titleLabel.text = self.expensesKeys[section].convertToHeaderCollectionString().capitalized
            headerView.totalLabel.text = String(describing:UserDefaults.standard.value(forKey: "chosenCurrencySymbol")!)+ExpensesAdditions().convertToMoney(ExpensesAdditions().retrieveDailySpent(date:self.expensesKeys[section].convertToHeaderDate()))
        }
        return headerView
}
}

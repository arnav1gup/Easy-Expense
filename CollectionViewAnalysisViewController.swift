//
//  CollectionViewAnalysisViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 16/2/18.
//  Copyright © 2018 Arnav Gupta. All rights reserved.
//

import UIKit

class CollectionViewAnalysisViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
     var categories = [Category]() {
        didSet{
            tableView.reloadData()
        }
    }
    var tupleArray:[(String,Double)] = []
    var newTuple:[(String,Double)] = []
    var hasExpenses:Bool = false

    @IBOutlet weak var noExpenseLabel: UILabel!
    var maximum:Double = 0
    var divisor:Double = 0
    var collectionName:String = ""
    var totalSpent1:Double = 0
    var cashSpent:Double = 0
    var creditSpent:Double = 0

    var filteredCategories = [Category]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    var expenses = [Expense]() {
        didSet{
            tableView.reloadData()
        }
    }
    @IBOutlet weak var currentCollection: UILabel!
    @IBOutlet weak var totalSpent: UILabel!
    @IBOutlet weak var cashAmount:UILabel!
    @IBOutlet weak var creditAmount:UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barChartView: BasicBarChart!
    override func viewDidLoad() {
        self.tabBarController?.tabBar.barTintColor = UIColor(red:0.18, green:0.21, blue:0.25, alpha:1.0)

        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.barTintColor = UIColor(red:0.18, green:0.21, blue:0.25, alpha:1.0)
        tupleArray.removeAll()
        newTuple.removeAll()
        filteredCategories.removeAll()
        categories.removeAll()
        self.categories = CoreDataHelper.retrieveCategories()
        currentCollection.text = collectionName
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor(red:0.40, green:0.43, blue:0.48, alpha:1.0)
        if ExpensesAdditions().collectionHasExpense(collection: collectionName){
            noExpenseLabel.isHidden = true
        }
        else{
            tableView.isHidden = true
            barChartView.isHidden = true
            noExpenseLabel.isHidden = false
            totalSpent.isHidden = true
            cashAmount.isHidden = true
            creditAmount.isHidden = true
        }
        totalSpent1 = ExpensesAdditions().retrieveTotalSpent(collectionName: collectionName)
        cashSpent = ExpensesAdditions().retrieveTotalCashSpent(collectionName: collectionName)
        creditSpent=ExpensesAdditions().retrieveTotalCreditSpent(collectionName: collectionName)
        
        totalSpent.text = "Total Spent: "+String(describing:UserDefaults.standard.value(forKey: "chosenCurrencySymbol")!)+ExpensesAdditions().convertToMoney(totalSpent1)
        cashAmount.text =  "Cash: "+String(describing:UserDefaults.standard.value(forKey: "chosenCurrencySymbol")!)+ExpensesAdditions().convertToMoney(cashSpent)
        creditAmount.text = "Credit: "+String(describing:UserDefaults.standard.value(forKey: "chosenCurrencySymbol")!)+ExpensesAdditions().convertToMoney(creditSpent)
        for category in categories{
            if ExpensesAdditions().categoryinCollectionHasExpense(collection: collectionName,category:category.title!){
                filteredCategories.append(category)
                tupleArray.append((category.title!, ExpensesAdditions().retrieveCategoryAnalysis(collectionName: collectionName, category: category.title!)))
            }
            else{}
        }
        newTuple = tupleArray.sorted(by: { $0.1 > $1.1 })
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if ExpensesAdditions().collectionHasExpense(collection: collectionName){
            let dataEntries = generateDataEntries()
            barChartView.dataEntries = dataEntries
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newTuple = tupleArray.sorted(by: { $0.1 > $1.1 })
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionAnalysisCell") as! CollectionAnalysisViewTableViewCell
        cell.isUserInteractionEnabled = false
        let row = indexPath.row
        let percentage:Double = (newTuple[row].1/totalSpent1)*100
        let percentageDisplay:Int = Int(percentage.rounded())
        cell.nameLabel.text = newTuple[row].0
        cell.amountLabel.text = "(\(percentageDisplay)"+"%)     "+String(describing: UserDefaults.standard.value(forKey: "chosenCurrencySymbol")!)+ExpensesAdditions().convertToMoney(newTuple[row].1)
        
        return cell
    }
    
    func generateDataEntries() -> [BarEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        maximum = newTuple[0].1
        
        var result: [BarEntry] = []
        /// ---- Complicated Divising -------//////
        var maximumString:String = ExpensesAdditions().convertToMoney(maximum)
        var maximumInt:Int = Int(maximumString.getAcronyms())!
        let endIndex = maximumString.index(maximumString.endIndex, offsetBy: -3)
        let truncated = maximumString.substring(to: endIndex)
        if maximumInt < 5{
            divisor = Double((5*(pow(10, truncated.count - 1))) as NSNumber)
        }
        else if maximumInt > 5{
            divisor = Double((pow(10, truncated.count)) as NSNumber)
        }
        for i in 0..<filteredCategories.count {
            let value = ExpensesAdditions().convertToMoney(tupleArray[i].1)
            var height:Double = Double(value)! / divisor
            result.append(BarEntry(color: colors[i % colors.count], height: height, textValue: value, title: filteredCategories[i].title!))
        }
        return result
        //// --- Complicated Divising End -------- /////
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//
//  MonthViewAnalysisViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 16/2/18.
//  Copyright © 2018 Arnav Gupta. All rights reserved.
//

import UIKit

class MonthViewAnalysisViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var categories = [Category]() {
        didSet{
            tableView.reloadData()
        }
    }
    var filteredCategories = [Category]() {
        didSet{
            tableView.reloadData()
        }
    }
    var maximum:Double = 0
    var transitioningController:String = ""
    var divisor:Double = 0
    var tupleArray:[(String,Double)] = []
    var newTuple:[(String,Double)] = []
    var totalSpent:Double = 0
    var cashSpent:Double = 0
    var creditSpent:Double = 0
    
    var expenses = [Expense]() {
        didSet{
            tableView.reloadData()
        }
    }
    var yearPassed:String = ""
    var monthPassed:String = ""
    @IBOutlet weak var monthNameLabel: UILabel!
    @IBOutlet weak var totalSpentLabel: UILabel!
    @IBOutlet weak var cashAmount:UILabel!
    @IBOutlet weak var creditAmount:UILabel!
    @IBOutlet weak var barChartView: BasicBarChart!
    @IBOutlet weak var noExpenseLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        self.tabBarController?.tabBar.barTintColor = UIColor(red:0.18, green:0.21, blue:0.25, alpha:1.0)

        super.viewDidLoad()

        
    }
    
    @IBAction func goBackButton(_ sender: Any) {
        if transitioningController=="currentYear"{
            self.performSegue(withIdentifier: "currentYearBack", sender: Any?.self)
        }
        else if transitioningController=="lastYear"{
    self.performSegue(withIdentifier: "lastYearBack", sender: Any?.self)
        }
    }
    override func viewWillAppear(_
        animated: Bool) {
        tupleArray.removeAll()
        newTuple.removeAll()
        filteredCategories.removeAll()
        categories.removeAll()
        self.categories = CoreDataHelper.retrieveCategories()
        monthNameLabel.text = "\(monthPassed) \(yearPassed)"
        tableView.tableFooterView =  UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor(red:0.40, green:0.43, blue:0.48, alpha:1.0)
        if ExpensesAdditions().monthHasExpense(month: monthPassed, year: yearPassed){
            noExpenseLabel.isHidden = true
        }
        else{
            tableView.isHidden = true
            barChartView.isHidden = true
            noExpenseLabel.isHidden = false
            totalSpentLabel.isHidden = true
            cashAmount.isHidden = true
            creditAmount.isHidden = true
        }
        totalSpent = ExpensesAdditions().retrieveMonthlyExpense(month: monthPassed, year: yearPassed)
        cashSpent = ExpensesAdditions().retrieveMonthlyCashExpense(month: monthPassed, year: yearPassed)
        creditSpent=ExpensesAdditions().retrieveMonthlyCreditExpense(month: monthPassed, year: yearPassed)
        totalSpentLabel.text = "Total Spent: "+ExpensesAdditions().convertToMoney(totalSpent)
        cashAmount.text =  "Cash: "+String(describing:UserDefaults.standard.value(forKey: "chosenCurrencySymbol")!)+ExpensesAdditions().convertToMoney(cashSpent)
        creditAmount.text = "Credit: "+String(describing:UserDefaults.standard.value(forKey: "chosenCurrencySymbol")!)+ExpensesAdditions().convertToMoney(creditSpent)
        for category in categories{
            if ExpensesAdditions().categoryinMonthHasExpense(month: monthPassed, category: category.title!, year:yearPassed){
                filteredCategories.append(category)
                tupleArray.append((category.title!,ExpensesAdditions().retrieveCategoryExpenseforMonthAnalysis(month: monthPassed, year: yearPassed, category: category.title!)))
            }
            else{}
        }
        newTuple = tupleArray.sorted(by: { $0.1 > $1.1 })
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if ExpensesAdditions().monthHasExpense(month: monthPassed, year: yearPassed){
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthAnalysisCell") as! MonthAnalysisViewTableViewCell
        cell.isUserInteractionEnabled = false

        let row = indexPath.row
        let percentage:Double = (newTuple[row].1/totalSpent)*100
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
        let maximumString:String = ExpensesAdditions().convertToMoney(maximum)
        print(maximumString)
        let maximumInt:Int = Int(maximumString.getAcronyms())!
        print(maximumInt)
        let endIndex = maximumString.index(maximumString.endIndex, offsetBy: -3)
        print(endIndex)
        let truncated = maximumString.substring(to: endIndex)
        print(truncated)
        if maximumInt < 5{
            divisor = Double(truncating: (5*(pow(10, truncated.count - 1))) as NSNumber)
        }
        else if maximumInt > 5{
            divisor = Double(truncating: (pow(10, truncated.count)) as NSNumber)
        }
        print (divisor)
        for i in 0..<filteredCategories.count {
            let value = ExpensesAdditions().convertToMoney(tupleArray[i].1)
            let height:Double = Double(value)! / divisor
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
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension String
{
    public func getAcronyms(separator: String = "") -> String
    {
        let acronyms = self.components(separatedBy: " ").map({ String($0.characters.first!) }).joined(separator: separator);
        return acronyms;
    }
}

//
//  ThisYearViewAnalysisViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 16/2/18.
//  Copyright © 2018 Arnav Gupta. All rights reserved.
//

import UIKit

class ThisYearViewAnalysisViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBAction func unwindToCurrentYearViewController(_ segue: UIStoryboardSegue) {
    }
    @IBOutlet weak var tableView:UITableView!
    var currentDate = Date()
    var currentYear = Calendar.current.component(.year, from: Date())
    var months:[String] = ["January","February", "March", "April","May","June","July","August","September","October","November","December"]
    var monthPassed:String = ""
    override func viewDidLoad() {
        self.tabBarController?.tabBar.barTintColor = UIColor(red:0.18, green:0.21, blue:0.25, alpha:1.0)

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.separatorColor = UIColor(red:0.40, green:0.43, blue:0.48, alpha:1.0)
        currentDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        currentYear = Calendar.current.component(.year, from: currentDate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "thisYearViewAnalysisCell", for: indexPath)
        cell.textLabel?.text = "\(months[indexPath.row]) \(currentYear)"
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let monthDisplayController = segue.destination as! MonthViewAnalysisViewController
       monthDisplayController.yearPassed = "\(currentYear)"
        monthDisplayController.monthPassed = self.monthPassed
        monthDisplayController.transitioningController = "currentYear"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        monthPassed = months[indexPath.row]
        self.performSegue(withIdentifier: "currentYearSegue", sender: Any.self)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
}

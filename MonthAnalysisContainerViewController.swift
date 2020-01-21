//
//  MonthAnalysisContainerViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 16/2/18.
//  Copyright © 2018 Arnav Gupta. All rights reserved.
//

import UIKit

class MonthAnalysisContainerViewController: UIViewController {

    @IBOutlet weak var lastYearView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var currentYearView: UIView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.currentYearView.alpha = 1
                self.lastYearView.alpha = 0
            })
        } else if sender.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.currentYearView.alpha = 0
                self.lastYearView.alpha = 1
            })
        }
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

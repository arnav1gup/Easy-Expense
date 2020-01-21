//
//  YearAnalysisOverViewViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 18/2/18.
//  Copyright © 2018 Arnav Gupta. All rights reserved.
//

import UIKit
import Foundation

class YearAnalysisOverViewViewController: UIViewController {
    @IBOutlet weak var currentYearView: UIView!
    @IBOutlet weak var lastYearView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

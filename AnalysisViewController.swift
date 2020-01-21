//
//  AnalysisViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 16/2/18.
//  Copyright © 2018 Arnav Gupta. All rights reserved.
//

import UIKit

class AnalysisViewController: UIViewController {

    @IBOutlet weak var monthContainerView: UIView!
    @IBOutlet weak var yearContainerView: UIView!
    @IBOutlet weak var collectionContainerView: UIView!
    
    @IBAction func showView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.monthContainerView.alpha = 1
                self.yearContainerView.alpha = 0
                self.collectionContainerView.alpha = 0
            })
        } else if sender.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.monthContainerView.alpha = 0
                self.yearContainerView.alpha = 1
                self.collectionContainerView.alpha = 0
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.monthContainerView.alpha = 0
                self.yearContainerView.alpha = 0
                self.collectionContainerView.alpha = 1
            })
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

//
//  WalktroughViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 19/2/18.
//  Copyright © 2018 Arnav Gupta. All rights reserved.
//

import UIKit

class WalktroughViewController: UIViewController {

    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBAction func unwindToWalktroughViewController(_ segue: UIStoryboardSegue) {
    }
    
    var index = 0
    var headerText = ""
    var imageName = ""
    var descriptionText = ""
    

    @IBAction func startClicked(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "DisplayedWalkthrough")
    }
    override func viewDidLoad() {
        startButton.isHidden = (index==5) ? false:true
        startButton.layer.cornerRadius = 5.0
        startButton.layer.masksToBounds = true
        
        super.viewDidLoad()
        headerLabel.text = headerText
        headerLabel.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        headerLabel.numberOfLines = 2
        pageControl.currentPage = index
        imageView.image = UIImage(named:imageName)
        descriptionLabel.text = descriptionText
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

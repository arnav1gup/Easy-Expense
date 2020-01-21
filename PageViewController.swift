//
//  PageViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 19/2/18.
//  Copyright © 2018 Arnav Gupta. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    var pageHeaders  = ["Create Expenses Daily","Store in Multiple Currencies","Track Any Day, Month and Year","Create and Sort by Collections", "View Detailed Reports on Spending",""]
    var pageImages = ["page1","page2","page3","page4","page5",""]
    var pageDescriptions = ["Track how much you spend by adding incomes and expenses and sorting them into Categories and Collections","Choose from currencies around the world and convert and view them live in your own currency","See how much you spend in any Month,any Year, Daily and even Weekly","Create large groups of expenses called Collections useful for tracking trips and vacations ","Get detailed reports on how much you are spending in each year, month and collection to save in the future!",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self

        if let startWalkthroughVC = self.viewControllerAtIndex(index: 0){
            setViewControllers([startWalkthroughVC], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func nextPagewWithIndex(index:Int){
        
    }
    func viewControllerAtIndex(index:Int) -> WalktroughViewController?{
        if index == NSNotFound || index < 0 || index >= self.pageDescriptions.count{
            return nil
        }
        if let walkThroughViewController = storyboard?.instantiateViewController(withIdentifier: "WalkThroughViewController") as? WalktroughViewController{
            walkThroughViewController.imageName = pageImages[index]
            walkThroughViewController.headerText = pageHeaders[index]
            walkThroughViewController.descriptionText = pageDescriptions[index]
            walkThroughViewController.index = index
            
            if index==6{
                walkThroughViewController.startButton.isHidden = false
                walkThroughViewController.imageView.isHidden = true
                walkThroughViewController.descriptionLabel.isHidden = true
                walkThroughViewController.headerLabel.isHidden = true
                walkThroughViewController.imageName = ""
                walkThroughViewController.descriptionText = ""
                walkThroughViewController.headerText = ""
                walkThroughViewController.index = index
            }
        
            return walkThroughViewController
        }
        return nil
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

extension PageViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalktroughViewController).index
        index-=1
        return self.viewControllerAtIndex(index: index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalktroughViewController).index
        index+=1
        return self.viewControllerAtIndex(index: index)
    }
}

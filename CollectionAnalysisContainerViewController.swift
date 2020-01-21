//
//  CollectionAnalysisContainerViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 16/2/18.
//  Copyright © 2018 Arnav Gupta. All rights reserved.
//

import UIKit

class CollectionAnalysisContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var noCollectionLabel: UILabel!
    var collectionNamePassed:String = ""
    @IBOutlet weak var tableView: UITableView!
    var collections = [Collections]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindToCollectionAnalysisViewController(_ segue: UIStoryboardSegue) {
    }
    
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
        collections = CoreDataHelper.retrieveCollections()
        if collections.count == 0{
            noCollectionLabel.isHidden = false
            tableView.isHidden = true
        }
        else{
            noCollectionLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "colletionViewAnalysis", for: indexPath)
        
        let row = indexPath.row
        let collection1 = collections[row]
        
        cell.textLabel?.text = collection1.title
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let collectionDisplayController = segue.destination as! CollectionViewAnalysisViewController
        collectionDisplayController.collectionName = collectionNamePassed
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            collectionNamePassed = collections[indexPath.row].title!
            self.performSegue(withIdentifier: "collectionSelect", sender: Any.self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

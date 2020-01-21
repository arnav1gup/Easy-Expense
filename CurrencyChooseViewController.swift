//
//  CurrencyTestViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 26/12/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit

class CurrencyChooseViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource{
    
    var fetchedCurrency = [Country2]()
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    var isSearching = false
    
    var filteredCurrencies = [Country2]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.placeholder = "Search Currencies"
        retrieveData()
        self.hideKeyboardWhenTappedAround()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredCurrencies.count
        }else {
            return fetchedCurrency.count
        }
    }
    
    func retrieveData() {
        
        fetchedCurrency = []
        
        let url = Bundle.main.url(forResource: "Common-Currency", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! [String:Any]
            
            let currencies = json["Currencies"] as! [String: [String:Any]]
            let currencyCodes = currencies.keys.sorted()
            for code in currencyCodes {
                let currency = currencies[code]!
                let currencyName = currency["name"] as! String
                let currencySymbol = currency["symbol_native"] as! String
                self.fetchedCurrency.append(Country2(currencyCode: code, currencyName: currencyName, currencySymbol: currencySymbol))
                
            }
        }
        catch {
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyChooseCell", for: indexPath) as! CurrencyChooseTableViewCell
        
        if isSearching{
            
            cell.currencyLabel.text = "\(filteredCurrencies[indexPath.row].currencyCode) -  \(filteredCurrencies[indexPath.row].currencyName)"
            cell.currencyLabel.adjustsFontSizeToFitWidth = true
            cell.currencyLabel.minimumScaleFactor = 0.2
        }
            
        else {
            cell.currencyLabel.text = "\(fetchedCurrency[indexPath.row].currencyCode) -  \(fetchedCurrency[indexPath.row].currencyName)"
            cell.currencyLabel.adjustsFontSizeToFitWidth = true
            cell.currencyLabel.minimumScaleFactor = 0.2
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyChooseCell", for: indexPath) as! CurrencyChooseTableViewCell
        cell.accessoryType = .checkmark
        if isSearching {
            UserDefaults.standard.set(filteredCurrencies[indexPath.row].currencyCode, forKey: "chosenCurrencyCode")
            UserDefaults.standard.set(filteredCurrencies[indexPath.row].currencySymbol, forKey: "chosenCurrencySymbol")
            UserDefaults.standard.set(filteredCurrencies[indexPath.row].currencyName, forKey: "chosenCurrencyName")
        }
            else{
                UserDefaults.standard.set(fetchedCurrency[indexPath.row].currencyCode, forKey: "chosenCurrencyCode")
                UserDefaults.standard.set(fetchedCurrency[indexPath.row].currencySymbol, forKey: "chosenCurrencySymbol")
                UserDefaults.standard.set(fetchedCurrency[indexPath.row].currencyName, forKey: "chosenCurrencyName")
            }
            performSegue(withIdentifier: "goBacktoLogin", sender: self)
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        }
        else {
            isSearching = true
            filteredCurrencies = fetchedCurrency.filter{ $0.currencyCode.contains((searchBar.text?.localizedUppercase)!)}
            tableView.reloadData()
            
        }
    }
}

class Country2 {
    var currencyCode: String
    var currencyName: String
    var currencySymbol: String
    init(currencyCode:String, currencyName: String, currencySymbol: String){
        self.currencyName = currencyName
        self.currencyCode = currencyCode
        self.currencySymbol = currencySymbol
    }
}


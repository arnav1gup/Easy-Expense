//
//  CurrencyTestViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 26/12/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import Foundation
import UIKit

class CurrencyTestViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource{
    
    var fetchedCurrency = [Country]()
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    var isSearching = false
    var lastUsedCurrencyCode:String = ExpensesAdditions().defaultCurrencyCode!
    var lastUsedCurrencySymbol:String = ExpensesAdditions().defaultCurrencySymbol!
    var lastUsedCurrencyName:String = ExpensesAdditions().defualtCurrencyName!
    
    @IBOutlet weak var navigationBarIphoneRest: UIImageView!
    @IBOutlet weak var navigationBarIphoneX: UIImageView!
    var filteredCurrencies = [Country]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
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
             self.fetchedCurrency.append(Country(currencyCode: "", currencyName: "", currencySymbol: ""))
            for code in currencyCodes {
                let currency = currencies[code]!
                let currencyName = currency["name"] as! String
                let currencySymbol = currency["symbol_native"] as! String
                self.fetchedCurrency.append(Country(currencyCode: code, currencyName: currencyName, currencySymbol: currencySymbol))
                
            }
        }
        catch {
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "currencyCell2") as! CurrencyTableViewCell2
        
        if isSearching{
            
            cell.currencyLabel.text = "\(filteredCurrencies[indexPath.row].currencyCode) -  \(filteredCurrencies[indexPath.row].currencyName)"
            cell.currencyLabel.adjustsFontSizeToFitWidth = true
            cell.currencyLabel.minimumScaleFactor = 0.2
        }
        
        else {
            
            if let currencyCode = UserDefaults.standard.string(forKey: "lastUsedCurrencyCode") {
                self.lastUsedCurrencyCode = currencyCode
            }
            if let currencyName = UserDefaults.standard.string(forKey: "lastUsedCurrencyName") {
                self.lastUsedCurrencyName = currencyName
            }
            if let currencySymbol = UserDefaults.standard.string(forKey: "lastUsedCurrencySymbol") {
                self.lastUsedCurrencySymbol = currencySymbol
            }

            cell2.currencyLabel2.text = lastUsedCurrencyCode+" - "+lastUsedCurrencyName
            cell.currencyLabel.text = "\(fetchedCurrency[indexPath.row].currencyCode) -  \(fetchedCurrency[indexPath.row].currencyName)"
            cell.currencyLabel.adjustsFontSizeToFitWidth = true
            cell.currencyLabel.minimumScaleFactor = 0.2
        }
        if indexPath.row == 0 && !isSearching{
            tableView.rowHeight = 109
            cell.isHidden=true
            return cell2
        }
        else{
            tableView.rowHeight = 44
        return cell
        }
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyTableViewCell
        cell.accessoryType = .checkmark
        if isSearching {
            UserDefaults.standard.set(filteredCurrencies[indexPath.row].currencyCode, forKey: "selectedCurrencyCode")
            UserDefaults.standard.set(filteredCurrencies[indexPath.row].currencySymbol, forKey: "selectedCurrencySymbol")
            UserDefaults.standard.set(filteredCurrencies[indexPath.row].currencyName, forKey: "selectedCurrencyName")
            UserDefaults.standard.set(filteredCurrencies[indexPath.row].currencyCode, forKey: "lastUsedCurrencyCode")
            UserDefaults.standard.set(filteredCurrencies[indexPath.row].currencySymbol, forKey: "lastUsedCurrencySymbol")
            UserDefaults.standard.set(filteredCurrencies[indexPath.row].currencyName, forKey: "lastUsedCurrencyName")
            
        }else {
            if indexPath.row == 0{
                UserDefaults.standard.set(lastUsedCurrencyCode, forKey: "selectedCurrencyCode")
                UserDefaults.standard.set(lastUsedCurrencySymbol, forKey: "selectedCurrencySymbol")
                UserDefaults.standard.set(lastUsedCurrencySymbol, forKey: "selectedCurrencyName")
                UserDefaults.standard.set(lastUsedCurrencyCode, forKey: "lastUsedCurrencyCode")
                UserDefaults.standard.set(lastUsedCurrencySymbol, forKey: "lastUsedCurrencySymbol")
                UserDefaults.standard.set(lastUsedCurrencyName, forKey: "lastUsedCurrencyName")
            }
            else{
            UserDefaults.standard.set(fetchedCurrency[indexPath.row].currencyCode, forKey: "selectedCurrencyCode")
            UserDefaults.standard.set(fetchedCurrency[indexPath.row].currencySymbol, forKey: "selectedCurrencySymbol")
            UserDefaults.standard.set(fetchedCurrency[indexPath.row].currencyName, forKey: "selectedCurrencyName")
            UserDefaults.standard.set(fetchedCurrency[indexPath.row].currencyCode, forKey: "lastUsedCurrencyCode")
            UserDefaults.standard.set(fetchedCurrency[indexPath.row].currencySymbol, forKey: "lastUsedCurrencySymbol")
            UserDefaults.standard.set(fetchedCurrency[indexPath.row].currencyName, forKey: "lastUsedCurrencyName")
            }
            
        }
        
        performSegue(withIdentifier: "unwindToNewTransactionViewController", sender: self)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
    }
        else {
            isSearching = true
            filteredCurrencies = fetchedCurrency.filter{ $0.currencyCode.contains((searchBar.text?.localizedUppercase)!) }
            tableView.reloadData()
        }
}
}

class Country {
    var currencyCode: String
    var currencyName: String
    var currencySymbol: String
    init(currencyCode:String, currencyName: String, currencySymbol: String){
        self.currencyName = currencyName
        self.currencyCode = currencyCode
        self.currencySymbol = currencySymbol
}
}

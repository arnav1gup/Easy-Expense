//
//  ExpencesAdditions.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 28/12/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.
//

import UIKit


class ExpensesAdditions: NSObject {
    var monthlyExpenses = [Expense]()
    var isconnected:Bool = false
    var categories = [Category]()
    var currencyRates = [String: Double]()
    let userDefaults=UserDefaults.standard 
   var sum:Double = 0.0
    var urlArray:[String] = ["376fa06c3a104a21a0f94bd901a1e79","09964d91033a41fca245aa7c8eedac44","8e6be26560c0472885ae1e304fa22991","e31cfff29c4c46c0b986801988be3de9","e8a68ed339024ac9a6b6668c4bc9ef18","6848b5e89ace4eb9a4acfbdb241007c8","4683d543327c4b918fdd82ff9f4daf62","7e2bb31e2fd4447ca5457788ad9d20cc","55d118a13b064710b08aef66a1ed02f2","bc8a5429bf9f4746940717e55014b002","3d22772ec9104260a3e75f01626ff812","47e6cce739c04b6a8dcdb5c7adda52f1","a0b7499e40594fecb66d9965fa972de7","d36060f644114c468409466a401773c3","38544992a7c84dd8a1b1f3f8f363a4cf","f45d10cc0a0244da8b171b5d1a46ad78","3337ad4009a34693bef206cbbc7c260c","155137aff3b84d32a675de403b55391d","a6a7a965a835433591ea3b33cbc9bb9c","2b64fe4c76214004b99235b34da496a7","9544e86dd4ec44d3849e7e61130da0dd","d2d8df5495e64a38a7e992ed690f433f","c5daa877c6dc4d1cbd065dc66936a773","b95f6f5392ec4cf98ffc3e8c2b8784d7","df4e29d6073643cfb1a7a0a6786a92ec","76905591ad7745bc8fa6c9b2401efa30","704f892e0ecf421aa664a7ce03c6180d"]

    var defaultCurrencyCode = UserDefaults.standard.string(forKey: "chosenCurrencyCode")
    var defualtCurrencyName = UserDefaults.standard.string(forKey: "chosenCurrencyName")
    var defaultCurrencySymbol = UserDefaults.standard.string(forKey: "chosenCurrencySymbol")
    
    func initialiseApiTracker()
    {
        if UserDefaults.standard.integer(forKey: "current") == 0
        {
            UserDefaults.standard.set(0, forKey: "current" )
        }
        else
        {
        }
        
    }
    
    func convertToMoney(_ money:Double)->String{
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return(numberFormatter.string(for: money))!
    }
    func retrieveYearlySum(year:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var sum:Double = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToYear() == year && expense.expense {
                    sum += expense.convertedAmount
            }
        }
        return sum
    }
    func retrieveYearlySum2(year:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var sum:Double = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToYear() == year && expense.income && !expense.credit {
                sum += expense.convertedAmount
            }
            else if expense.modificationDate?.convertToYear() == year && expense.expense && !expense.credit{
                sum -= expense.convertedAmount
            }
        }
        return sum
    }
    func retrieveYearlyCashSum(year:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var sum:Double = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToYear() == year && expense.expense && !expense.credit {
                
                    sum += expense.convertedAmount
            }
        }
        return sum
    }
    func retrieveYearlyCreditSum(year:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var sum:Double = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToYear() == year && expense.expense && expense.credit {
                sum += expense.convertedAmount
            }
        }
        return sum
    }
    func retrieveMonthlySpent(month:String, year:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var sum:Double = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToMonth() == month && expense.expense && expense.modificationDate?.convertToYear() == year{
                sum += expense.convertedAmount
            }
        }
        return sum
    }
    
    func categoryinCollectionHasExpense(collection:String,category:String) -> Bool{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()

        var count:Int = 0
        for expense in monthlyExpenses{
            if expense.collections?.title == collection && expense.categories?.title == category && expense.expense{
                count += 1
            }
        }
        if count > 0{
            return true
        }
        else {
            return false
        }
    }
    func categoryinYearHasExpense(year:String,category:String) -> Bool{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        
        var count:Int = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToYear() == year && expense.categories?.title == category && expense.expense{
                count += 1
            }
        }
        if count > 0{
            return true
        }
        else {
            return false
        }
    }
    func categoryinMonthHasExpense(month:String,category:String,year:String) -> Bool{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var count:Int = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToMonth() == month && expense.categories?.title == category && expense.modificationDate?.convertToYear() == year && expense.expense{
                count += 1
            }
        }
        if count > 0{
            return true
        }
        else {
            return false
        }
    }
    func collectionHasExpense(collection:String) -> Bool{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var count:Int = 0
        for expense in monthlyExpenses{
            if expense.collections?.title == collection && expense.expense{
                count += 1
            }
        }
        if count > 0{
            return true
        }
        else {
            return false
        }
    }
    func monthHasExpense(month:String,year:String) -> Bool{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()

        var count:Int = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToMonth() == month && expense.modificationDate?.convertToYear() == year && expense.expense{
                count += 1
            }
        }
        if count > 0{
            return true
        }
        else {
            return false
        }
    }
    func yearHasExpense(year:String) -> Bool{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var count:Int = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToYear() == year && expense.expense{
                count += 1
            }
        }
        if count > 0{
            return true
        }
        else {
            return false
        }
    }
    
    func retrieveCategoryExpenseForYear(category:String, year:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var sum:Double = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToYear()==year && expense.categories?.title==category && expense.expense{
                sum += expense.convertedAmount
            }
        }
        return sum
    }
    func retrieveCategoryExpenseforMonthAnalysis(month:String, year:String, category:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var sum:Double = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToMonth()==month && expense.modificationDate?.convertToYear()==year && expense.expense && expense.categories?.title==category{
                sum += expense.convertedAmount
            }
        }
        return sum
    }
    func retrieveCollectionExpenseforMonthAnalysis(month:String, year:String, collection:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var sum:Double = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToMonth()==month && expense.modificationDate?.convertToYear()==year && expense.expense && expense.collections?.title==collection{
                sum += expense.convertedAmount
            }
        }
        return sum
    }
    func retrieveMonthlyExpense(month:String, year:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var sum:Double = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToMonth()==month && expense.modificationDate?.convertToYear()==year && expense.expense{
                sum += expense.convertedAmount
            }
        }
        return sum
    }
    func retrieveMonthlyCreditExpense(month:String, year:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var sum:Double = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToMonth()==month && expense.modificationDate?.convertToYear()==year && expense.expense && expense.credit{
                sum += expense.convertedAmount
            }
        }
        return sum
    }
    func retrieveMonthlyCashExpense(month:String, year:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses()
        var sum:Double = 0
        for expense in monthlyExpenses{
            if expense.modificationDate?.convertToMonth()==month && expense.modificationDate?.convertToYear()==year && expense.expense && !expense.credit{
                sum += expense.convertedAmount
            }
        }
        return sum
    }
    func retrieveCategoryAnalysis(collectionName:String, category:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses().sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        for expense in monthlyExpenses {
            if expense.collections?.title == collectionName && expense.categories?.title == category && expense.expense{
                if expense.expense {
                    sum = sum + expense.convertedAmount
                }
            }
    }
        return sum
    }
    func retrieveTotalCreditSpent(collectionName:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses().sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        for expense in monthlyExpenses {
            if expense.collections?.title == collectionName && expense.expense && expense.credit {
                    sum = sum + expense.convertedAmount
        }
        }
        return sum
    }
    func retrieveTotalCashSpent(collectionName:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses().sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        for expense in monthlyExpenses {
            if expense.collections?.title == collectionName && expense.expense && !expense.credit {
                sum = sum + expense.convertedAmount
            }
        }
        return sum
    }
    func retrieveTotalSpent(collectionName:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses().sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        for expense in monthlyExpenses {
            if expense.collections?.title == collectionName && expense.expense {
                sum = sum + expense.convertedAmount
            }
        }
        return sum
    }
    func retrieveDailySpent(date:String) -> Double  {
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses().sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        var sum = 0.0
        for expense in monthlyExpenses {
            if expense.modificationDate?.convertToJSONDate()==date && expense.expense{
                sum = sum + expense.convertedAmount
            }
        }
        return sum
    }
    
    func retrieveDailySpentforCollection(date:String,collection:String) -> Double  {
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses().sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        var sum = 0.0
        for expense in monthlyExpenses {
            if (expense.modificationDate?.convertToJSONDate())!==date && expense.expense && expense.collections?.title!==collection{
                sum = sum + expense.convertedAmount
            }
        }
        return sum
    }
    
    func retrieveWeeklySum(week:Int) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses().sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        for expense in monthlyExpenses {
            let weekOfYear = Calendar.current.component(.weekOfYear, from: expense.modificationDate as! Date)
            if weekOfYear == week{
            if expense.expense {
                sum = sum - expense.convertedAmount
            } else if expense.income {
                sum = sum + expense.convertedAmount
            }
        }
    }
        return sum
    }
    func retrieveMonthlySum(month:String,year:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses().sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        for expense in monthlyExpenses {
            if expense.modificationDate?.convertToMonth() == month && expense.modificationDate?.convertToYear() == year {
                if expense.expense {
                    sum = sum - expense.convertedAmount
                } else if expense.income {
                    sum = sum + expense.convertedAmount
                }
            }
        }
        return sum
    }
    
    func retrieveMonthlyCashSum(month:String,year:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses().sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        for expense in monthlyExpenses {
            if expense.modificationDate?.convertToMonth() == month && expense.modificationDate?.convertToYear() == year && !expense.credit{
                if expense.expense {
                    sum = sum - expense.convertedAmount
                } else if expense.income {
                    sum = sum + expense.convertedAmount
                }
            }
        }
        return sum
    }
    
    func retrieveMonthlyCreditSum(month:String,year:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses().sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        for expense in monthlyExpenses {
            if expense.modificationDate?.convertToMonth() == month && expense.modificationDate?.convertToYear() == year && expense.credit {
                if expense.expense {
                    sum = sum - expense.convertedAmount
                } else if expense.income {
                    sum = sum + expense.convertedAmount
                }
            }
        }
        return sum
    }
    
    func retrieveCollectionSum(collectionName:String) -> Double{
        self.monthlyExpenses = CoreDataHelper.retrieveExpenses().sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        for expense in monthlyExpenses {
            if expense.collections?.title == collectionName && !expense.credit {
                if expense.expense {
                    sum = sum - expense.convertedAmount
                } else if expense.income {
                    sum = sum + expense.convertedAmount
                }
            }
        }
        return sum
    }
    
    func convert(currencyToConvert:String,amount:Double,
        currencyToConvertTo:String,date:String)->Double{
        var a:Double = 0.0
        var currencyFetched:Bool = false
        if currencyToConvert == currencyToConvertTo{
            a = amount
            currencyFetched = true
        }
        else{
            self.makeConnection(date: date)
        repeat{
                if let x = self.currencyRates[currencyToConvert]{
                    if currencyToConvert == "USD"{
                        a = amount*self.currencyRates[defaultCurrencyCode!]!
                    }
                    else {
                    a = (amount*self.currencyRates[currencyToConvertTo]!)/x
                    }
                    currencyFetched = true
                }
                else {
                    currencyFetched = false
                    usleep(40000)
                }
        }while currencyFetched == false
        }
        return a}
    
    func makeConnection(date:String){
        currencyRates.removeAll()
        var count:Int = UserDefaults.standard.integer(forKey: "current")
        let appID = urlArray[count]
        let url = URL(string: "https://openexchangerates.org/api/historical/\(date).json?app_id="+appID)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            var code=200
            if let httpResponse = response as? HTTPURLResponse {
                code=httpResponse.statusCode
            }
            if code != 200
             {
                count=count+1
                if count == self.urlArray.count
              {
                count = 0
             }
                UserDefaults.standard.set(count, forKey: "current")
                self.makeConnection(date: date)
            }
            else
            {if let content = data{
                    do{
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        if let rates = myJson["rates"] as? NSDictionary{
                            self.isconnected = true
                            for (key, value) in rates
                            {
                                self.currencyRates[(key as? String)!] = value as? Double
                            }
                        }}
                    catch
                    {}}}}
        task.resume()}}

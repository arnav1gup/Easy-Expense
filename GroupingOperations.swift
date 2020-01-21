//
//  GroupingOperations.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 20/1/18.
//  Copyright © 2018 Arnav Gupta. All rights reserved.
//

import UIKit

class GroupingOperations: NSObject {
    
    var expenses = [Expense]()
    var expensePerCollection = [Expense]()
    var expensePerMonth = [Expense]()
    
    public func getCollectionExpenses
        (collection: String, completionHandler:
        @escaping([[Expense]], [String]) -> Void){
        self.expenses = CoreDataHelper.retrieveExpenses()
        for eachExpense in expenses{
            if eachExpense.collections?.title == collection{
                expensePerCollection.append(eachExpense)
            }
        }
    
        let sortedExpensePerCollection =
            expensePerCollection.sorted(by:
        { $0.modificationDate as! Date > $1.modificationDate as! Date})
        var groupedExpenses = Dictionary(
        grouping: sortedExpensePerCollection,
        by: {($0.modificationDate! as Date).convertToJSONDate()})
        
        let keys = Array(groupedExpenses.keys)
        let sortedKeys = keys.sorted(by: {$0 > $1})
        var items:[[Expense]] = []
        
        for eachKey in sortedKeys {
            items.append(groupedExpenses[eachKey]!)
        }
        completionHandler(items, sortedKeys)
    }
    
    public func getCollectionCashExpenses(collection: String, completionHandler: @escaping([[Expense]], [String]) -> Void){
        self.expenses = CoreDataHelper.retrieveExpenses()
        for eachExpense in expenses{
            if eachExpense.collections?.title == collection && !eachExpense.credit{
                expensePerCollection.append(eachExpense)
            }
        }
        
        let sortedExpensePerCollection = expensePerCollection.sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        var groupedExpenses = Dictionary(grouping: sortedExpensePerCollection, by: {($0.modificationDate! as Date).convertToJSONDate()})
        
        let keys = Array(groupedExpenses.keys)
        let sortedKeys = keys.sorted(by: {$0 > $1})
        var items:[[Expense]] = []
        
        for eachKey in sortedKeys {
            items.append(groupedExpenses[eachKey]!)
        }
        completionHandler(items, sortedKeys)
    }
    
    public func getCollectionCreditExpenses(collection: String, completionHandler: @escaping([[Expense]], [String]) -> Void){
        self.expenses = CoreDataHelper.retrieveExpenses()
        for eachExpense in expenses{
            if eachExpense.collections?.title == collection && eachExpense.credit{
                expensePerCollection.append(eachExpense)
            }
        }
        
        let sortedExpensePerCollection = expensePerCollection.sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        var groupedExpenses = Dictionary(grouping: sortedExpensePerCollection, by: {($0.modificationDate! as Date).convertToJSONDate()})
        
        let keys = Array(groupedExpenses.keys)
        let sortedKeys = keys.sorted(by: {$0 > $1})
        var items:[[Expense]] = []
        
        for eachKey in sortedKeys {
            items.append(groupedExpenses[eachKey]!)
        }
        completionHandler(items, sortedKeys)
    }

    
    public func getMonthExpenses(month: String, year:String, completionHandler: @escaping([[Expense]], [String]) -> Void){
        self.expenses = CoreDataHelper.retrieveExpenses()
        for eachExpense in expenses{
            if eachExpense.modificationDate?.convertToMonth() == month && eachExpense.modificationDate?.convertToYear() == year{
                expensePerMonth.append(eachExpense)
            }
        }
        
        let sortedExpensePerCollection = expensePerMonth.sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        var groupedExpenses = Dictionary(grouping: sortedExpensePerCollection, by: {($0.modificationDate! as Date).convertToJSONDate()})
        
        let keys = Array(groupedExpenses.keys)
        let sortedKeys = keys.sorted(by: {$0 > $1})
        var items:[[Expense]] = []
        
        for eachKey in sortedKeys {
            items.append(groupedExpenses[eachKey]!)
        }
        completionHandler(items, sortedKeys)
    }
    
    public func getMonthCashExpenses(month: String, year:String, completionHandler: @escaping([[Expense]], [String]) -> Void){
        self.expenses = CoreDataHelper.retrieveExpenses()
        for eachExpense in expenses{
            if eachExpense.modificationDate?.convertToMonth() == month && eachExpense.modificationDate?.convertToYear() == year && !eachExpense.credit{
                expensePerMonth.append(eachExpense)
            }
        }
        
        let sortedExpensePerCollection = expensePerMonth.sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        var groupedExpenses = Dictionary(grouping: sortedExpensePerCollection, by: {($0.modificationDate! as Date).convertToJSONDate()})
        
        let keys = Array(groupedExpenses.keys)
        let sortedKeys = keys.sorted(by: {$0 > $1})
        var items:[[Expense]] = []
        
        for eachKey in sortedKeys {
            items.append(groupedExpenses[eachKey]!)
        }
        completionHandler(items, sortedKeys)
    }
    
    public func getMonthCreditExpenses(month: String, year:String, completionHandler: @escaping([[Expense]], [String]) -> Void){
        self.expenses = CoreDataHelper.retrieveExpenses()
        for eachExpense in expenses{
            if eachExpense.modificationDate?.convertToMonth() == month && eachExpense.modificationDate?.convertToYear() == year && eachExpense.credit{
                expensePerMonth.append(eachExpense)
            }
        }
        
        let sortedExpensePerCollection = expensePerMonth.sorted(by: { $0.modificationDate as! Date > $1.modificationDate as! Date})
        var groupedExpenses = Dictionary(grouping: sortedExpensePerCollection, by: {($0.modificationDate! as Date).convertToJSONDate()})
        
        let keys = Array(groupedExpenses.keys)
        let sortedKeys = keys.sorted(by: {$0 > $1})
        var items:[[Expense]] = []
        
        for eachKey in sortedKeys {
            items.append(groupedExpenses[eachKey]!)
        }
        completionHandler(items, sortedKeys)
    }
}



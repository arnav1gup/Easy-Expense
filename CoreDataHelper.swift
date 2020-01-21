//
//  CoreDataHelper.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 7/8/17.
//  Copyright © 2017 Arnav Gupta. All rights reserved.

import UIKit
import Foundation
import CoreData

class CoreDataHelper {
    
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    //--Category Methods--//
    static func createNewCategory() -> Category {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Category",
        into: managedContext) as! Category
        return entity
    }
    static func save() {
        do {
            try managedContext.save()
            
        } catch let error as NSError {
        }}
    static func retrieveCategories() -> [Category] {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Category")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results as! [Category]
        } catch let error as NSError {
        }
    return []
    }
    static func deleteCategory(category:Category) {
        managedContext.delete(category)
        save()
    }
    //-- Category Methods End--//
    
    
    //--Collection Methods--//
    static func createNewCollection() -> Collections {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Collections", into: managedContext) as! Collections
        return entity
    }
    static func retrieveCollections() -> [Collections] {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Collections")
        
        do {
            let results2 = try managedContext.fetch(fetchRequest)
            return results2 as! [Collections]
        } catch let error as NSError {
        }
        return []
    }
    static func deleteCollection(collection:Collections) {
        managedContext.delete(collection)
        save()
    }
    //--Collection Methods End --//
    
    //---New Expense Method Start --//
    
    static func newExpense() -> Expense {
        let expense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: managedContext) as! Expense
        return expense
    }
    
    static func deleteExpense(expense:Expense) {
        managedContext.delete(expense)
        save()
    }
    static func retrieveExpenses() -> [Expense] {
        let fetchRequest = NSFetchRequest<Expense>(entityName: "Expense")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results.sorted { $0.modificationDate?.compare($1.modificationDate! as Date) == ComparisonResult.orderedAscending }
        } catch let error as NSError{
        }
        return []
    }

   
    }




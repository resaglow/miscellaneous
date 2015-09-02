//
//  DataManager.swift
//  yamoneySample
//
//  Created by Artem Lobanov on 20/08/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

import Foundation
import CoreData

class CategoryDataManager {
    var managedObjectContext: NSManagedObjectContext? = nil
    var delegate: NSFetchedResultsControllerDelegate? = nil
    var parentCategory: Category? = nil
    
    // MARK: - Fetched results controller
    
    init(MOC: NSManagedObjectContext?, delegate: NSFetchedResultsControllerDelegate?, parentCategory: Category?) {
        managedObjectContext = MOC
        self.delegate = delegate
        self.parentCategory = parentCategory
    }
    private init() {}
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let curParentCategory = parentCategory {
            fetchRequest.predicate = NSPredicate(format: "parent == %@", curParentCategory)
        } else {
            fetchRequest.predicate = NSPredicate(format:"parent == nil")
        }
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!,
            sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = delegate!
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            println("Error getting fetchedResultsController, \(error), \(error?.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil    
    
    // Obviously not that effecient, yet deleting/adding wouldn't give much profit
    // (inherently not a lot of data stored as categories)
    func clearCategories() {
        let entity = self.fetchedResultsController.fetchRequest.entity!
        var fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.includesPropertyValues = false
        
        var error: NSError? = nil
        if let res = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject] {
            for managedObject in res {
                self.managedObjectContext!.deleteObject(managedObject)
            }
        }
    }
    
    
    func persistCategories(jsonCategories: [[String: AnyObject]], parentCategory: Category?) {
        for category in jsonCategories {
            var newCategory = NSEntityDescription.insertNewObjectForEntityForName("Category",
                inManagedObjectContext: self.managedObjectContext!) as! Category
            
            newCategory.subs = NSSet()
            
            for (key, value) in category {
                switch (key) {
                case "id":
                    if let val = value as? NSNumber {
                        newCategory.id = val
                    }
                case "title":
                    if let val = value as? String {
                        newCategory.title = val
                    }
                case "subs":
                    if let subCategories = value as? [[String: AnyObject]] {
                        persistCategories(subCategories, parentCategory:newCategory)
                    }
                default:
                    break
                }
                
                // Defining parent relationship
                newCategory.parent = parentCategory
                if let parentCat = parentCategory {
                    var subs = parentCat.mutableSetValueForKey("subs");
                    // Defining child relationship
                    subs.addObject(newCategory)
                }
            }
        }
    }
}
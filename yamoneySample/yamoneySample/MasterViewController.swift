//
//  MasterViewController.swift
//  yamoneySample
//
//  Created by Artem Lobanov on 19/08/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController:UITableViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var dataManager: CategoryDataManager? = nil
    
    var parentCategory: Category? = nil
    
    var rootControllerFlag: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        super.refreshControl = UIRefreshControl()
        super.tableView.bounces = false
        
        if rootControllerFlag {
            let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "updateCategories:")
            self.navigationItem.rightBarButtonItem = refreshButton
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        self.tableView.delegate = self
        self.dataManager = CategoryDataManager(MOC: self.managedObjectContext, delegate: self, parentCategory: parentCategory)
    }
    
    private var once: dispatch_once_t = 0
    override func viewDidAppear(animated: Bool) {
        // Can't move it to viewDidLoad because have to know when tableView finishes dataSource methods
        // Don't know how to do know it within viewDidLoad, yet this seems ok as well
        dispatch_once(&once, {
            if self.rootControllerFlag {
                self.dataManager!.fetchedResultsController.performFetch(nil)
                self.updateCategories(nil);
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataManager!.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.dataManager!.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let category = self.dataManager!.fetchedResultsController.objectAtIndexPath(indexPath) as? Category {
            if (category.subs.count == 0) {
                cell.accessoryType = .None
                cell.selectionStyle = .None
            } else {
                cell.accessoryType = .DisclosureIndicator
                cell.selectionStyle = .Default
            }
            cell.textLabel!.text = category.title
            println("\(category.title), \(category.subs.count)")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let category = self.dataManager!.fetchedResultsController.objectAtIndexPath(indexPath) as! Category
        if (category.subs.count != 0) {
            var storyboard = UIStoryboard (name: "Main", bundle: nil)
            var subsVC = storyboard.instantiateViewControllerWithIdentifier("MasterViewController") as! MasterViewController
            
            subsVC.managedObjectContext = self.managedObjectContext
            subsVC.parentCategory = category
            subsVC.rootControllerFlag = false
            subsVC.navigationItem.title = category.title
            
            self.navigationController?.pushViewController(subsVC, animated: true)
        }
    }
    
    func updateCategories(sender: AnyObject?) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.setContentOffset(CGPoint(x: 0.0, y:-120.0), animated: true)
            super.refreshControl?.beginRefreshing()
        })
        
        let client = YaMoneyClient.sharedClient
        client.getCategoriesWithCompletion({ jsonData, clientError in
            if clientError == nil && jsonData != nil {
                var parsingError: NSError? = nil
                if let parsedResult = NSJSONSerialization.JSONObjectWithData(
                    jsonData!, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? [[String: AnyObject]] {
                        
                        var savingError: NSError? = nil
                        
                        // Could've moved this to dataManager, yet IMO code would become more cumbersome in that case
                        self.dataManager!.clearCategories()
                        if !(self.managedObjectContext!.save(&savingError)) {
                            println("Context saving error, \(savingError?.description)")
                        }
                        
                        self.dataManager!.persistCategories(parsedResult, parentCategory: nil)
                        if !(self.managedObjectContext!.save(&savingError)) {
                            println("Context saving error, \(savingError?.description)")
                        } else {
                            var fetchingError: NSError? = nil
                            if !(self.dataManager!.fetchedResultsController.performFetch(&fetchingError)) {
                                println("Fetching error, \(fetchingError?.description)")
                            } else {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.tableView.reloadData()
                                })
                            }
                        }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                super.refreshControl?.endRefreshing()
            })
        })
    }
}
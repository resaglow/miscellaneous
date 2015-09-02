//
//  Category.swift
//  yamoneySample
//
//  Created by Artem Lobanov on 20/08/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

import Foundation
import CoreData

@objc(Category)
class Category: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var subs: NSSet
    @NSManaged var parent: Category?

}
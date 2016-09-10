//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Chiranth Bangalore Sathyaprakash on 9/1/16.
//  Copyright © 2016 Chiranth Bangalore Sathyaprakash. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate() // assign date to created attibute in Item
    }
}

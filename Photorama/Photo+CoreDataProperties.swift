//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Natash Bangera on 17/8/16.
//  Copyright © 2016 Natash Bangera. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var photoID: String
    @NSManaged var photoKey: String
    @NSManaged var title: String
    @NSManaged var dateTaken: NSDate
    @NSManaged var remoteURL: NSURL
    @NSManaged var tags: Set<NSManagedObject>

}

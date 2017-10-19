//
//  Media+CoreDataProperties.swift
//  AddressFinder
//
//  Created by Priscilla Jofani Oetomo on 10/19/17.
//  Copyright © 2017 grandevox. All rights reserved.
//

import Foundation
import CoreData


extension Media {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Media> {
        return NSFetchRequest<Media>(entityName: "Media")
    }

    @NSManaged public var mediaType: NSObject?
    @NSManaged public var name: NSObject?

}

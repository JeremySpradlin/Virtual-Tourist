//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Jeremy Spradlin on 2/4/18.
//  Copyright © 2018 Jeremy Spradlin. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?

}

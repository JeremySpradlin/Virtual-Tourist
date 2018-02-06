//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Jeremy Spradlin on 2/4/18.
//  Copyright © 2018 Jeremy Spradlin. All rights reserved.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photos: Photo?

}

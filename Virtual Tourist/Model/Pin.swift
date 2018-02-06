//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Jeremy Spradlin on 2/4/18.
//  Copyright © 2018 Jeremy Spradlin. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Pin)
public class Pin: NSManagedObject {

    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        
        if let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
            
            self.init(entity: entity, insertInto: context)
            self.latitude = latitude
            self.longitude = longitude
            
        } else {
            print("Entity Name Not Found")
            fatalError("Entity Name Not Found")
        }
        
    }
    
}

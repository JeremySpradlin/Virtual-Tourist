//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Jeremy Spradlin on 2/4/18.
//  Copyright © 2018 Jeremy Spradlin. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    
    convenience init(url: String, image: NSData?, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            
            self.init(entity: ent, insertInto: context)
            self.url = url
            self.image = image
            
        } else {
            print("Entity name not found")
            fatalError("Entity name not found")
        }
    }
}

//
//  ImageHolder+CoreDataProperties.swift
//  ValidationOfCoreDataImplementation
//
//  Created by 吉川創麻 on 2023/01/23.
//
//

import Foundation
import CoreData


extension ImageHolder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageHolder> {
        return NSFetchRequest<ImageHolder>(entityName: "ImageHolder")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var timestamp: Date?
    
    @NSManaged public var toItem: Item?

}

extension ImageHolder : Identifiable {

}

//
//  Item+CoreDataProperties.swift
//  ValidationOfCoreDataImplementation
//
//  Created by 吉川創麻 on 2023/01/23.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var timestamp: Date?
    
    @NSManaged public var toImageHolder: NSSet?

}

// MARK: Generated accessors for toImageHolder
extension Item {

    @objc(addToImageHolderObject:)
    @NSManaged public func addToToImageHolder(_ value: ImageHolder)

    @objc(removeToImageHolderObject:)
    @NSManaged public func removeFromToImageHolder(_ value: ImageHolder)

    @objc(addToImageHolder:)
    @NSManaged public func addToToImageHolder(_ values: NSSet)

    @objc(removeToImageHolder:)
    @NSManaged public func removeFromToImageHolder(_ values: NSSet)

}

extension Item : Identifiable {

}

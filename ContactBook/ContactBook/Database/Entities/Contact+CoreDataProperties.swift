//
//  Contact+CoreDataProperties.swift
//  ContactBook
//
//  Created by Tamta Topuria on 1/7/21.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var surname: String?

}

extension Contact : Identifiable {

}

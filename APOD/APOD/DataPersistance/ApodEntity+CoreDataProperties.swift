//
//  ApodEntity+CoreDataProperties.swift
//  APOD
//
//  Created by Amarnath Gopireddy on 4/14/21.
//
//

import Foundation
import CoreData


extension ApodEntity {

    @nonobjc public class func dataFetchRequest() -> NSFetchRequest<ApodEntity> {
        return NSFetchRequest<ApodEntity>(entityName: "ApodEntity")
    }

    @NSManaged public var image: Data?
    @NSManaged public var title: String?
    @NSManaged public var explanation: String?
    @NSManaged public var date: String?

}

extension ApodEntity : Identifiable {

}

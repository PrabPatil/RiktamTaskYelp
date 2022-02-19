//
//  RestaurantDetails+CoreDataProperties.swift
//  RiktamTaskYelp
//
//  Created by Prabhu Patil on 19/02/22.
//
//

import Foundation
import CoreData


extension RestaurantDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestaurantDetails> {
        return NSFetchRequest<RestaurantDetails>(entityName: "RestaurantDetails")
    }

    @NSManaged public var name: String?
    @NSManaged public var rating: Float
    @NSManaged public var id: String?
    @NSManaged public var price: String?
    @NSManaged public var is_closed: Bool
    @NSManaged public var distance: String?
    @NSManaged public var address: String?
    @NSManaged public var image_url: String?
    @NSManaged public var display_phone: String?

}

extension RestaurantDetails : Identifiable {

}

//
//  RestaurantsModelClass.swift
//  RiktamTaskYelp
//
//  Created by Prabhu Patil on 18/02/22.
//

struct Venue : Codable {
    var name                    : String?
    var id                      : String?
    var rating                  : Float?
    var price                   : String?
    var is_closed               : Bool?
    var distance                : Double?
    var address                 : String?
    var image_url               : String?
    var display_phone           : String?
}

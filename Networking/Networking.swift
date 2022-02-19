//
//  Networking.swift
//  RiktamTaskYelp
//
//  Created by Prabhu Patil on 18/02/22.
//

import Foundation
import CoreData
import UIKit

class NetworkManager {
    
    func fetchData(latitude: Double,
                        longitude: Double,
                        category: String,
                        limit: Int,
                        sortBy: String,
                        locale: String,
                        completionHandler: @escaping ([Venue]?, Error?) -> Void) {

        let apikey = "pVsDVsr01tInNWBJAzOVdpHXLziseRLVKuGw-FejC9RriegZt16nCOOg2_LJgw8fpaIarBcHbLKb80w4PGfr9imQTqI_mvLDWSWtqYlaIOquvzEt4Uxh5sq_Hfo0YXYx"

        /// create URL
        let baseURL = "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&categories=\(category)&limit=\(limit)&sort_by=\(sortBy)&locale=\(locale)"

        let url = URL(string: baseURL)

        /// Creating request
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        /// Initialize session and task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            do {

                /// Read data as JSON
                let json = try JSONSerialization.jsonObject(with: data!, options: [])

                /// Main dictionary
                guard let resp = json as? NSDictionary else { return }

                /// Businesses
                guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else { return }

                var venuesList: [Venue] = []

                /// Accessing each business
                for business in businesses {
                    var venue = Venue()
                    venue.name = business.value(forKey: "name") as? String
                    venue.id = business.value(forKey: "id") as? String
                    venue.rating = business.value(forKey: "rating") as? Float
                    venue.price = business.value(forKey: "price") as? String
                    venue.image_url = business.value(forKey: "image_url") as? String
                    venue.is_closed = business.value(forKey: "is_closed") as? Bool
                    venue.distance = business.value(forKey: "distance") as? Double
                    venue.display_phone = business.value(forKey: "display_phone")  as? String
                    let address = business.value(forKeyPath: "location.display_address") as? [String]
                    venue.address = address?.joined(separator: "\n")

                    venuesList.append(venue)
                }

                completionHandler(venuesList, nil)

            } catch {
                print("Caught error")
                completionHandler(nil, error)
            }
            }.resume()
    }

    func fetchDataOnSearchQuery(searchQuery:String,
                                completionHandler: @escaping ([Venue]?, Error?) -> Void) {
        let apikey = "pVsDVsr01tInNWBJAzOVdpHXLziseRLVKuGw-FejC9RriegZt16nCOOg2_LJgw8fpaIarBcHbLKb80w4PGfr9imQTqI_mvLDWSWtqYlaIOquvzEt4Uxh5sq_Hfo0YXYx"

        // create URL
        let baseURL = "https://api.yelp.com/v3/businesses/search?location=\(searchQuery)&radius=25"

        let urlNew = URL(string: baseURL)

        // Creating request
        var request = URLRequest(url: urlNew!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        // Initialize session and task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            do {

                // Read data as JSON
                let json = try JSONSerialization.jsonObject(with: data!, options: [])

                // Main dictionary
                guard let resp = json as? NSDictionary else { return }

                // Businesses
                guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else { return }

                var venuesList: [Venue] = []

                // Accessing each business
                for business in businesses {
                    var venue = Venue()
                    venue.name = business.value(forKey: "name") as? String
                    venue.id = business.value(forKey: "id") as? String
                    venue.rating = business.value(forKey: "rating") as? Float
                    venue.price = business.value(forKey: "price") as? String
                    venue.image_url = business.value(forKey: "image_url") as? String
                    venue.is_closed = business.value(forKey: "is_closed") as? Bool
                    venue.distance = business.value(forKey: "distance") as? Double
                    venue.display_phone = business.value(forKey: "display_phone")  as? String
                    let address = business.value(forKeyPath: "location.display_address") as? [String]
                    venue.address = address?.joined(separator: "\n")

                    venuesList.append(venue)
                    
                    DispatchQueue.main.async {
                        let appDel = (UIApplication.shared.delegate) as! AppDelegate
                        appDel.coreDataObject.saveData(displayName: venue.name, location: venue.address, ratings: venue.rating, price: venue.price, phoneNumber: venue.display_phone, restaurantImage: venue.image_url)
                    }
            }

                completionHandler(venuesList, nil)

            } catch {
                print("Caught error")
                completionHandler(nil, error)
            }
            }.resume()
    }
}

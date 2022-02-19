//
//  DataPersistentManager.swift
//  RiktamTaskYelp
//
//  Created by Prabhu Patil on 19/02/22.
//

import Foundation
import UIKit
import CoreData

class DataPersistentManager {
    
    func saveData(displayName: String?, location: String?,ratings: Float?,price: String?,phoneNumber: String?,restaurantImage: String?) {
        
        let appDel = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let restaurantObject = NSEntityDescription.insertNewObject(forEntityName: "RestaurantDetails", into: context) as! RestaurantDetails
        restaurantObject.name = displayName
        restaurantObject.address = location
        restaurantObject.rating = ratings ?? 0
        restaurantObject.price = price
        restaurantObject.display_phone = phoneNumber
        restaurantObject.image_url = restaurantImage
        
        do {
            try context.save()
            print("Data saved!!!")
        }
        catch {
            print("Error Occured during saving data!!!")
        }
    }
    
    func fetchData() -> [RestaurantDetails] {
        var recentData = [RestaurantDetails]()
        let appDel = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        do {
            recentData = try context.fetch(RestaurantDetails.fetchRequest())
        }
        catch {
            print("Error while feteching data!!!!")
        }
        return recentData
    }
}

//
//  Model.swift
//  AddressFinder
//
//  Created by Priscilla Jofani Oetomo on 10/20/17.
//  Copyright © 2017 grandevox. All rights reserved.
//

import CoreData
import UIKit

class Model {
    static let sharedInstance = Model()
    
    private init() {
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    // Get a reference to your App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Hold a reference to the managed context
    let managedContext: NSManagedObjectContext
    
    // Create a collection of objects to store in the database
    var mediaDB = [Media]()
    
    func getMedia (_ indexPath: IndexPath) -> Media {
        return mediaDB[indexPath.row]
    }
    
    func updateDatabase() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deleteMediaHistory (_ indexPath: IndexPath) {
        let media = mediaDB[indexPath.row]
        mediaDB.remove(at: indexPath.item)
        managedContext.delete(media)
        updateDatabase()
    }
    
    func getMediaHistory() {
        do {
            let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Media")
            let results = try managedContext.fetch(fetchRequest)
            mediaDB = results as! [Media]
        } catch let error as NSError {
            print ("Could not fetch \(error). \(error.userInfo)")
        }
    }
    
    func saveToHistory(media_Type: NSObject, media_Name: NSObject) {
        let entity = NSEntityDescription.entity(forEntityName: "Media", in: managedContext)!
        let media = Media(entity: entity, insertInto: managedContext)
        
        media.setValue(media_Type, forKey: "mediaType")
        media.setValue(media_Name, forKey: "name")
        mediaDB.append(media)
        
        updateDatabase()
    }
    
    func deleteAllHistory() {
        let fetch = NSFetchRequest <NSFetchRequestResult>(entityName: "Media")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try managedContext.execute(request)
            //try managedContext.save()
        } catch let error as NSError {
            print ("Could not delete \(error). \(error.userInfo)")
        }
    }
}

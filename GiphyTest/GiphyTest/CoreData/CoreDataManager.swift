//
//  CoreDataManager.swift
//  GiphyTest
//
//  Created by Harish Chopra on 2017-12-07.
//  Copyright © 2017 Harish Chopra. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
   
    static let sharedInstance = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer! = {
        let persistentContainer = NSPersistentContainer(name: "GiphyTest")
        return persistentContainer
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    func saveContext (completion: CompletionHandlerDatabase) {
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
                completion(true)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            completion(false)
        }
    }
    
    func setup(completion: @escaping () -> Void) {
        loadPersistentStore {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func loadPersistentStore(completion: @escaping () -> Void) {
        self.persistentContainer.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            completion()
        }
    }
    
    func saveGiphyToDatabase(giphy:Giphy, completion: CompletionHandlerDatabase) {
        let favourites = Favourites(context: mainContext)
        favourites.id = giphy.id
        favourites.url = giphy.url
        saveContext(completion: completion)
    }
    
    func fetchGiphyFromDatabaseWithId(id:String)->(Favourites!) {
        let fetchRequest = NSFetchRequest<Favourites>(entityName: "Favourites")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            let fetchedObject = try mainContext.fetch(fetchRequest)
            if fetchedObject.count > 0 {
                return fetchedObject[0];
            }
        } catch  {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func deleteFavouriteFromDatabase(favourite:Favourites, completion: CompletionHandlerDatabase) {
        mainContext.delete(favourite)
        do {
            try mainContext.save()
            completion(true)
        } catch  {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func fetchAllFavouritesFromDatabase(completion: CompletionHandlerDatabaseWithFavourites) {

        let fetchRequest = NSFetchRequest<Favourites>(entityName: "Favourites")
        var arrfavouriteImages = [Favourites]()
        do {
            arrfavouriteImages = try mainContext.fetch(fetchRequest)
            completion(arrfavouriteImages)
        } catch  {
            print(error.localizedDescription)
            completion(nil)
        }
    }
}

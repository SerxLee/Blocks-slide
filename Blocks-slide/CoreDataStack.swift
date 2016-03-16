//
//  CoreDataStack.swift
//  Blocks-slide
//
//  Created by Serx on 3/16/16.
//  Copyright © 2016 serxlee. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    let modelName = "Mark"
    
    //The URL path of the file
    private lazy var applciationDocumentDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(
            NSSearchPathDirectory.DocumentDirectory,
            inDomains: NSSearchPathDomainMask.UserDomainMask)
        return urls[urls.count - 1] as NSURL
    }()
    
    //NSManagedObjectContext
    //Note: ConcurrencyType's specific parameters will set later，use the .MainQueueConcurrencyType for the moment.
    //built the Context has no function and meaning, until you set the Context'PersistentStoreCoordinator after.
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    
    //NSPersistentStoreCoordinator
    //Lazy load of the StoreCoordinator，StoreCoordinator is between in PersistentStore(s) and ObejctModel，so need a PersistentStore at least。
    private lazy var psc: NSPersistentStoreCoordinator = {

        //coordinator init，income the Model，Model is the Entity and all relationship.
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        //PersisitentStore's physical storage path
        let url = self.applciationDocumentDirectory.URLByAppendingPathComponent(self.modelName)
        do{
            //Set some Option：
            let options = [NSMigratePersistentStoresAutomaticallyOption : true]
            
            //addPersistentStoreWithType choose a type of Sqlite, use the Sqlite as the mainly storage type。
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL:url, options: options)
        } catch {
            print("Error adding persistnet store.")
        }
        return coordinator
    }()
    
    //NSManagedObjectModel
    //这里包含着MainBundle里面的momb文件里面的 `.xcdatamodeld` 文件，就是Xcode图形化设计Entity和Relationship的那个文件，使用它来创建ManagedObjectModel
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    func saveContent(){
        if context.hasChanges{
            do{
                try context.save()
            }catch let error as NSError{
                print("Error:\(error.localizedDescription)")
                abort()
            }
        }
    }
}

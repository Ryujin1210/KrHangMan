//
//  CoreDataManager.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 유원근 on 2023/01/10.
//

import UIKit
import CoreData

class CoreDataManager {
    static let share = CoreDataManager()
    
    // MARK: - CoreData
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserDataCRUD") // 여기는 파일명을 작성.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
  // MARK: - CoreData Saving support
    lazy var context = persistentContainer.viewContext
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error, \((nserror as NSError).userInfo)")
            }
        }
    }
    
    
    func fetchUser() -> [UserEntity] {
        var user = [UserEntity]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: UserEntity.description())
        
        do {
            user = try context.fetch(fetchRequest) as! [UserEntity]
            
        }
        catch {
            print("fetch error")
        }
        return user
    }
    
    
}

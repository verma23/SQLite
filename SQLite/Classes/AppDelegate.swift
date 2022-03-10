//
//  AppDelegate.swift
//  SQLite
//
//  Created by Shivanshu Verma on 2022-03-08.
//

import UIKit
import CoreData
import SQLite3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var databaseName : String? = "Mtdatabase.db"
    var databasePath : String?
    var people : [Data] = []
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDir = documentPaths[0]
        databasePath = documentDir.appending("/" + databaseName!)
        checkAndCreateDatabase()
        readDataFromDatabase()
        
        return true
    }
    
    func readDataFromDatabase()
    {
        people.removeAll()
        
        var db : OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK{
            print("Success \(self.databasePath!)")
            
            var queryState: OpaquePointer? = nil
            var queryStatementString : String = "select * from entries"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryState, nil) == SQLITE_OK
            {
                while sqlite3_step(queryState) == SQLITE_ROW {
                    
                    let id: Int = Int(sqlite3_column_int(queryState, 0))
                    let cname = sqlite3_column_text(queryState, 1)
                    let cemail = sqlite3_column_text(queryState, 2)
                    let cfood = sqlite3_column_text(queryState, 3)
                    
                    let name = String(cString: cname!)
                    let email = String(cString: cemail!)
                    let food = String(cString: cfood!)
                    
                    let data : Data = Data.init()
                    data.initWithData(theRow: id, theName: name, theEmail: email, theFood: food)
                    people.append(data)
                    print("Result")
                    print("\(id) | \(name) | \(email) | \(food)")
                    
                }
                sqlite3_finalize(queryState)
            }
            else
            {
                print("Select statement wrong")
            }
            sqlite3_close(db)
        }
        else
        {
            print("unable to open database")
        }
        
        
    }
    
    func insertIntoDatabase(person : Data) -> Bool{
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
        {
            
            var insertState : OpaquePointer? = nil
            var insetStateString : String = "insert into entries values(NULL, ?, ?, ?)"
            
            if sqlite3_prepare_v2( db,insetStateString, -1, &insertState, nil) == SQLITE_OK
            {
                let nameStr = person.name as! NSString
                let emailStr = person.email as! NSString
                let foodStr = person.food as! NSString
                
                sqlite3_bind_text(insertState, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertState, 2, emailStr.utf8String, -1, nil)
                sqlite3_bind_text(insertState, 3, foodStr.utf8String, -1, nil)
                
                if sqlite3_step(insertState) == SQLITE_DONE
                {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Succcessfull \(rowId)")
                }
                else
                {
                    print("fail")
                    returnCode = false
                }
                
                sqlite3_finalize(insertState)
                
            }
            else
            {
                print("insert failed")
                returnCode = false
            }
            sqlite3_close(db)
        }
        else
        {
            print("Fail")
            returnCode = false
        }
        return returnCode
    }
    
    func checkAndCreateDatabase(){
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
        
        if success{
            return
        }
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath! )
        return
        
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SQLite")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


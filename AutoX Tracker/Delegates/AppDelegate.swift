//
//  AppDelegate.swift
//  AutoX Tracker
//
//  Created by Samuel Armstrong on 12/28/19.
//  Copyright © 2019 Samuel Armstrong. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //removeAllUserDefaults();
        loadFromUserDefaults()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
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

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "AutoX_Tracker")
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

// MARK: GLOBAL FUNCTIONS

// MARK: saveToUserDefaults
func saveToUserDefaults(tracks: [TrackModel]) {
    var index: Int = 0
    while index < tracks.count {
        UserDefaults.standard.set(tracks[index].title, forKey: "title\(index)")
        UserDefaults.standard.set(tracks[index].dateCreated, forKey: "date\(index)")
        UserDefaults.standard.set(tracks[index].latArray, forKey: "lat\(index)")
        UserDefaults.standard.set(tracks[index].lonArray, forKey: "lon\(index)")
        index += 1
    }
    UserDefaults.standard.set(index, forKey: "count")
    print("Saved to UserDefaults")
}

// MARK: loadFromUserDefaults
func loadFromUserDefaults() {
    let count: Int = UserDefaults.standard.integer(forKey: "count")
    print(count)
    if count != 0 {
        var index: Int = 0
        while index < count {
            print("title\(index)")
            let title = UserDefaults.standard.string(forKey: "title\(index)") ?? "n/a"
            let date = UserDefaults.standard.string(forKey: "date\(index)") ?? "n/a"
            let latArray = UserDefaults.standard.array(forKey: "lat\(index)") as? [Double] ?? [Double]()
            let lonArray =  UserDefaults.standard.array(forKey: "lon\(index)") as? [Double] ?? [Double]()
            let currentTrack = TrackModel(title: title, date: date, lat: latArray, lon: lonArray)
            savedTracks.append(currentTrack)
            
            index += 1
        }
    }
}

// MARK: removeAllUserDefaults
func removeAllUserDefaults() {
    let count: Int = UserDefaults.standard.integer(forKey: "count")
    var index: Int = 0
    while index <= count {
        UserDefaults.standard.removeObject(forKey: "title\(index)")
        UserDefaults.standard.removeObject(forKey: "date\(index)")
        UserDefaults.standard.removeObject(forKey: "lat\(index)")
        UserDefaults.standard.removeObject(forKey: "lon\(index)")
        index += 1
    }
    UserDefaults.standard.set(0, forKey: "count")
    UserDefaults.standard.synchronize()
}

// MARK: removeUserDefaults at index
func removeUserDefaults(index: Int) {
    UserDefaults.standard.removeObject(forKey: "title\(index)")
    UserDefaults.standard.removeObject(forKey: "date\(index)")
    UserDefaults.standard.removeObject(forKey: "lat\(index)")
    UserDefaults.standard.removeObject(forKey: "lon\(index)")
    
    let count: Int = UserDefaults.standard.integer(forKey: "count")
    UserDefaults.standard.set(count - 1, forKey: "count")
    UserDefaults.standard.synchronize()
}



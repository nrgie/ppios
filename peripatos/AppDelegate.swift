//
//  AppDelegate.swift
//  peripatos
//
//  Created by Tibor Sulyok on 2018. 04. 09..
//  Copyright © 2018. Tibor Sulyok. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GMSPlacesClient.provideAPIKey("AIzaSyDbyOgOLbKcccfhvGq38JccaRjtgkp5XFY")
        GMSServices.provideAPIKey("AIzaSyDbyOgOLbKcccfhvGq38JccaRjtgkp5XFY")
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let s: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "main")
        let newNavVC = UINavigationController()
        
        newNavVC.setViewControllers([vc], animated: false)
        UIApplication.shared.delegate?.window??.rootViewController = newNavVC
        self.window?.rootViewController = newNavVC
        self.window?.makeKeyAndVisible()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "peripatos")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


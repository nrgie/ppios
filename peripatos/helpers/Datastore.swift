//
//  Datastore.swift
//  peripatos
//
//  Created by Tibor Sulyok on 2018. 04. 09..
//  Copyright © 2018. Tibor Sulyok. All rights reserved.
//

import Foundation
import ObjectMapper

class DataStore {
    
    static let shared: DataStore = {
        let instance = DataStore()
        return instance
    }()
    
    var tours : Tours?
    
    var currentTour: TourItem?
    
    private func persist(value: Any, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func readValue(for key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    public func syncUser() {
        /*
        if userData != nil {
            let json = userData?.toJSONString(prettyPrint: false)
            self.persist(value: json, key: Constants.DataKeys.AccessTokenKey)
            let url = URL(string: "http://api.saveme-app.com/user.php")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let postString = "user="+(json ?? "")
            request.httpBody = postString.data(using: .utf8)
            
            print("posted as USER json = \(postString)")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(error)")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString!)")
            }
            task.resume()
        }
        */
    }
    
    public func fillUser() {
        if(getTours() != nil) {
            let tours = Tours(JSONString: getTours()!)
            self.tours = tours
        } else {
            self.tours = Tours()
        }
    }
    
    public func getLang() -> String? {
        return self.readValue(for: "APPLANG") as? String
    }
    
    public func setLang(token: String) {
        self.persist(value: "en", key: "APPLANG")
    }
    
    public func getPIN() -> String? {
        return self.readValue(for: "PIN") as? String
    }
    
    public func setPIN(pin: String) {
        self.persist(value: pin, key: "PIN")
    }
    
    public func getOnboard() -> Bool? {
        return self.readValue(for: "onboard") as? Bool
    }
    
    public func setOnboard(val: Bool) {
        self.persist(value: val, key: "onboard")
    }
    
    public func getTours() -> String? {
        return self.readValue(for: Constants.DataKeys.AccessTokenKey) as? String
    }
    
    public func setTours(data: String) {
        self.persist(value: data, key: Constants.DataKeys.AccessTokenKey)
    }
    
    public func getFBToken() -> String? {
        return self.readValue(for: "fbtoken") as? String
    }
    
    public func setFBToken(token: String) {
        self.persist(value: token, key: "fbtoken")
    }
    
    public func getUserId() -> String? {
        return self.readValue(for: Constants.DataKeys.UserIdKey) as? String
    }
    
    public func setUserId(userId: String) {
        self.persist(value: userId, key: Constants.DataKeys.UserIdKey)
    }
    
    public func clearData(){
        let clearableKeys: [String] = [Constants.DataKeys.AccessTokenKey, Constants.DataKeys.UserIdKey, "fbtoken"]
        clearableKeys.forEach { (key: String) in
            UserDefaults.standard.removeObject(forKey: key)
        }
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
        self.tours = Tours()
    }
    
}


struct Constants {
    
    struct EndPoints {
        
        static let Api: String = "https://peripatos-app.com"
        static let WPApi: String = ""
        static let OAuthApi: String = ""
        static let clientId: String = ""
        static let clientSecret: String = ""
        
    }
    
    struct DataKeys {
        static let AccessTokenKey: String = "ACCES_TOKEN"
        static let UserIdKey: String = "USER_ID"
    }
    
    struct Cells {
        static let MenuItemCell: String = "MenuItemCell"
    }
    
    struct Notifications {
        
        static let fbtoken = NSNotification.Name(rawValue: "fbtoken")
        
        static let SaveSpoken = NSNotification.Name(rawValue: "SaveSpoken")
        static let SaveAllergies = NSNotification.Name(rawValue: "SaveAllergies")
        
        static let setActive = NSNotification.Name(rawValue: "setActive")
        
        static let ShowCats = NSNotification.Name(rawValue: "ShowCats")
        static let ShowList = NSNotification.Name(rawValue: "ShowList")
        static let ReloadList = NSNotification.Name(rawValue: "ReloadList")
        
        
        static let ToggleMenuNotification = NSNotification.Name(rawValue: "ToggleMenuNotification")
        static let ShowInfoNotification = NSNotification.Name(rawValue: "ShowInfoNotification")
        static let GoBackNotification = NSNotification.Name(rawValue: "GoBackNotification")
        static let AnswerSelectedNotification = NSNotification.Name(rawValue: "AnswerSelectedNotification")
        static let UserLoggedInNotification = NSNotification.Name(rawValue: "UserLoggedInNotification")
        static let UserRegistrationNotification = NSNotification.Name(rawValue: "UserRegistrationNotification")
        static let UserLoggedOutNotification = NSNotification.Name(rawValue: "UserLoggedOutNotification")
        static let ProgramUpdatedNotification = NSNotification.Name(rawValue: "ProgramUpdatedNotification")
        static let ShowLoginNotification = NSNotification.Name(rawValue: "ShowLoginNotification")
        static let ShowRegistrationNotification = NSNotification.Name(rawValue: "ShowRegistrationNotification")
        static let ShowDailyProgramNotification = NSNotification.Name(rawValue: "ShowDailyProgramNotification")
    }
}

extension NSObject {
    func safeValue(forKey key: String) -> Any? {
        let copy = Mirror(reflecting: self)
        for child in copy.children.makeIterator() {
            if let label = child.label, label == key {
                return child.value
            }
        }
        return nil
    }
}

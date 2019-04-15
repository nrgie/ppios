//
//  RouteItem.swift
//  peripatos
//
//  Created by Tibor Sulyok on 2018. 04. 09..
//  Copyright © 2018. Tibor Sulyok. All rights reserved.
//

import Foundation
import ObjectMapper
import GoogleMaps
/*
 public String ID = "";
 public String parent = "";
 public String audio = "";
 public String content = "";
 public String excerpt = "";
 public String image = "";
 public String latitude = "";
 public String longitude = "";
 public String location = "";
 public String title = "";
 public String quiz = "";
 public String order = "";
 */

class RouteItem : Mappable {
    
    var ID: Int!
    var parent: Int!
    var audio: String!
    var content: String!
    var excerpt: String!
    var image: String!
    var latitude: String!
    var longitude: String!
    var location: String!
    var title: String!
    var quiz: String!
    var order: String!
    var radius: String!
    var marker: GMSMarker!

    required init?(map: Map) {
        //super.init(map: map)
    }
    
    func safe(key: String) -> Any? {
        let copy = Mirror(reflecting: self)
        for child in copy.children.makeIterator() {
            if let label = child.label, label == key {
                return child.value
            }
        }
        return nil
    }
    
    func mapping(map: Map) {
        //super.mapping(map: map)
        ID <- map["ID"]
        parent <- map["parent"]
        image <- map["image"]
        audio <- map["audio"]
        content <- map["content"]
        excerpt <- map["excerpt"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        location <- map["location"]
        title <- map["title"]
        quiz <- map["quiz"]
        radius <- map["radius"]
        order <- map["order"]
    }
    
    init() {
        //super.init()!
    }
}

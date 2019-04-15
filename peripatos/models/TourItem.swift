//
//  Tours.swift
//  peripatos
//
//  Created by Tibor Sulyok on 2018. 04. 09..
//  Copyright © 2018. Tibor Sulyok. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 public String id;
 public String description = "";
 public String slug = "";
 public String imageurl = "";
 public String terms = "";
 public String course = "";
 public String audio = "";
 public String content = "";
 public String excerpt = "";
 public String image = "";
 public String lang = "";
 public String latitude = "";
 public String longitude = "";
 public String location = "";
 public String title = "";
 public double dist = 0;
 public String distance = "";
 public boolean showempty = false;
 public ArrayList<RouteItem> routes = new ArrayList<RouteItem>();
 public Bitmap bitmap;
 
 public void setRoutes(List<RouteItem> arr) {
     ArrayList<RouteItem> list = new ArrayList<RouteItem>();
     for(RouteItem i: arr) {
        if(i.parent.equals(this.id)) {
        list.add(i);
     }
     Collections.sort(list);
     this.routes = list;
 }
 
 */

class TourItem : Mappable {
    
    var id: Int!
    var description: String!
    var slug: String!
    var imageurl: String!
    var terms: String!
    var course: String!
    var audio: String!
    var content: String!
    var excerpt: String!
    var image: String!
    var lang: String!
    var latitude: Double!
    var longitude: Double!
    var location: String!
    var title: String!
    var dist: Int!
    var radius: Int!
    var distance: String!
    var showempty: Bool!
    
    var routes = Array<RouteItem>()
    
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
        id <- map["ID"]
        description <- map["description"]
        slug <- map["slug"]
        imageurl <- map["imageurl"]
        image <- map["image"]
        terms <- map["terms"]
        course <- map["course"]
        audio <- map["audio"]
        content <- map["content"]
        excerpt <- map["excerpt"]
        lang <- map["lang"]
        latitude <- map["latitude"]
        location <- map["location"]
        title <- map["title"]
        distance <- map["distance"]
    }
    
    init() {
        //super.init()!
    }
}

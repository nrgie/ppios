//
//  CourseItem.swift
//  peripatos
//
//  Created by Tibor Sulyok on 2018. 04. 09..
//  Copyright © 2018. Tibor Sulyok. All rights reserved.
//

import Foundation
import ObjectMapper
/*
public String id = "";
public String title = "";
public String slug = "";
public String image = "";
public String description = "";
*/
class CourseItem : Mappable {
    
    var id: Int!
    var title: String!
    var slug: String!
    var image: String!
    var description: String!
    
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
        id <- map["id"]
        title <- map["title"]
        slug <- map["slug"]
        image <- map["image"]
        description <- map["description"]
    }
    
    init() {
        //super.init()!
    }
}

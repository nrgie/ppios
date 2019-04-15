//
//  Tours.swift
//  peripatos
//
//  Created by Tibor Sulyok on 2018. 04. 09..
//  Copyright © 2018. Tibor Sulyok. All rights reserved.
//

import Foundation
import ObjectMapper

class Tours : Mappable {
    
    var tours = Array<TourItem>()
    var tourpoints = Array<RouteItem>()
    var categories = Array<CategoryItem>()
    var courses = Array<CourseItem>()
    
    required init?(map: Map) {
        //super.init(map: map)
    }

    func mapping(map: Map) {
        //super.mapping(map: map)
        tours <- map["tours"]
        tourpoints <- map["tourpoints"]
        categories  <- map["categories"]
        courses  <- map["courses"]
    }
    
    func parse() {
        
        
        
    }
    
    init() {}
}

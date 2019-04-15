//
//  SettingsListAdapter.swift
//  saveme
//
//  Created by Tibor Sulyok on 2018. 03. 19..
//  Copyright © 2018. Blueobject. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class RouteListAdapter: Adapter {

    var items: [RouteItem]!
    var count: Int {
        return items.count
    }
    
    func item(forPosition position: Int) -> Any {
        return items[position]
    }
    
    func view(forPosition position: Int, convertView: UIView?) -> UIView {
        let item : RouteItem = items[position]
        let result : RouteListItem! = viewType(forPosition: position).init(frame: CGRect.zero) as? RouteListItem
        result.fill(with: items[position], with: position)
        UITapGestureRecognizer(addToView: result) {}
        result.isUserInteractionEnabled = true
        return result
    }
    
    func viewType(forPosition position: Int) -> UIView.Type {
        return RouteListItem.self
    }
}

//
//  SettingAvatarView.swift
//  saveme
//
//  Created by Tibor Sulyok on 2018. 03. 19..
//  Copyright © 2018. Blueobject. All rights reserved.
//

import Foundation
import UIKit

class RouteListItem: UIView {
    
    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let contentView = Bundle.main.loadNibNamed("RouteListItem", owner: self, options: nil)?.last as! UIView
        contentView.frame = bounds
        //contentView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        addSubview(contentView)
    }
    
    func fill(with item: RouteItem, with count:Int) {
        
        print("LISTITEM")
        print(count)
        print(item.title)
        key.text = item.title
        value.text = String(count+1) + "."
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

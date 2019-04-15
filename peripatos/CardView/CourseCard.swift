//
//  CardViewController.swift
//  CardViewListDemo
//
//  Created by Saiful I. Wicaksana on 11/13/17.
//  Copyright © 2017 icaksama. All rights reserved.
//

import UIKit
import SDWebImage

class CourseCard: UIViewController {

    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var bg: UIImageView!
    
    var item: CourseItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if item != nil {
            setup()
        }
    }

    func fill(item: CourseItem) {
        self.item = item
    }
    
    func setup() {
        if item?.image != nil {
            bg.sd_setImage(with: URL(string: (item?.image)!))
        }
        
        lblSummary.text = item?.title
        bg.isUserInteractionEnabled = true
        UITapGestureRecognizer(addToView: bg) {
            var filter = FilterData()
            filter.institute = "\(self.item?.id ?? 0)"
            
            let pdata:[String: FilterData] = ["filter": filter]
            NotificationCenter.default.post(name: Constants.Notifications.ReloadList, object: nil, userInfo:pdata)
            NotificationCenter.default.post(name: Constants.Notifications.ShowList, object: nil, userInfo:pdata)
        }
        
    }

}

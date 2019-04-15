//
//  CardViewController.swift
//  CardViewListDemo
//
//  Created by Saiful I. Wicaksana on 11/13/17.
//  Copyright © 2018 Tibi. All rights reserved.
//

import UIKit
import SDWebImage

class RouteCard: UIViewController {

    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var bg: UIImageView!
    
    var item: RouteItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if item != nil {
            setup()
        }
    }

    func fill(item: RouteItem) {
        self.item = item
    }
    
    func setup() {
        if item?.image != nil {
            bg.sd_setImage(with: URL(string: (item?.image)!))
        }
        lblSummary.text = item?.title
        bg.isUserInteractionEnabled = true
        UITapGestureRecognizer(addToView: bg) {
            
            let pdata:[String: RouteItem] = ["item": self.item!]
            NotificationCenter.default.post(name: Constants.Notifications.setActive, object: nil, userInfo:pdata)
            
            //DataStore.shared.currentTour = self.item
            // send notify
            /*
            let s: UIStoryboard = UIStoryboard(name: "Detail", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "detail")
            let newNavVC = UINavigationController()
            newNavVC.setViewControllers([vc], animated: false)
            UIApplication.shared.delegate?.window??.rootViewController = newNavVC
            */
        }
    }

}

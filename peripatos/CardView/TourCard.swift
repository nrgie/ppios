//
//  CardViewController.swift
//  CardViewListDemo
//
//  Created by Saiful I. Wicaksana on 11/13/17.
//  Copyright © 2017 icaksama. All rights reserved.
//

import UIKit
import SDWebImage

class TourCard: UIViewController {

    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var bg: UIImageView!
    
    var item: TourItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if item != nil {
            setup()
        }
    }

    func fill(item: TourItem) {
        self.item = item
    }
    
    func setup() {
        if item?.image != nil {
            if item?.image != "" {
                bg.sd_setImage(with: URL(string: (item?.image)!))
            }
        }
        lblSummary.text = item?.title
        bg.isUserInteractionEnabled = true
        UITapGestureRecognizer(addToView: bg) {
            DataStore.shared.currentTour = self.item
            
            let s: UIStoryboard = UIStoryboard(name: "Detail", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "detail")
            //UIApplication.shared.delegate?.window??.rootViewController?.addChildViewController(vc)
            //let navVC = UIApplication.shared.delegate?.window??.rootViewController?.navigationController
            let navVC = UINavigationController()
            navVC.setViewControllers([vc], animated: false)
            UIApplication.shared.delegate?.window??.rootViewController = navVC
            
        }
    }

}

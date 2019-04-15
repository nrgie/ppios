//
//  MainListController.swift
//  peripatos
//
//  Created by Tibor Sulyok on 2018. 05. 24..
//  Copyright © 2018. Tibor Sulyok. All rights reserved.
//

import Foundation
import UIKit
class MainListController: UIViewController, CardViewListDelegete {
    
    @IBAction func backto(_ sender: Any) {
        NotificationCenter.default.post(name: Constants.Notifications.ShowCats, object: nil)
    }
    
    @IBOutlet weak var list: UIView!
    var itemList: CardViewList!
    
    var catControllers = [UIViewController]()
    var data: Tours?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.itemList = CardViewList()
        self.itemList.delegete = self
        self.itemList.animationScroll = .transformToTop
        self.itemList.isClickable = true
        self.itemList.listType = .vertical
        self.itemList.clickAnimation = .bounce
        self.itemList.grid = 1
        self.itemList.shadowOpacity = 0
        self.itemList.cornerRadius = 2
        
        NotificationCenter.default.addObserver(self, selector: #selector(setFilter), name: Constants.Notifications.ShowList, object: nil)
        
    }
    
    func setFilter(notification: Notification) {
        
        
        for view in self.list.subviews {
            view.removeFromSuperview()
        }
        
        catControllers.removeAll()
        
        self.itemList = CardViewList()
        self.itemList.delegete = self
        self.itemList.animationScroll = .none
        self.itemList.isClickable = true
        self.itemList.listType = .vertical
        self.itemList.clickAnimation = .bounce
        self.itemList.grid = 1
        self.itemList.shadowOpacity = 0
        self.itemList.cornerRadius = 2
        
        print("Notification Received :", notification)
        print(notification.userInfo ?? "")
        
        if let dict = notification.userInfo as NSDictionary? {
            if let filter = dict["filter"] as? FilterData {
                
                print("TEXT", filter.text)
                print("CAT", filter.cat)
                print("INS", filter.institute)
                
                if filter.text != nil  {
                    if filter.text == ""  {
                        for tour in (self.data?.tours)! {
                            let card = TourCard(nibName: "TourCard", bundle: nil)
                            card.fill(item: tour)
                            catControllers.append(card)
                        }
                    } else {
                        for tour in (self.data?.tours)! {
                            if tour.title.lowercased().range(of:filter.text!.lowercased()) != nil {
                                print("contains", tour.title, filter.text)
                                let card = TourCard(nibName: "TourCard", bundle: nil)
                                card.fill(item: tour)
                                catControllers.append(card)
                            }
                        }
                    }
                } else if filter.cat != nil {
                    for tour in (self.data?.tours)! {
                        let terms = tour.terms ?? "ez null"
                        print("EZFUT CAT", filter.cat)
                        if terms.range(of:filter.cat ?? "ez szar") != nil {
                            let card = TourCard(nibName: "TourCard", bundle: nil)
                            card.fill(item: tour)
                            catControllers.append(card)
                        }
                    }
                } else if filter.institute != nil {
                    for tour in (self.data?.tours)! {
                        let course = tour.course ?? "eznull"
                        print("COURSE", course)
                        print("FILTER", filter.institute  ?? "ez szar")
                        if course.range(of:filter.institute ?? "ez szar") != nil {
                            let card = TourCard(nibName: "TourCard", bundle: nil)
                            card.fill(item: tour)
                            catControllers.append(card)
                        }
                    }
                }
            }
            
        } else {
            for tour in (self.data?.tours)! {
                let card = TourCard(nibName: "TourCard", bundle: nil)
                card.fill(item: tour)
                catControllers.append(card)
            }
        }
        
        self.itemList.generateCardViewList(containerView: self.list, viewControllers: catControllers, listType: .vertical, identifier: "CardWithUIViewController")
        
    }
    
    
    
    open func setData(data: Tours) {
        
        self.data = data
        
        /*
        for tour in data.tours {
            let card = TourCard(nibName: "TourCard", bundle: nil)
            card.fill(item: tour)
            catControllers.append(card)
        }
        
        self.itemList.generateCardViewList(containerView: self.list, viewControllers: catControllers, listType: .vertical, identifier: "CardWithUIViewController")
        */
    }
    
}

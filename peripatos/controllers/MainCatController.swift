//
//  MainCatController.swift
//  peripatos
//
//  Created by Tibor Sulyok on 2018. 05. 24..
//  Copyright © 2018. Tibor Sulyok. All rights reserved.
//

import Foundation
import UIKit
class MainCatController: UIViewController, CardViewListDelegete {
    
    @IBOutlet weak var card1: UIView!
    @IBOutlet weak var card2: UIView!
    
    @IBAction func findnearby(_ sender: Any) {
        var filter = FilterData()
        filter.nearby = "1"
        NotificationCenter.default.post(name: Constants.Notifications.ShowList, object: filter)
    }
    
    var catControllers = [UIViewController]()
    var courseControllers = [UIViewController]()
    
    var catList: CardViewList!
    var courseList: CardViewList!
    
    var data: Tours?
    
    open func setData(data: Tours) {
        
        self.data = data
        
        for cat in data.categories {
            let card = CatCard(nibName: "CatCard", bundle: nil)
            card.fill(item: cat)
            catControllers.append(card)
        }
        
        self.catList.generateCardViewList(containerView: self.card1, viewControllers: catControllers, listType: .horizontal, identifier: "CardWithUIViewController")
        
        for cat in data.courses {
            let card = CourseCard(nibName: "CourseCard", bundle: nil)
            card.fill(item: cat)
            courseControllers.append(card)
        }
        
        self.courseList.generateCardViewList(containerView: self.card2, viewControllers: courseControllers, listType: .horizontal, identifier: "CardWithUIViewController")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.catList = CardViewList()
        self.catList.delegete = self
        self.courseList = CardViewList()
        self.courseList.delegete = self
        
        self.catList.animationScroll = .transformToBottom
        self.catList.isClickable = true
        self.catList.clickAnimation = .bounce
        self.catList.grid = 1
        self.catList.shadowOpacity = 0
        self.catList.cornerRadius = 2
        
        self.courseList.animationScroll = .transformToBottom
        self.courseList.isClickable = true
        self.courseList.clickAnimation = .bounce
        self.courseList.grid = 1
        self.courseList.shadowOpacity = 0
        self.courseList.cornerRadius = 2
        
    }
    
}

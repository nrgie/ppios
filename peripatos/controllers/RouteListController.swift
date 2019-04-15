//
//  MenuViewController.swift
//  GuillotineMenuExample
//
//  Created by Maksym Lazebnyi on 10/8/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit

class RouteListController: UIViewController, GuillotineMenu, CardViewListDelegete {
    
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    
    var catControllers = [UIViewController]()
    var list: CardViewList!
    
    
    @IBOutlet weak var listview: UIView!
    
    @IBAction func close(_ sender: Any) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "ic_menu"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = "Menu"
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()
        
        list = CardViewList()
        list.delegete = self
        list.animationScroll = .transformToRight
        list.isClickable = true
        list.listType = .vertical
        list.clickAnimation = .bounce
        list.grid = 1
        list.shadowOpacity = 0
        list.cornerRadius = 2
        
        for route in (DataStore.shared.currentTour?.routes)! {
            let card = RouteCard(nibName: "RouteCard", bundle: nil)
            card.fill(item: route)
            catControllers.append(card)
        }
        
        list.generateCardViewList(containerView: self.listview, viewControllers: catControllers, listType: .vertical, identifier: "CardWithUIViewController")
        
        NotificationCenter.default.addObserver(self, selector: #selector(setActive), name: Constants.Notifications.setActive, object: nil)
        
    }
    
    func setActive(notification: Notification) {
        if presentingViewController != nil {
            presentingViewController!.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Menu: viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Menu: viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Menu: viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Menu: viewDidDisappear")
    }
    
    func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeMenu(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
}


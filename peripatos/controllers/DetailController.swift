//
//  ViewController.swift
//  peripatos
//
//  Created by Tibor Sulyok on 2018. 04. 09..
//  Copyright © 2018. Tibor Sulyok. All rights reserved.
//

import UIKit
import WebKit
import SDWebImage

class DetailController: UIViewController, UIViewControllerTransitioningDelegate {

    //fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    @IBAction func starttour(_ sender: Any) {
        
        let s: UIStoryboard = UIStoryboard(name: "Guide", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "guide")
        let newNavVC = UINavigationController()
        newNavVC.setViewControllers([vc], animated: false)
        UIApplication.shared.delegate?.window??.rootViewController = newNavVC
        
    }
    
    @IBOutlet weak var startbtn: UIButton!
    
    @IBOutlet weak var BarBtn: UIBarButtonItem!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var tourtitle: UILabel!
    @IBOutlet weak var tourcontent: WKWebView!
    
    @IBOutlet weak var bg: UIImageView!
    @IBAction func back(_ sender: Any) {
        
        let s: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "main")
        let newNavVC = UINavigationController()
        newNavVC.setViewControllers([vc], animated: false)
        //UIApplication.shared.delegate?.window??.rootViewController = newNavVC
        present(newNavVC, animated: true, completion: nil)
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
   
        //NotificationCenter.default.addObserver(self, selector: #selector(fadeToList), name: Constants.Notifications.ShowList, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(fadeToCat), name: Constants.Notifications.ShowCats, object: nil)
        
        let navBar = self.navigationController?.navigationBar
        navBar?.topItem?.title = "Tour Detail"
        navBar?.barTintColor = UIColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 1
        )
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        let width = BarBtn.customView?.widthAnchor.constraint(equalToConstant: 32)
        width?.isActive = true
        let height = BarBtn.customView?.heightAnchor.constraint(equalToConstant: 32)
        height?.isActive = true
        
        tourtitle.addTopBorderWithColor(color: UIColor.gray, width:1)
        tourtitle.addBottomBorderWithColor(color: UIColor.gray, width:1)
        
        
        if let item = DataStore.shared.currentTour {
            if item.image != nil {
                bg.sd_setImage(with: URL(string: (item.image)!))
            }
            self.tourtitle.text = item.title
            let rootURL: URL? = URL(string: Constants.EndPoints.Api)
            
            var html = ""
            html += "<html>"
            html += "<head>"
            html += "<meta name=\"viewport\" content=\"initial-scale=1.0\" />"
            html += "<meta name=\"charset\" content=\"UTF-8\" />"
            html += "<style type='text/css'>"
            html += ".main_text {"
            html += "   display: block;"
            html += "   font-family:'Helvetica';"
            html += "   text-decoration:none;"
            html += "   font-size:15px;"
            html += "   color:rgb(30,30,30);"
            html += "   line-height: 15px;"
            html += "   font-weight:normal;"
            html += "   text-align:justified;"
            html += "}"
            html += "</style></head>"
            html += "<body class='main_text'>"
            html += item.content
            html += "</body>"
            html += "</body>"
            html += "</html>"
            
            self.tourcontent.loadHTMLString(html, baseURL: rootURL)
            
        }
    }
}

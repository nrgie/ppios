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
import AVFoundation
import GoogleMaps

class GuideController: UIViewController, UIViewControllerTransitioningDelegate, UIWebViewDelegate {

    var locationManager = LocationManager.sharedInstance
    
    //fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    @IBOutlet weak var gmap: GMSMapView!

    var muted: Bool = false
    
    @IBAction func mute(_ sender: Any) {
        if synth.isSpeaking {
            synth.stopSpeaking(at: AVSpeechBoundary.word)
            mutebtn.setImage(UIImage(named: "if_mute_172512"), for:.normal)
            muted = true
        } else {
            if utterance != nil {
                synth.speak(utterance)
            }
            mutebtn.setImage(UIImage(named: "if_high_volume_172479"), for:.normal)
            muted = false
        }
    }
    @IBOutlet weak var mutebtn: UIButton!
    @IBOutlet weak var titleholder: UIView!
    @IBOutlet weak var BarBtn: UIBarButtonItem!
    @IBOutlet weak var backbtn: UIButton!
//    @IBOutlet weak var tourtitle: UILabel!
    @IBOutlet weak var tourcontent: WKWebView!
    @IBOutlet weak var routetitle: UILabel!
    
    let synth = AVSpeechSynthesizer()
    var camera = GMSCameraPosition.camera(withLatitude: 33.86, longitude: 21.20, zoom: 6.0)
    
    var utterance: AVSpeechUtterance!
    
    
    var activePoint: RouteItem? {
        didSet {
            
            let str = (activePoint?.content)!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            
            utterance = AVSpeechUtterance(string: str)
            
            if let item = DataStore.shared.currentTour {
                
                if item.lang == "hu" {
                    utterance.voice = AVSpeechSynthesisVoice(language: "hu-HU")
                }
                else if item.lang == "en" {
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                }
                else if item.lang == "sk" {
                    utterance.voice = AVSpeechSynthesisVoice(language: "sk-SK")
                }
                else if item.lang == "de" {
                    utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
                }
                else {
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                }
            
                if synth.isSpeaking {
                    synth.stopSpeaking(at: AVSpeechBoundary.word)
                }
            
                if self.muted == false {
                    synth.speak(utterance)
                }
                
            }
            
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
            html += activePoint?.content ?? ""
            html +=  "</div><img style='width:100%;height:auto;padding-top:10px;padding-bottom:30px;' src='" + (activePoint?.image ?? "") + "' />"
            html += "</body>"
            html += "</body>"
            html += "</html>"
            
            self.tourcontent.loadHTMLString(html, baseURL: rootURL)
            self.routetitle.text = (activePoint?.title)!
            
            print(activePoint?.latitude)
            print(activePoint?.longitude)
            
            drawMarkers()
            
            camera = GMSCameraPosition.camera(withLatitude: Double((activePoint?.latitude)!)!, longitude: Double((activePoint?.longitude)!)!, zoom: 13.0)
            self.gmap.camera = camera
            
            
        }
    }

    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    @IBAction func showlist(_ sender: Any) {
        
        let menuViewController = storyboard!.instantiateViewController(withIdentifier: "RouteListController")
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self
        presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
        presentationAnimator.supportView = navigationController!.navigationBar
        presentationAnimator.presentButton = sender as! UIView
        present(menuViewController, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var bg: UIImageView!
    @IBAction func back(_ sender: Any) {
        
        let s: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: "main")
        let newNavVC = UINavigationController()
        newNavVC.setViewControllers([vc], animated: false)
        UIApplication.shared.delegate?.window??.rootViewController = newNavVC

    }
    
    func drawMarkers() {
        
        gmap.clear()
        
        for route in (DataStore.shared.currentTour?.routes)! {
            
            do {
                
                route.marker = GMSMarker()
                route.marker.position = CLLocationCoordinate2D(latitude: Double((route.latitude)!)!, longitude: Double((route.longitude)!)!)
                route.marker.title = route.title
                route.marker.snippet = ""
                route.marker.icon = GMSMarker.markerImage(with: .blue)
                route.marker.map = gmap
                
            } catch {
                print("Something went wrong, are you feeling OK?")
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        //NotificationCenter.default.addObserver(self, selector: #selector(fadeToList), name: Constants.Notifications.ShowList, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(fadeToCat), name: Constants.Notifications.ShowCats, object: nil)
        
        let navBar = self.navigationController?.navigationBar
        if let item = DataStore.shared.currentTour {
            navBar?.topItem?.title = item.title
        }
        
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
        
        titleholder.addTopBorderWithColor(color: UIColor.gray, width:1)
        titleholder.addBottomBorderWithColor(color: UIColor.gray, width:1)
        
        //tourcontent.addTopBorderWithColor(color: UIColor.gray, width:1)
        
        if let item = DataStore.shared.currentTour {
            if item.image != nil {
                //bg.sd_setImage(with: URL(string: (item.image)!))
            }
            //self.tourtitle.text = item.title
            
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
            html += item.content ?? ""
            html +=  "</div><img style='width:100%;height:auto;padding-top:10px;padding-bottom:30px;' src='" + (item.image ?? "") + "' />"
            html += "</body>"
            html += "</body>"
            html += "</html>"
            
            self.tourcontent.loadHTMLString(html, baseURL: rootURL)
            
        }
        
        //let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        gmap.isMyLocationEnabled = true
        gmap.camera = camera
        
        
        //let mapIns = UIEdgeInsets(top: 80.0, left: 0.0, bottom: 45.0, right: 0.0)
        //map.padding = mapIns
        
        gmap.settings.compassButton = true
        gmap.isMyLocationEnabled = true
        gmap.settings.myLocationButton = true
        
        locationManager.autoUpdate = true
        
        drawMarkers()
        
        if locationManager.hasLastKnownLocation == true {
            camera = GMSCameraPosition.camera(withLatitude: locationManager.lastKnownLatitude, longitude: locationManager.lastKnownLongitude, zoom: 13.0)
            self.gmap.camera = camera
        }
        
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            if error != nil {
                
                print(error)
                
            } else {
                
                var lat = latitude
                var lng = longitude
                
                self.searchpoints(lat:lat, lng:lng)
                
               // print(latitude)
                
                //self.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 13.0)
                //self.gmap.camera = self.camera
                
                //fillmap
                //fetchroutes
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setActive), name: Constants.Notifications.setActive, object: nil)
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].style.fontFamily =\"HelveticaNeue\"")
    }
    
    func searchpoints(lat:Double, lng:Double) {
    
        for route in (DataStore.shared.currentTour?.routes)! {
            do {
                
                let c0 = CLLocation(latitude: Double(route.latitude ?? "0.0")!, longitude: Double(route.longitude ?? "0.0")!)
                let c1 = CLLocation(latitude: lat, longitude: lat)
            
                var dist = c0.distance(from: c1)
                
                print(route.ID, dist, lat, lng, route.latitude, route.longitude)
                
                /*
                var lowest = 100000000
                if (Int(dist) < lowest) {
                    lowest = Int(dist)
                    
                }
                */
                
                if Int(dist) < Int(DataStore.shared.currentTour?.radius ?? 100) {
                    if self.activePoint?.ID != route.ID {
                        self.activePoint = route
                    }
                }
                
            } catch {
               print("Something went wrong, are you feeling OK?")
            }
        }
        
        //camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 13.0)
        //self.gmap.camera = camera
    
    }

    func setActive(notification: Notification) {
    
        print("Notification Received :", notification)
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let item = dict["item"] as? RouteItem {
                
                self.activePoint = item
                print(item.title)
                print("lat", item.latitude)
                print("lng", item.longitude)

            }
        }
        
        
        
    }
}

//
//  ViewController.swift
//  peripatos
//
//  Created by Tibor Sulyok on 2018. 04. 09..
//  Copyright © 2018. Tibor Sulyok. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class MainController: UIViewController, CardViewListDelegete, ModernSearchBarDelegate {

    @IBOutlet weak var modernSearchBar: ModernSearchBar!
    
    @IBOutlet weak var BarBtn: UIBarButtonItem!
    @IBOutlet weak var CatView: UIView!
    @IBOutlet weak var ListView: UIView!
    @IBOutlet weak var menubtn: UIButton!
    var currentpage: Int = 0
    
    var CatVC: MainCatController?
    var ListVC: MainListController?
    
    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    @IBAction func menu(_ sender: Any) {
        if(currentpage == 0) {
            let menuViewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
            menuViewController.modalPresentationStyle = .custom
            menuViewController.transitioningDelegate = self
            presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
            presentationAnimator.supportView = navigationController!.navigationBar
            presentationAnimator.presentButton = sender as! UIView
            present(menuViewController, animated: true, completion: nil)
        }
        if(currentpage == 1) {
            fadeToCat()
        }
    }
    
    @IBAction func showmenu(_ sender: Any) {
        
        if(currentpage == 0) {
            let menuViewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
            menuViewController.modalPresentationStyle = .custom
            menuViewController.transitioningDelegate = self
            presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
            presentationAnimator.supportView = navigationController!.navigationBar
            presentationAnimator.presentButton = sender as! UIView
            present(menuViewController, animated: true, completion: nil)
        }
        if(currentpage == 1) {
            fadeToCat()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Cat") {
            self.CatVC = segue.destination as! MainCatController
        }
        if (segue.identifier == "List") {
            self.ListVC = segue.destination as! MainListController
        }
    }
    

    func fadeToList() {
        self.CatView.alpha = 0
        self.ListView.alpha = 1
        menubtn.setImage(UIImage(named: "if_left_172489"), for: .normal)
        currentpage = 1
        let width = BarBtn.customView?.widthAnchor.constraint(equalToConstant: 32)
        width?.isActive = true
        let height = BarBtn.customView?.heightAnchor.constraint(equalToConstant: 32)
        height?.isActive = true
        
        let navBar = self.navigationController?.navigationBar
        navBar?.topItem?.title = "Peripatos"
        
        navBar?.barTintColor = UIColor.white
        
        self.makingSearchBarAwesome()
        self.configureSearchBar()
        
    }
    
    func fadeToCat() {
        self.CatView.alpha = 1
        self.ListView.alpha = 0
        menubtn.setImage(UIImage(named: "ic_menu_black_24dp"), for: .normal)
        currentpage = 0
        let width = BarBtn.customView?.widthAnchor.constraint(equalToConstant: 40)
        width?.isActive = true
        let height = BarBtn.customView?.heightAnchor.constraint(equalToConstant: 40)
        height?.isActive = true
        
        let navBar = self.navigationController?.navigationBar
        navBar?.topItem?.title = "Peripatos"
        
        navBar?.barTintColor = UIColor.white
        
        self.makingSearchBarAwesome()
        self.configureSearchBar()
        
    }
    
    private func makingSearchBarAwesome(){
        self.modernSearchBar.backgroundImage = UIImage()
        self.modernSearchBar.layer.borderWidth = 0
        self.modernSearchBar.layer.borderColor = UIColor(red: 181, green: 240, blue: 210, alpha: 1).cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.makingSearchBarAwesome()
        self.configureSearchBar()
        
        fadeToCat()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataStore.shared.getOnboard() != true {
            DataStore.shared.setOnboard(val: true)
            let s: UIStoryboard = UIStoryboard(name: "Onboard", bundle: nil)
            let vc = s.instantiateViewController(withIdentifier: "onboard")
            UIApplication.shared.delegate?.window??.rootViewController = vc //newNavVC
        }
        
        fadeToCat()
        
        self.makingSearchBarAwesome()
        self.configureSearchBar()

        NotificationCenter.default.addObserver(self, selector: #selector(fadeToList), name: Constants.Notifications.ShowList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fadeToCat), name: Constants.Notifications.ShowCats, object: nil)
        
        let navBar = self.navigationController?.navigationBar
        navBar?.topItem?.title = "Peripatos"
        navBar?.barTintColor = UIColor(
            red: 1,
            green: 1,
            blue: 1,
            alpha: 1
        )
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        //if  DataStore.shared.tours == nil {
        Alamofire.request("https://peripatos-app.com/?json=get_tours").responseObject(keyPath: "", completionHandler: {
            (response: DataResponse<Tours>)  in
                let data: Tours = response.value!

                //print(data.toJSONString())
            
                for tour in data.tours {
                    for route in data.tourpoints {
                        if(route.parent == tour.id) {
                            print(route.latitude)
                            tour.routes.append(route)
                        }
                    }
                }
            
                DataStore.shared.tours = data
            
                DataStore.shared.setTours(data:data.toJSONString()!)
            
                if self.CatVC != nil {
                    self.CatVC?.setData(data: data)
                }
            
                if self.ListVC != nil {
                    self.ListVC?.setData(data: data)
                }

            })
        /*
        } else {
            let data: Tours = DataStore.shared.tours!
            if self.CatVC != nil {
                self.CatVC?.setData(data: data)
            }
            if self.ListVC != nil {
                self.ListVC?.setData(data: data)
            }
        }
         */
        
    }
    
    
    ///Called if you use String suggestion list
    func onClickItemSuggestionsView(item: String) {
        print("User touched this item: "+item)
    }
    
    ///Called if you use Custom Item suggestion list
    func onClickItemWithUrlSuggestionsView(item: ModernSearchBarModel) {
        print("User touched this item: "+item.title+" with this url: "+item.url.description)
    }
    
    ///Called when user touched shadowView
    func onClickShadowView(shadowView: UIView) {
        print("User touched shadowView")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filter = FilterData()
        filter.text = searchText
        let pdata:[String: FilterData] = ["filter": filter]
        
        NotificationCenter.default.post(name: Constants.Notifications.ReloadList, object: nil, userInfo:pdata)
        NotificationCenter.default.post(name: Constants.Notifications.ShowList, object: nil, userInfo:pdata)
        print(searchText)
    }
    
    //----------------------------------------
    // CONFIGURE SEARCH BAR (TWO WAYS)
    //----------------------------------------
    
    // 1 - Configure search bar with a simple list of string
    
    private func configureSearchBar(){
        
        ///Create array of string
        var suggestionList = Array<String>()
        /*
        suggestionList.append("Onions")
        suggestionList.append("Celery")
        suggestionList.append("Very long vegetable to show you that cell is updated and fit all the row")
        suggestionList.append("Potatoes")
        suggestionList.append("Carrots")
        suggestionList.append("Broccoli")
        suggestionList.append("Asparagus")
        suggestionList.append("Apples")
        suggestionList.append("Berries")
        suggestionList.append("Kiwis")
        suggestionList.append("Raymond")
        */
        ///Adding delegate
        self.modernSearchBar.delegateModernSearchBar = self
        
        ///Set datas to search bar
        self.modernSearchBar.setDatas(datas: suggestionList)
        
        ///Custom design with all paramaters if you want to
        //self.customDesign()
        
    }
    
    
    
}

extension MainController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - cellSpacing, height: cellHeight)
    }
}

extension MainController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}




//
//  RollView.swift
//  RollView
//
//  Created by Dmitry Volosach on 28.11.2017
//  Copyright © 2017 Dmitry Volosach. All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
//  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
//  IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import UIKit

/**
 Renders vertically scrolling collection of views, where each
 view lays right below previous one from list.
 
 - author: gitvalue
 */
public class RollView: UIView, AdapterView, UIScrollViewDelegate {
    private let scrollViewContentSizeKeyPath = "contentSize"
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var stackView: UIStackView!
    
    /**
     Dictionary of pools, used to reuse RollView child views
     */
    private var pools: [String: Pool<UIView>]!
    
    /**
     Defines if roll fills from top to bottom, or from bottom to top
     */
    public var bottomToTopFillEnabled: Bool!
    
    public var adapter: Adapter?
    
    /**
     List of containers, that hold views
     */
    var views: [ContainerView] {
        return stackView.arrangedSubviews as! [ContainerView]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    deinit {
        scrollView.removeObserver(self, forKeyPath: scrollViewContentSizeKeyPath)
    }
    
    /**
     Configures the view
     */
    private func configure() {
        pools = [:]
        
        let bundle = Bundle(for: RollView.self)
        let contentView = bundle.loadNibNamed("RollView", owner: self, options: nil)?.last as! UIView
        
        contentView.frame = bounds
        //contentView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        
        addSubview(contentView)
        
        //scrollView.translatesAutoresizingMaskIntoConstraints = false
        //stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        scrollView.addObserver(self, forKeyPath: scrollViewContentSizeKeyPath, options: [ .new ], context: nil)
        
        scrollView.delegate = self
    }
    
    /**
     Rebuilds RollView
     */
    public func reload() {
        guard let viewAdapter = adapter else { return }
        
        clear()
        
        for i in 0..<viewAdapter.count {
            let viewType = viewAdapter.viewType(forPosition: i)
            let pool = getPool(for: viewType)
            let container = ContainerView()
            
            container.fill(withView: viewAdapter.view(forPosition: i, convertView: pool.borrow()))
            
            stackView.addArrangedSubview(container)
        }
    }
    
    /**
     Clears RollView
     */
    public func clear() {
        for container in views {
            if let view = container.clear() {
                getPool(for: type(of: view)).recall(view)
            }
            
            stackView.removeArrangedSubview(container)
        }
    }
    
    /**
     Creates pool for a particular view type if it doesn't already exist, or
     returns existing otherwise
     
     - parameters:
        - viewType: type of view
     
     - returns: pool
     */
    private func getPool(for viewType: UIView.Type) -> Pool<UIView> {
        let viewTypeDesc = String(describing: viewType)
        
        if pools[viewTypeDesc] == nil {
            pools[viewTypeDesc] = Pool<UIView>(size: 50) {
                return viewType.init(frame: CGRect.zero)
            }
        }
        
        return pools[viewTypeDesc]!
    }
    
    /**
     Refills container if necessary
     
     - parameters:
        - position: container position
     */
    private func refreshContainer(atPosition position: Int) {
        guard let viewAdapter = adapter else { return }
        
        let container = views[position]
        
        if container.containedView == nil {
            let viewTypeDesc = String(describing: viewAdapter.viewType(forPosition: position))
            let convertView = pools[viewTypeDesc]!.borrow()
            container.fill(withView: viewAdapter.view(forPosition: position, convertView: convertView))
        }
    }
    
    /**
     Clears container if necessary
     
     - parameters:
        - container: container to clean
     */
    private func clearContainer(_ container: ContainerView) {
        if let view = container.clear() {
            let viewTypeDesc = String(describing: type(of: view))
            pools[viewTypeDesc]!.recall(view)
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observedScrollView = object as? UIScrollView, observedScrollView === scrollView, keyPath == scrollViewContentSizeKeyPath {
            onScrollViewContentSizeChange()
        }
    }
    
    /**
     Scroll content height change handler
     */
    private func onScrollViewContentSizeChange() {
        if bottomToTopFillEnabled == true {
            let gapHeight = scrollView.frame.size.height - scrollView.contentSize.height
            
            scrollView.contentInset.top = gapHeight < 0.0 ? 0.0 : gapHeight
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in 0..<views.count {
            if scrollView.bounds.intersects(views[i].frame) {
                refreshContainer(atPosition: i)
            }
            else {
                clearContainer(views[i])
            }
        }
    }
}

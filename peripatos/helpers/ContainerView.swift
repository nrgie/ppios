//
//  ContainerView.swift
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
 Serves as a container for custom view that is added to RollView
 
 - author: gitvalue
 */
class ContainerView: UIView {
    /**
     Container height constraint
     */
    private var heightConstraint: NSLayoutConstraint!
    
    /**
     Stored view
     */
    var containedView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0.0)
        heightConstraint.isActive = false
        
        addConstraint(heightConstraint)
        
        backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Fills container with view
     
     - parameters:
        - view: view to hold
     */
    func fill(withView view: UIView) {
        containedView = view
        
        removeSubviews()
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        
        heightConstraint.isActive = false
    }
    
    /**
     Clears container
     
     - returns: stored view, if exists
     */
    func clear() -> UIView? {
        let result = containedView
        
        heightConstraint.constant = frame.height
        heightConstraint.isActive = true
        
        removeSubviews()
        containedView = nil
        
        return result
    }
    
    /**
     Removes all subviews from container
     */
    private func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}


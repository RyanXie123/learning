//
//  AutoLayout+Extensions.swift
//  仿AppStore
//
//  Created by 谢汝 on 2018/9/15.
//  Copyright © 2018年 谢汝. All rights reserved.
//

import Foundation
import UIKit





extension NSLayoutConstraint {
    static func pinging(view: UIView, attribute: NSLayoutConstraint.Attribute,toView:UIView?, toAttribute:NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        
      return  NSLayoutConstraint(item: view, attribute: attribute , relatedBy: .equal, toItem: toView, attribute: toAttribute, multiplier: multiplier, constant: constant)
    }
    
    
    static func pinning(view: UIView, toView: UIView?, attributes:[NSLayoutConstraint.Attribute], multiplier: CGFloat, constant: CGFloat) -> [NSLayoutConstraint] {
        return attributes.compactMap({ (attribute) -> NSLayoutConstraint in
            return NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: toView, attribute: attribute, multiplier: multiplier, constant: constant)
        })
    }
    
    static func pinningEdges(view: UIView, toView: UIView?) -> [NSLayoutConstraint] {
        let attributes: [NSLayoutConstraint.Attribute] = [.top,.bottom,.leading,.trailing]
        return NSLayoutConstraint.pinning(view: view, toView: toView, attributes: attributes, multiplier: 1.0, constant: 0.0)
    }
    
    
    static func pinningEdgesToSuperview(view: UIView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.pinningEdges(view: view, toView: view.superview)
    }
    
    static func pinnginToSuperview(view: UIView, attributes: [NSLayoutConstraint.Attribute], multiplier: CGFloat, constant: CGFloat) -> [NSLayoutConstraint]{
//        return NSLayoutConstraint.pinning(view: view, toView: view.superview, attributes: attributes, multiplier: multiplier, constant: constant)
        return NSLayoutConstraint.pinning(view: view, toView: view.superview, attributes: attributes, multiplier: multiplier, constant: constant)
    }
    
    

}


extension UIView {
    func pinEdgesToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else {
            return
        }
        let constraints = NSLayoutConstraint.pinningEdgesToSuperview(view: self)
        superview.addConstraints(constraints)
        
    }
    
    func pinToSuperview(forAttributes attributes: [NSLayoutConstraint.Attribute], multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else { return }
        let constraints = NSLayoutConstraint.pinnginToSuperview(view: self, attributes: attributes, multiplier: multiplier, constant: constant)
        superview.addConstraints(constraints)
        
    }
}


//
//  File.swift
//  Pods
//
//  Created by George Tsifrikas on 06/12/15.
//
//

import Foundation
import UIKit

extension UIView {
    public func CsetScale(x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = CGFloat(1.0) / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        self.layer.transform = transform
    }
    
    public func CustomPop() {
        CsetScale(x: 1.2, y: 1.2)
        Cspring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.CsetScale(x: 1, y: 1)
            })
    }
    
    public func Cspring(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .allowAnimatedContent, animations: animations, completion: completion)
    }
}

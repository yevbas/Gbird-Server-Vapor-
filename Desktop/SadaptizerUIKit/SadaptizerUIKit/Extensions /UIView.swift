//
//  UIView.swift
//  SadaptizerUIKit
//
//  Created by Jackson  on 11.02.2022.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var setCornerRadius: CGFloat  {
        get { self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
    }
    
    func addBlur(type: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: type)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
        self.backgroundColor = .clear
        self.addSubview(visualEffectView)
    }
    
}

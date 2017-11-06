//
// Created by Tommy Hinrichsen on 26/10/2017.
// Copyright (c) 2017 Mustache ApS. All rights reserved.
//

import Foundation
import UIKit
//import SCLAlertView

extension SCLAlertView {
    func shake(completion: ((Bool) -> Void)? = nil) {
        self.view.subviews[0].transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.subviews[0].transform = CGAffineTransform.identity
        }, completion: completion)
    }
}

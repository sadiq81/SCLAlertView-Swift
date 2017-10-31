//
// Created by Tommy Hinrichsen on 31/10/2017.
// Copyright (c) 2017 Alexey Poimtsev. All rights reserved.
//

import Foundation
import UIKit

class SLTextView: UITextView {

    let appearance: SCLAppearance

    public init(appearance: SCLAppearance) {
        self.appearance = appearance
        super.init(frame: .zero, textContainer: nil)
        self.setup()
    }

    fileprivate func setup() {
        self.font = appearance.kTextFont
        self.textColor = appearance.textColor
        self.autocapitalizationType = .sentences

        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = appearance.style.themeColor.cgColor
        self.layer.cornerRadius = 3.0

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

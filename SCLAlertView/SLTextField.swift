//
// Created by Tommy Hinrichsen on 31/10/2017.
// Copyright (c) 2017 Alexey Poimtsev. All rights reserved.
//

import Foundation
import UIKit

class SLTextField: UITextField {

    let appearance: SCLAppearance

    public init(_ placeholder: String?, appearance: SCLAppearance) {
        self.appearance = appearance
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.setup()
    }

    fileprivate func setup() {
        self.borderStyle = UITextBorderStyle.roundedRect
        self.font = appearance.kTextFont
        self.textColor = appearance.textColor
        self.autocapitalizationType = UITextAutocapitalizationType.words
        self.clearButtonMode = UITextFieldViewMode.whileEditing

        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = appearance.style.themeColor.cgColor
        self.layer.cornerRadius = 3.0

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}



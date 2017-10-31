//
// Created by Tommy Hinrichsen on 31/10/2017.
// Copyright (c) 2017 Alexey Poimtsev. All rights reserved.
//

import Foundation
import UIKit

open class SCLButton: UIButton {

    var action: (() -> Void)?

    fileprivate var customBackgroundColor: UIColor? {
        didSet { self.backgroundColor = self.customBackgroundColor }
    }

    fileprivate var highlightedBackgroundColor: UIColor {
        get {
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0
            let pressBrightnessFactor = 0.85
            self.backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            brightness = brightness * CGFloat(pressBrightnessFactor)
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
    }

    public init(_ title: String, backgroundColor: UIColor, textColor: UIColor, font: UIFont) {
        super.init(frame: CGRect.zero)
        defer { self.customBackgroundColor = backgroundColor }
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.layer.cornerRadius = 3.0

        self.layer.masksToBounds = true

        self.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? self.highlightedBackgroundColor : self.customBackgroundColor
        }
    }

    @objc
    func buttonTapped(_ btn: SCLButton) {
        self.action?()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
//
// Created by Tommy Hinrichsen on 31/10/2017.
// Copyright (c) 2017 Alexey Poimtsev. All rights reserved.
//

import Foundation
import UIKit

public struct SCLAppearance {
    let kDefaultShadowOpacity: CGFloat

    let textColor: UIColor
    let buttonTextColor: UIColor

    // Fonts
    let kTitleFont: UIFont
    let kTitleMinimumScaleFactor: CGFloat
    let kTextFont: UIFont
    let kButtonFont: UIFont

    // UI Options
    let showCloseButton: Bool
    let shouldAutoDismiss: Bool // Set this false to 'Disable' Auto hideView when SCLButton is tapped

    let dynamicAnimatorActive: Bool
    let buttonsLayout: SCLAlertButtonLayout

    // Actions
    let hideWhenBackgroundViewIsTapped: Bool

    let style: SCLAlertViewStyle

    public init(kDefaultShadowOpacity: CGFloat = 0.7,

                textColor: UIColor = .black,
                buttonTextColor: UIColor = .white,

                kTitleFont: UIFont = UIFont.systemFont(ofSize: 20),
                kTitleMinimumScaleFactor: CGFloat = 1.0,
                kTextFont: UIFont = UIFont.systemFont(ofSize: 14),
                kButtonFont: UIFont = UIFont.boldSystemFont(ofSize: 14),

                disableTapGesture: Bool = false,
                showCloseButton: Bool = true,
                shouldAutoDismiss: Bool = true,
                dynamicAnimatorActive: Bool = false,
                buttonsLayout: SCLAlertButtonLayout = .vertical,

                hideWhenBackgroundViewIsTapped: Bool = false,

                style: SCLAlertViewStyle = .success(nil)) {

        self.kDefaultShadowOpacity = kDefaultShadowOpacity

        self.textColor = textColor
        self.buttonTextColor = buttonTextColor

        self.kTitleFont = kTitleFont
        self.kTitleMinimumScaleFactor = kTitleMinimumScaleFactor
        self.kTextFont = kTextFont
        self.kButtonFont = kButtonFont

        self.showCloseButton = showCloseButton
        self.shouldAutoDismiss = shouldAutoDismiss
        self.dynamicAnimatorActive = dynamicAnimatorActive
        self.buttonsLayout = buttonsLayout

        self.hideWhenBackgroundViewIsTapped = hideWhenBackgroundViewIsTapped

        self.style = style
    }

    static let success = SCLAppearance(style: .success(nil))
    static let error = SCLAppearance(style: .error(nil))
    static let notice = SCLAppearance(style: .notice(nil))
    static let warning = SCLAppearance(style: .warning(nil))
    static let info = SCLAppearance(style: .info(nil))
    static let edit = SCLAppearance(style: .edit(nil))
    static let wait = SCLAppearance(style: .wait(nil, .white))
    static let question = SCLAppearance(style: .question(nil))
}


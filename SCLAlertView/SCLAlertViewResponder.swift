//
// Created by Tommy Hinrichsen on 31/10/2017.
// Copyright (c) 2017 Alexey Poimtsev. All rights reserved.
//

import Foundation

// Allow alerts to be closed/renamed in a chainable manner
// Example: SCLAlertView().showSuccess(self, title: "Test", subTitle: "Value").close()
open class SCLAlertViewResponder {

    let alertView: SCLAlertView

    // Initialisation and Title/Subtitle/Close functions
    public init(alertview: SCLAlertView) {
        self.alertView = alertview
    }

    open func setTitle(_ title: String) {
        self.alertView.titleLabel.text = title
    }

    open func setSubTitle(_ subTitle: String) {
        self.alertView.subtitleLabel.text = subTitle
    }

    open func close() {
        self.alertView.hideView()
    }

    open func setDismissBlock(_ dismissBlock: @escaping DismissBlock) {
        self.alertView.dismissBlock = dismissBlock
    }
}
//
// Created by Tommy Hinrichsen on 31/10/2017.
// Copyright (c) 2017 Alexey Poimtsev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

let kCircleHeightBackground: CGFloat = 62.0

class SLCircleView: UIView {

    let style: SCLAlertViewStyle
    var circleBackground = UIView()
    var circleIconView = UIView()

    init(style: SCLAlertViewStyle) {
        self.style = style
        super.init(frame: .zero)
        self.setup()
        self.setupConstraints()
    }

    fileprivate func setup() {

        self.backgroundColor = .white
        self.isUserInteractionEnabled = false
        self.layer.cornerRadius = (kCircleHeightBackground) / 2

        self.circleBackground.isUserInteractionEnabled = false
        self.circleBackground.layer.cornerRadius = (kCircleHeightBackground - 8) / 2
        self.addSubview(self.circleBackground)

        switch style {
        case .custom(_, let image):
            if image != nil {
                circleBackground.backgroundColor = style.themeColor
                circleIconView = UIImageView(image: image!.withRenderingMode(.alwaysTemplate))
                circleIconView.tintColor = .white
            } else {
                self.isHidden = true
            }
        case .success, .error, .notice, .warning, .info, .edit, .question:
            circleBackground.backgroundColor = style.themeColor
            circleIconView = UIImageView(image: style.circleIconImage!.withRenderingMode(.alwaysTemplate))
            circleIconView.tintColor = .white
        case .wait(_, let activityIndicatorStyle):
            circleBackground.backgroundColor = style.themeColor
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorStyle)
            indicator.startAnimating()
            circleIconView = indicator
        }

        self.circleIconView.layer.masksToBounds = true
        self.circleBackground.addSubview(circleIconView)
    }

    fileprivate func setupConstraints() {

        self.circleBackground.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.height.width.equalTo(self).offset(-8)
            maker.center.equalTo(self)
        }

        self.circleIconView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.height.width.equalTo(circleBackground).multipliedBy(0.5)
            maker.center.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }
}

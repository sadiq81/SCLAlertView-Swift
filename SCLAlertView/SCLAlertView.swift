//
//  SCLAlertView.swift
//  SCLAlertView Example
//
//  Created by Viktor Radchenko on 6/5/14.
//  Copyright (c) 2014 Viktor Radchenko. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

let uniqueTag: Int = Int(arc4random() % UInt32(Int32.max))
let uniqueAccessibilityIdentifier: String = "SCLAlertView"


public typealias DismissBlock = () -> Void

// The Main Class
open class SCLAlertView: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate, UITextFieldDelegate {

    var appearance: SCLAppearance!

    // Members declaration
    var contentView = UIView()

    open var customSubview: UIView?

    var circleView: SLCircleView?

    var titleLabel = UILabel()
    var subtitleLabel = UITextView()

    var dismissBlock: DismissBlock?

    var dismissTap: UITapGestureRecognizer?
    var endEditingTap: UITapGestureRecognizer?

    fileprivate var textFields = [UITextField]()
    fileprivate var textViews = [UITextView]()
    internal var buttons = [SCLButton]()

    //Since we are moving the viewcontrollers view to UIWindow we need to keep a reference to it
    fileprivate var selfReference: SCLAlertView?

    public init(appearance: SCLAppearance) {
        self.appearance = appearance
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required public init() {
        appearance = SCLAppearance()
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        appearance = SCLAppearance()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(SCLAlertView.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(SCLAlertView.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    fileprivate func setup() {

        self.selfReference = self

        // Set up main view
        self.view.alpha = 0
        self.view.tag = uniqueTag
        self.view.accessibilityIdentifier = uniqueAccessibilityIdentifier
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: self.appearance.kDefaultShadowOpacity)

        // Content View
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 0.5
        self.view.addSubview(self.contentView)

        // Title
        self.titleLabel.textColor = appearance.textColor
        self.titleLabel.isUserInteractionEnabled = false
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = self.appearance.kTitleFont
        if (self.appearance.kTitleMinimumScaleFactor < 1) {
            self.titleLabel.minimumScaleFactor = appearance.kTitleMinimumScaleFactor
            self.titleLabel.adjustsFontSizeToFitWidth = true
        }
        // View text
        self.subtitleLabel.textColor = self.appearance.textColor
        self.subtitleLabel.isUserInteractionEnabled = false
        self.contentView.addSubview(self.subtitleLabel)
        self.subtitleLabel.isEditable = false
        self.subtitleLabel.isSelectable = false
        self.subtitleLabel.isScrollEnabled = false
        self.subtitleLabel.textAlignment = .center
        self.subtitleLabel.textContainerInset = UIEdgeInsets.zero
        self.subtitleLabel.textContainer.lineFragmentPadding = 0;
        self.subtitleLabel.font = self.appearance.kTextFont

        //Gesture Recognizer for tapping outside the contentView
        if self.appearance.hideWhenBackgroundViewIsTapped {
            self.dismissTap = UITapGestureRecognizer(target: self, action: #selector(hideView))
            self.dismissTap!.numberOfTapsRequired = 1
            self.dismissTap!.delegate = self
            self.view.addGestureRecognizer(self.dismissTap!)
        }

        //Gesture Recognizer for tapping inside the contentView, but outside a textfield
        self.endEditingTap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.endEditingTap!.numberOfTapsRequired = 1
        self.endEditingTap!.delegate = self
        self.contentView.addGestureRecognizer(self.endEditingTap!)

    }

    var activeField: UIResponder?

    open func addTextField(_ title: String? = nil) -> UITextField {
        let txt = SLTextField(title, appearance: self.appearance)
        txt.delegate = self
        contentView.addSubview(txt)
        textFields.append(txt)
        return txt
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = textField
    }

    open func addTextView() -> UITextView {
        let txt = SLTextView(appearance: self.appearance)
        txt.delegate = self
        contentView.addSubview(txt)
        textViews.append(txt)
        return txt
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text.rangeOfCharacter(from: CharacterSet.newlines) != nil {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.activeField = textView
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        self.activeField = textView
    }

    @discardableResult
    open func addButton(_ title: String, backgroundColor: UIColor? = nil, textColor: UIColor? = nil, action: @escaping () -> Void) -> SCLButton {
        let btn = SCLButton(title, backgroundColor: backgroundColor ?? self.appearance.style.themeColor, textColor: textColor ?? self.appearance.buttonTextColor, font: appearance.kButtonFont)
        btn.action = { [weak self] in
            if let weakSelf = self, weakSelf.appearance.shouldAutoDismiss {
                weakSelf.hideView();
            }
            action()
        }
        contentView.addSubview(btn)
        buttons.append(btn)
        return btn
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == dismissTap {
            return touch.view == gestureRecognizer.view
        } else if gestureRecognizer == endEditingTap {
            return !(touch.view is UITextInput)
        }
        return false
    }

    @discardableResult
    open func showAlert(title: String?, subTitle: String?, closeButtonTitle: String? = nil, animationStyle: SCLAnimationStyle = .topToBottom) -> SCLAlertViewResponder {

        let window = UIApplication.shared.keyWindow! as UIWindow
        window.addSubview(view)

        self.titleLabel.text = title
        self.subtitleLabel.text = subTitle

        // Done button
        if appearance.showCloseButton {
            addButton(closeButtonTitle ?? "Done", action: { [weak self] in self?.hideView() })
        }

        if let subview = self.customSubview {
            self.contentView.addSubview(subview)
        }

        self.circleView = SLCircleView(style: appearance.style)
        self.contentView.addSubview(self.circleView!)

        self.configureConstraints()
        view.setNeedsLayout()
        view.layoutIfNeeded()

        // Animate in the alert view
        self.showAnimation(animationStyle)

        // Chainable objects
        return SCLAlertViewResponder(alertview: self)
    }

// Show animation in the alert view
    fileprivate func showAnimation(_ animationStyle: SCLAnimationStyle = .topToBottom, animationStartOffset: CGFloat = -400.0, boundingAnimationOffset: CGFloat = 15.0, animationDuration: TimeInterval = 0.2) {

//        let rv = UIApplication.shared.keyWindow! as UIWindow
//        var animationStartOrigin = self.baseView.frame.origin
//        var animationCenter: CGPoint = rv.center
//
//        switch animationStyle {
//
//        case .noAnimation:
//            self.view.alpha = 1.0
//            return;
//        case .topToBottom:
//            animationStartOrigin = CGPoint(x: animationStartOrigin.x, y: self.baseView.frame.origin.y + animationStartOffset)
//            animationCenter = CGPoint(x: animationCenter.x, y: animationCenter.y + boundingAnimationOffset)
//        case .bottomToTop:
//            animationStartOrigin = CGPoint(x: animationStartOrigin.x, y: self.baseView.frame.origin.y - animationStartOffset)
//            animationCenter = CGPoint(x: animationCenter.x, y: animationCenter.y - boundingAnimationOffset)
//        case .leftToRight:
//            animationStartOrigin = CGPoint(x: self.baseView.frame.origin.x + animationStartOffset, y: animationStartOrigin.y)
//            animationCenter = CGPoint(x: animationCenter.x + boundingAnimationOffset, y: animationCenter.y)
//        case .rightToLeft:
//            animationStartOrigin = CGPoint(x: self.baseView.frame.origin.x - animationStartOffset, y: animationStartOrigin.y)
//            animationCenter = CGPoint(x: animationCenter.x - boundingAnimationOffset, y: animationCenter.y)
//        }
//
//        self.baseView.frame.origin = animationStartOrigin
//
//        if self.appearance.dynamicAnimatorActive {
//            UIView.animate(withDuration: animationDuration, animations: {
//                self.view.alpha = 1.0
//            })
//            self.animate(item: self.baseView, center: rv.center)
//        } else {
        UIView.animateKeyframes(withDuration: 2 * animationDuration, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                self.view.alpha = 1.0
//                self.baseView.center = animationCenter
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.view.alpha = 1.0
//                self.baseView.center = rv.center
            }
        })
//        }
    }

    // DynamicAnimator function
    var animator: UIDynamicAnimator?
    var snapBehavior: UISnapBehavior?

    fileprivate func animate(item: UIView, center: CGPoint) {

        if let snapBehavior = self.snapBehavior {
            self.animator?.removeBehavior(snapBehavior)
        }

        self.animator = UIDynamicAnimator.init(referenceView: self.view)
        let tempSnapBehavior = UISnapBehavior.init(item: item, snapTo: center)
        self.animator?.addBehavior(tempSnapBehavior)
        self.snapBehavior? = tempSnapBehavior
    }

    // Close SCLAlertView
    @objc
    open func hideView() {

        self.view.endEditing(true)

        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        }, completion: { finished in

            self.dismissBlock?()
            self.view.removeFromSuperview()
            self.selfReference = nil
        })
    }

    //Return true if a SCLAlertView is already being shown, false otherwise
    open func isShowing() -> Bool {
        if let subviews = UIApplication.shared.keyWindow?.subviews {
            for view in subviews {
                if view.tag == uniqueTag && view.accessibilityIdentifier == uniqueAccessibilityIdentifier {
                    return true
                }
            }
        }
        return false
    }

    fileprivate func configureConstraints() {

        let window = UIApplication.shared.keyWindow!

        self.view.snp.makeConstraints { maker in
            maker.edges.equalTo(window)
        }

        self.contentView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(self.view).offset(40)
            maker.right.equalTo(self.view).offset(-40)
            maker.center.equalTo(self.view)
        }

        self.circleView!.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.height.width.equalTo(kCircleHeightBackground)
            maker.centerY.equalTo(self.contentView.snp.top)
            maker.centerX.equalTo(self.contentView)
        }

        self.titleLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(self.contentView).offset(12)
            maker.right.equalTo(self.contentView).offset(-12)
            if !circleView!.isHidden {
                maker.top.equalTo(self.circleView!.snp.bottom)
            } else {
                if self.titleLabel.text != nil {
                    maker.top.equalTo(self.contentView).offset(12)
                } else {
                    maker.top.equalTo(self.contentView).offset(0)
                    maker.height.equalTo(0)
                }
            }
        }

        self.subtitleLabel.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(self.contentView).offset(12)
            maker.right.equalTo(self.contentView).offset(-12)
            if self.subtitleLabel.text.count != 0 {
                maker.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            } else {
                maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
                maker.height.equalTo(0)
            }

            if (textFields.count == 0 && textViews.count == 0 && buttons.count == 0 && self.customSubview == nil) {
                maker.bottom.equalTo(contentView).offset(-12)
            }
        }

        var previous: UIView = subtitleLabel
        var lastNonButtonView: UIView = subtitleLabel

        if let subview = self.customSubview {
            subview.snp.makeConstraints { (maker: ConstraintMaker) in
                maker.top.equalTo(self.subtitleLabel.snp.bottom).offset(self.subtitleLabel.text != nil ? 12 : 0)
                maker.left.equalTo(self.contentView).offset(12)
                maker.right.equalTo(self.contentView).offset(-12)
            }
            previous = subview
            lastNonButtonView = subview
        }

        for txt in textFields {
            txt.snp.makeConstraints { (maker: ConstraintMaker) in
                maker.left.equalTo(self.contentView).offset(12)
                maker.right.equalTo(self.contentView).offset(-12)
                maker.top.equalTo(previous.snp.bottom).offset(12)
            }
            previous = txt
            lastNonButtonView = previous
        }
        for txt in textViews {
            txt.snp.makeConstraints { (maker: ConstraintMaker) in
                maker.left.equalTo(self.contentView).offset(12)
                maker.right.equalTo(self.contentView).offset(-12)
                maker.top.equalTo(previous.snp.bottom).offset(12)
            }
            previous = txt
            lastNonButtonView = previous
        }
        for (index, btn) in buttons.enumerated() {
            switch appearance.buttonsLayout {
            case .vertical:
                btn.snp.makeConstraints { (maker: ConstraintMaker) in
                    maker.left.equalTo(self.contentView).offset(12)
                    maker.right.equalTo(self.contentView).offset(-12)
                    maker.height.equalTo(35)
                    maker.top.equalTo(previous.snp.bottom).offset(12)
                    if btn == buttons.last {
                        maker.bottom.equalTo(contentView).offset(-12)
                    }
                }
                previous = btn
            case .horizontal:
                btn.snp.makeConstraints { (maker: ConstraintMaker) in
                    maker.top.equalTo(lastNonButtonView.snp.bottom).offset(12)
                    maker.bottom.equalTo(contentView).offset(-12)
                    maker.left.equalTo(index == 0 ? contentView : previous.snp.right).offset(12)
                    maker.height.equalTo(35)
                    if btn == buttons.last {
                        maker.right.equalTo(contentView).offset(-12)
                    }
                }
                previous = btn
            }


        }

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

}


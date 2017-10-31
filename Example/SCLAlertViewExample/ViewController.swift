//
//  ViewController.swift
//  SCLAlertViewExample
//
//  Created by Viktor Radchenko on 6/6/14.
//  Copyright (c) 2014 Viktor Radchenko. All rights reserved.
//

import UIKit
import SCLAlertView
import SnapKit

let kSuccessTitle = "Congratulations"
let kErrorTitle = "Connection error"
let kNoticeTitle = "Notice"
let kWarningTitle = "Warning"
let kInfoTitle = "Info"
let kSubtitle = "You've just displayed this awesome Pop Up View"

let kDefaultAnimationDuration = 2.0

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showSuccess(_ sender: AnyObject) {
        let appearance = SCLAppearance(shouldAutoDismiss: false, hideWhenBackgroundViewIsTapped: false, style: .success(nil))
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("First Button", action: { self.firstButton() })
        _ = alert.addButton("Second Button") {
            print("Second button tapped")
        }
        alert.showAlert(title: kSuccessTitle, subTitle: kSubtitle)
    }

    @IBAction func showError(_ sender: AnyObject) {
        let appearance = SCLAppearance(style: .error(nil))
        SCLAlertView(appearance: appearance).showAlert(title: "Hold On...",
                subTitle: "You have not saved your Submission yet. Please save the Submission before accessing the Responses list. Blah de blah de blah, blah. Blah de blah de blah, blah.Blah de blah de blah, blah.Blah de blah de blah, blah.Blah de blah de blah, blah.Blah de blah de blah, blah.",
                closeButtonTitle: "ok")
    }

    @IBAction func showNotice(_ sender: AnyObject) {
        let appearance = SCLAppearance(dynamicAnimatorActive: true, style: .notice(nil))
        SCLAlertView(appearance: appearance).showAlert(title: kNoticeTitle, subTitle: kSubtitle)
    }

    @IBAction func showWarning(_ sender: AnyObject) {
        let appearance = SCLAppearance(style: .warning(nil))
        SCLAlertView(appearance: appearance).showAlert(title: kWarningTitle, subTitle: kSubtitle)
    }

    @IBAction func showInfo(_ sender: AnyObject) {
        let appearance = SCLAppearance(style: .info(nil))
        SCLAlertView(appearance: appearance).showAlert(title: kInfoTitle, subTitle: kSubtitle)
    }

    @IBAction func showEdit(_ sender: AnyObject) {
        let appearance = SCLAppearance(showCloseButton: true, style: .edit(nil))
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("Enter your name")
        alert.addButton("Show Name") {
            print("Text value: \(txt.text ?? "NA")")
        }
        alert.showAlert(title: kInfoTitle, subTitle: kSubtitle)
    }

    @IBAction func showWait(_ sender: AnyObject) {
        let appearance = SCLAppearance(showCloseButton: false, style: .wait(nil, .white))

        let alert = SCLAlertView(appearance: appearance).showAlert(title: "Download", subTitle: "Processing...")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.setSubTitle("Progress: 10%")

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                alert.setSubTitle("Progress: 30%")

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    alert.setSubTitle("Progress: 50%")

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        alert.setSubTitle("Progress: 70%")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            alert.setSubTitle("Progress: 90%")

                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                alert.close()
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func showCustomSubview(_ sender: AnyObject) {
        // Create custom Appearance Configuration
        let appearance = SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: false,
                dynamicAnimatorActive: true,
                style: .info(nil)
        )


        let alertView = SCLAlertView(appearance: SCLAppearance.review)

        let subview = UIView(frame: CGRect(x: 0, y: 0, width: 216, height: 110))

        let ratingView = StarView(true)
        ratingView.frame = CGRect(x: 0, y: 10, width: 216, height: 30)
        ratingView.isActive = true
        subview.addSubview(ratingView)

        let textView = SZTextView()
        textView.frame = CGRect(x: 0, y: 50, width: 216, height: 60)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = Colors.textViewBorder.cgColor
        textView.layer.cornerRadius = 5

        textView.backgroundColor = Colors.textViewBackground
        textView.placeholder = Strings.popup_rating_hint.localized
        textView.textAlignment = .center
        subview.addSubview(textView)

        alertView.customSubview = subview
        alertView.addButton(Strings.popup_rating_button.localized) {
            print("test")
        }

        self.alertViewResponder = alertView.showAlert(title: Strings.popup_rating_header.localized, subTitle: Strings.popup_rating_subheader.localized)

        // Initialize SCLAlertView using custom Appearance
//        let alert = SCLAlertView(appearance: appearance)
//
//        // Creat the subview
//        let subview = UIView()
//
//        // Add textfield 1
//        let textfield1 = UITextField()
//        textfield1.layer.borderColor = UIColor.green.cgColor
//        textfield1.layer.borderWidth = 1.5
//        textfield1.layer.cornerRadius = 5
//        textfield1.placeholder = "Username"
//        textfield1.textAlignment = NSTextAlignment.center
//        subview.addSubview(textfield1)
//
//        // Add textfield 2
//        let textfield2 = UITextField()
//        textfield2.isSecureTextEntry = true
//        textfield2.layer.borderColor = UIColor.blue.cgColor
//        textfield2.layer.borderWidth = 1.5
//        textfield2.layer.cornerRadius = 5
//        textfield1.layer.borderColor = UIColor.blue.cgColor
//        textfield2.placeholder = "Password"
//        textfield2.textAlignment = NSTextAlignment.center
//        subview.addSubview(textfield2)
//
//        textfield1.snp.makeConstraints { maker in
//            maker.top.left.right.equalTo(subview)
//        }
//
//        textfield2.snp.makeConstraints { maker in
//            maker.top.equalTo(textfield1.snp.bottom).offset(12)
//            maker.bottom.left.right.equalTo(subview)
//        }
//
//        // Add the subview to the alert's UI property
//        alert.customSubview = subview
//        alert.addButton("Login") {
//            print("Logged in")
//        }
//
//        alert.addButton("Timeout Button", backgroundColor: UIColor.brown, textColor: UIColor.yellow) {
//            print("Timeout Button tapped")
//        }
//
//        alert.showAlert(title: "Login", subTitle: nil)
    }

    @IBAction func showCustomAlert(_ sender: AnyObject) {
        let icon = UIImage(named: "custom_icon.png")
        let color = UIColor.orange
        let appearance = SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: false,
                dynamicAnimatorActive: true,
                buttonsLayout: .horizontal,
                style: .custom(color, icon)
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("First Button", action: { self.firstButton() })
        alert.addButton("Second Button") {
            print("Second button tapped")
        }


        alert.showAlert(title: "Custom Color", subTitle: "Custom color")
    }

    @objc func firstButton() {
        print("First button tapped")
    }
}

//
// Created by Tommy Hinrichsen on 31/10/2017.
// Copyright (c) 2017 Alexey Poimtsev. All rights reserved.
//

import Foundation
import UIKit

public enum SCLAlertViewStyle {

    case custom(UIColor?, UIImage?), success(UIColor?), error(UIColor?), notice(UIColor?), warning(UIColor?), info(UIColor?), edit(UIColor?), wait(UIColor?, UIActivityIndicatorViewStyle), question(UIColor?)

    public var themeColor: UIColor {
        switch self {
        case .custom(let color, _):
            return color ?? .black
        case .success(let color):
            return color ?? UIColor(red: 34.0 / 255.0, green: 181.0 / 255, blue: 115.0 / 255.0, alpha: 1)
        case .error(let color):
            return color ?? UIColor(red: 193.0 / 255.0, green: 39.0 / 255, blue: 45.0 / 255.0, alpha: 1)
        case .notice(let color):
            return color ?? UIColor(red: 114.0 / 255.0, green: 115.0 / 255, blue: 117.0 / 255.0, alpha: 1)
        case .warning(let color):
            return color ?? UIColor(red: 255.0 / 255.0, green: 209.0 / 255, blue: 16.0 / 255.0, alpha: 1)
        case .info(let color):
            return color ?? UIColor(red: 40.0 / 255.0, green: 102.0 / 255, blue: 191.0 / 255.0, alpha: 1)
        case .edit(let color):
            return color ?? UIColor(red: 164.0 / 255.0, green: 41.0 / 255, blue: 255.0 / 255.0, alpha: 1)
        case .wait(let color, _):
            return color ?? UIColor(red: 214.0 / 255.0, green: 45.0 / 255, blue: 165.0 / 255.0, alpha: 1)
        case .question(let color):
            return color ?? UIColor(red: 114.0 / 255.0, green: 115.0 / 255, blue: 117.0 / 255.0, alpha: 1)
        }
    }

    public var circleIconImage: UIImage? {
        switch self {
        case .custom(_, let image):
            return image
        case .success:
            return SCLAlertViewStyleKit.imageOfCheckmark
        case .error:
            return SCLAlertViewStyleKit.imageOfCross
        case .notice:
            return SCLAlertViewStyleKit.imageOfNotice
        case .warning:
            return SCLAlertViewStyleKit.imageOfWarning
        case .info:
            return SCLAlertViewStyleKit.imageOfInfo
        case .edit:
            return SCLAlertViewStyleKit.imageOfEdit
        case .wait:
            return nil
        case .question:
            return SCLAlertViewStyleKit.imageOfQuestion
        }
    }
}

func ==(lhs: SCLAlertViewStyle, rhs: SCLAlertViewStyle) -> Bool {
    switch (lhs, rhs) {
    case (.custom(_), .custom(_)):
        return true
    case (.success(_), .success(_)):
        return true
    case (.error(_), .error(_)):
        return true
    case (.notice(_), .notice(_)):
        return true
    case (.warning(_), .warning(_)):
        return true
    case (.info(_), .info(_)):
        return true
    case (.edit(_), .edit(_)):
        return true
    case (.wait(_), .wait(_)):
        return true
    case (.question(_), .question(_)):
        return true
    default:
        return false
    }
}
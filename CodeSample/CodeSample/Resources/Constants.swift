//
//  Constants.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/5/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation
import UIKit.UIColor

extension UIColor {
    class func codeSampleGrayBorder() -> UIColor {
        return UIColor(hue: 0, saturation: 0.0, brightness: 0.75, alpha: 1)
    }
}


extension NSNotification.Name {
    static let FiltersUpdated = Notification.Name("FiltersUpdates")
}

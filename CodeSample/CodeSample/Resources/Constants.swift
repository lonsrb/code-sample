//
//  Constants.swift
//  CodeSample
//
//  Created by Ryan Lons on 7/5/20.
//  Copyright © 2020 Ryan Lons. All rights reserved.
//

import Foundation
import UIKit.UIColor
import SwiftUI

extension Color {
    static func codeSampleGrayBorder() -> Color {
        return Color(hue: 0, saturation: 0.0, brightness: 0.75)
    }
}

struct Endpoints {
    static let favorite : String = "/favorite"
    static let listings : String = "/listings"
}

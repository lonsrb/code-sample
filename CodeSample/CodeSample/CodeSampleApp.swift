//
//  CodeSampleApp.swift
//  CodeSample
//
//  Created by Ryan Lons on 9/30/22.
//  Copyright © 2022 Ryan Lons. All rights reserved.
//

import SwiftUI

@main
struct CodeSampleApp: App {
    
    init() {
        ApplicationConfiguration.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Listings()
        }
    }
}

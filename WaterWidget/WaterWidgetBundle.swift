//
//  WaterWidgetBundle.swift
//  WaterWidget
//
//  Created by Estrella Verdiguel on 15/11/25.
//

import WidgetKit
import SwiftUI

@main
struct WaterWidgetBundle: WidgetBundle {
    var body: some Widget {
        WaterProgressWidget()
        WaterWidgetControl()
        WaterWidgetLiveActivity()
    }
}

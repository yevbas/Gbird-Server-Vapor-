//
//  PreferenceKeys.swift
//  DesignCodeiOS15
//
//  Created by Meng To on 2021-11-17.
//

import SwiftUI

struct ScrollPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

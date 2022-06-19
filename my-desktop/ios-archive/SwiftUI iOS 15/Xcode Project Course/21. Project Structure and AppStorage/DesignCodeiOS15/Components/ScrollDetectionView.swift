//
//  ScrollDetectionView.swift
//  DesignCodeiOS15
//
//  Created by Meng To on 2021-11-17.
//

import SwiftUI

struct ScrollDetectionView: View {
    var body: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: ScrollPreferenceKey.self, value: proxy.frame(in: .named("scroll")).minY)
            
            Text("\(proxy.frame(in: .global).minY)")
        }
        .frame(height: 0)
    }
}


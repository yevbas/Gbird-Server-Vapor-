//
//  AnimatingBackground.swift
//  SadaptizerUIKit
//
//  Created by Jackson  on 11.02.2022.
//

import Foundation
import SwiftUI


enum TabBarStyle {
    case news, weather, events, profile, `default`

    var mainColor: Color {
        switch self {
        case .news: return .indigo
        case .weather: return .blue
        case .events:  return .pink
        case .profile: return .orange
        case .default: return .accentColor
        }
    }

    var icons: [String] {
        switch self {
        case .news:  return ["globe.europe.africa",
                             "globe.europe.africa",
                             "globe.europe.africa.fill"]
        case .weather: return ["thermometer.sun", "thermometer.sun", "cloud"]
        case .events: return ["guitars", "person.2", "mouth"]
        case .profile: return ["dollarsign.circle","hand.raised","gear"]
        case .default: return ["questionmark.circle", "questionmark.square", "questionmark.diamond"]
        }
    }

}

struct AnimatedBackground: View {

    @State private var appear = false
    var animatingStyle: TabBarStyle = .default

    var body: some View {
        VStack {
            Image(systemName: animatingStyle.icons.first!)
                .foregroundColor(animatingStyle.mainColor.opacity(appear ? 0.65 : 0.5))
                .font(.system(size: appear ? 100 : 200))
                .offset(x: -60, y: -130)
                .rotationEffect(.degrees(appear ? 360 : Double.random(in: 50...180)))

            Image(systemName: animatingStyle.icons[1])
                .foregroundColor(animatingStyle.mainColor.opacity(appear ? 1.0 : 0.8))
                .font(.system(size: appear ? 50 : 200))
                .offset(x: 100, y: -80)
                .rotationEffect(.degrees(appear ? 360 : 280))

            Image(systemName: animatingStyle.icons.last!)
                .foregroundColor(animatingStyle.mainColor.opacity(appear ? 0.65 : 0.5))
                .font(.system(size: appear ? 120 : 240))
                .offset(x: -60, y: -130)
                .rotationEffect(.degrees(appear ? 360 : Double.random(in: 50...180)))

            HStack {

                Image(systemName: animatingStyle.icons[1])
                    .foregroundColor(animatingStyle.mainColor.opacity(appear ? 1.0 : 0.8))
                    .font(.system(size: appear ? 100 : 200))
                    .offset(x: 100, y: -80)
                    .rotationEffect(.degrees(appear ? 360 : 280))

                Image(systemName: animatingStyle.icons.last!)
                    .foregroundColor(animatingStyle.mainColor.opacity(appear ? 0.65 : 0.5))
                    .font(.system(size: appear ? 80 : 240))
                    .offset(x: -60, y: -130)
                    .rotationEffect(.degrees(appear ? 360 : Double.random(in: 50...180)))
            }

            Image(systemName: animatingStyle.icons.first!)
                .foregroundColor(animatingStyle.mainColor.opacity(appear ? 0.5 : 0.6))
                .font(.system(size: appear ? 150 : Double.random(in: 200...300)))
                .offset(x: -100, y: -50)
                .rotationEffect(.degrees(appear ? 360 : Double.random(in: 100...220)))

            Image(systemName: animatingStyle.icons.last!)
                .foregroundColor(animatingStyle.mainColor.opacity(appear ? 0.65 : 0.5))
                .font(.system(size: appear ? 120 : 240))
                .offset(x: -60, y: -130)
                .rotationEffect(.degrees(appear ? 360 : Double.random(in: 50...180)))

        }.onAppear {
            withAnimation(.linear(duration: 25).repeatForever(autoreverses: true)) {
                appear = true
            }
        }
     }
}

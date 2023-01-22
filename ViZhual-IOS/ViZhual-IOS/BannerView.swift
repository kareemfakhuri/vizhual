//
//  BannerView.swift
//  ViZhual-IOS
//
//  Created by Alireza Toghiani on 1/22/23.
//

import SwiftUI

class Boolean: ObservableObject {
    @Published var value: Bool

    init(_ value: Bool) {
        self.value = value
    }
}

struct BannerView: View {
    @StateObject private var showBanner = Boolean(false)
    @State private var bannerText = "Banner Text"
    let backgroundColor: Color

    var body: some View {
        VStack {
                Text(bannerText)
                    .padding()
                    .background(backgroundColor)
                    .cornerRadius(16)
                    .shadow(radius: 2)
                    .transition(.move(edge: .top))
                    .animation(.easeInOut(duration: 0.5))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.showBanner.value = false
                }
            }
        }
    }
}


//
//  HelperView.swift
//  ViZhual-IOS
//
//  Created by Soro on 2023-01-21.
//

import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical,6)
            .padding(.horizontal,6)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 2)
    }
}

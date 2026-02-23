//
//  LoadingModifier.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    @Binding private var isLoading: Bool
    
    init(isLoading: Binding<Bool>) {
        _isLoading = isLoading
    }

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 2 : 0)

            if isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
                    .tint(.white)
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
}

#Preview {
    VStack {
        Text("Some Body View")
    }
    .loadingOverlay(.constant(true))
}

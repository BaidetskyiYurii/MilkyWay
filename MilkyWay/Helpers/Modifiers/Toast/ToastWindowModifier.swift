//
//  ToastWindowModifier.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 29.04.2026.
//

import SwiftUI

struct ToastWindowModifier<T: View>: ViewModifier {
    @Binding private var isPresented: Bool
    
    private let duration: TimeInterval?
    private let edge: VerticalEdge
    private let onDismiss: (() -> Void)?
    private let toastView: () -> T
    
    @State private var overlay = OverlayWindow()
    @State private var isToastPresented: Bool = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(isPresented: Binding<Bool>,
         duration: TimeInterval?,
         edge: VerticalEdge,
         onDismiss: (() -> Void)?,
         toastView: @escaping () -> T) {
        _isPresented = isPresented
        self.duration = duration
        self.edge = edge
        self.onDismiss = onDismiss
        self.toastView = toastView
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { _, newValue in
                if newValue {
                    overlay.show {
                        Color.clear
                            .toastOverlay(
                                isPresented: $isToastPresented,
                                duration: duration,
                                edge: edge,
                                onDismiss: {
                                    overlay.hide()
                                    onDismiss?()
                                },
                                content: toastView
                            )
                            .preferredColorScheme(colorScheme)
                    }
                    withAnimation {
                        isToastPresented = true
                    }
                } else {
                    isToastPresented = false
                }
            }
            .onChange(of: isToastPresented) { _, newValue in
                if !newValue { isPresented = false }
            }
    }
}

@MainActor
private final class OverlayWindow {
    private var window: UIWindow?
    
    func show<Content: View>(@ViewBuilder content: () -> Content) {
        // Prefer the currently active (foreground) scene.
        let scenes = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
        
        let scene = scenes.first(where: { $0.activationState == .foregroundActive })
        ?? scenes.first(where: { $0.activationState == .foregroundInactive })
        ?? scenes.first
        
        guard let scene else { return }
        
        let window = PassThroughWindow(windowScene: scene)
        let controller = UIHostingController(rootView: content())
        controller.view.backgroundColor = .clear
        
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear
        window.rootViewController = controller
        window.isHidden = false
        
        self.window = window
    }
    
    func hide() {
        window?.isHidden = true
        window = nil
    }
}

private final class PassThroughWindow: UIWindow {
    private var handledEvents = Set<UIEvent>()
    
    override final func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let rootViewController, let rootView = rootViewController.view else { return nil }
        
        guard let event else {
            return super.hitTest(point, with: nil)
        }
        
        guard let hitView = super.hitTest(point, with: event) else {
            handledEvents.removeAll()
            return nil
        }
        if handledEvents.contains(event) {
            handledEvents.removeAll()
            return hitView
        } else if #available(iOS 26, *) {
            let layerName = rootView.layer.hitTest(point)?.name
            if layerName == nil || layerName?.hasPrefix("@") == true {
                handledEvents.insert(event)
                return hitView
            }
            return hitView == rootView ? nil : hitView
        } else if hitView == rootView {
            return nil
        } else {
            handledEvents.insert(event)
            return hitView
        }
    }
}

#Preview {
    struct ToastDemo: View {
        @State private var isToastPresented: Bool = false
        
        var body: some View {
            VStack {
                Button("Show Toast") {
                    isToastPresented.toggle()
                }
            }
            .toast(
                isPresented: $isToastPresented,
                duration: nil,
                edge: .bottom
            ) {
                HStack(spacing: 12) {
                    Image(systemName: "bell.fill")
                        .foregroundStyle(.yellow)
                    
                    Text("Custom content toast")
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
            }
        }
    }
    
    return ToastDemo()
}

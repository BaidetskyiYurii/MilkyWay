//
//  View+Extensions.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import SwiftUI

extension View {
    /// Presents a semi-transparent loading overlay with spinner.
    func loadingOverlay(_ isLoading: Binding<Bool>) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }
    
    @ViewBuilder
    func glassedEffect(
        in shape: some Shape,
        interactive: Bool = false,
        tint: Color? = nil
    ) -> some View {
        if #available(iOS 26.0, *) {
            if interactive {
                self.glassEffect(.regular.tint(tint).interactive(), in: shape)
            } else {
                self.glassEffect(.regular.tint(tint), in: shape)
            }
        } else {
            background(.ultraThinMaterial).clipShape(shape)
        }
    }
}


public extension View {
    /// Presents a custom toast view in a separate overlay window above the current UI.
    ///
    /// This modifier displays a transient, lightweight message or UI (the `content` you provide)
    /// from either the top or bottom edge of the screen. It supports:
    /// - Automatic dismissal after an optional duration
    /// - Manual dismissal by toggling `isPresented`
    /// - Edge selection (`.top` or `.bottom`)
    /// - Drag-to-dismiss interaction in the direction of the edge
    /// - Optional `onDismiss` callback fired after the toast fully disappears
    ///
    /// The toast is hosted in a transparent, pass-through overlay window so it does not block
    /// touches to underlying content except where the toast itself is visible and interactive.
    ///
    /// - Parameters:
    ///   - isPresented: A binding that controls whether the toast is visible. Set to `true` to show the toast and `false` to hide it.
    ///   - duration: Optional auto-dismiss duration in seconds. If `nil` or `<= 0`, the toast will not auto-dismiss.
    ///   - edge: The vertical edge from which the toast appears (`.top` or `.bottom`). Default is `.bottom`.
    ///   - onDismiss: An optional closure called after the toast finishes dismissing (including animation).
    ///   - content: A view builder that provides the custom content of the toast.
    /// - Returns: A view that conditionally presents the toast based on `isPresented`.
    ///
    /// Example:
    /// ```swift
    /// struct ToastDemo: View {
    ///     @State private var isToastPresented: Bool = false
    ///
    ///     var body: some View {
    ///         Button("Show Toast") {
    ///            isToastPresented.toggle()
    ///         }
    ///         .toast(
    ///             isPresented: $isToastPresented,
    ///             duration: 2,
    ///             edge: .top
    ///         ) {
    ///             HStack(spacing: 12) {
    ///                 Image(systemName: "bell.fill")
    ///                     .foregroundStyle(.yellow)
    ///
    ///                 Text("Custom content toast")
    ///                     .font(.callout)
    ///                     .fontWeight(.semibold)
    ///             }
    ///             .padding(.horizontal, 16)
    ///             .padding(.vertical, 12)
    ///             .background(
    ///                 RoundedRectangle(cornerRadius: 20, style: .continuous)
    ///                     .fill(.ultraThinMaterial)
    ///             )
    ///         }
    ///     }
    /// }
    /// ```
    func toast<T: View>(
        isPresented: Binding<Bool>,
        duration: TimeInterval? = 4,
        edge: VerticalEdge = .bottom,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> T
    ) -> some View {
        modifier(
            ToastWindowModifier(
                isPresented: isPresented,
                duration: duration,
                edge: edge,
                onDismiss: onDismiss,
                toastView: content
            )
        )
    }
    
    func toastOverlay<T: View>(
        isPresented: Binding<Bool>,
        duration: TimeInterval? = 4,
        edge: VerticalEdge = .bottom,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> T
    ) -> some View {
        modifier(
            ToastOverlayModifier(
                isPresented: isPresented,
                duration: duration,
                edge: edge,
                onDismiss: onDismiss,
                toastView: content
            )
        )
    }
}

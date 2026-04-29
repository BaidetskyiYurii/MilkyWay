//
//  ToastOverlayModifier.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 29.04.2026.
//

import SwiftUI

struct ToastOverlayModifier<T: View>: ViewModifier {
    @Binding private var isPresented: Bool
    
    private let duration: TimeInterval?
    private let edge: VerticalEdge
    private let onDismiss: (() -> Void)?
    private let toastView: () -> T
    
    private let animationDuration: TimeInterval = 0.3
    
    @State private var dismissTask: Task<Void, Never>? = nil
    @State private var dragOffsetY: CGFloat = 0
    
    private var aligment: Alignment {
        switch edge {
        case .top: .top
        case .bottom: .bottom
        }
    }
    
    private var transitionEdge: Edge {
        switch edge {
        case .top: .top
        case .bottom: .bottom
        }
    }
    
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
                guard !newValue else { return }
                
                cancelAutoDismiss()
                
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: UInt64(animationDuration * 1_000_000_000))
                    onDismiss?()
                }
            }
            .overlay(alignment: aligment) {
                if isPresented {
                    toastView()
                        .offset(y: dragOffsetY)
                        .opacity(Double(max(CGFloat(0.5), 1 - abs(dragOffsetY) / 200)))
                        .gesture(
                            DragGesture(minimumDistance: 5, coordinateSpace: .local)
                                .onChanged { value in
                                    cancelAutoDismiss()
                                    // Only track vertical drag in the correct direction relative to edge
                                    let dy = value.translation.height
                                    switch edge {
                                    case .bottom:
                                        // Allow dragging down (positive dy); clamp upwards movement to zero to avoid jitter
                                        dragOffsetY = max(0, dy)
                                    case .top:
                                        // Allow dragging up (negative dy); clamp downwards movement to zero
                                        dragOffsetY = min(0, dy)
                                    }
                                }
                                .onEnded { value in
                                    let threshold: CGFloat = 30
                                    let dy = value.translation.height
                                    var shouldDismiss = false
                                    switch edge {
                                    case .bottom:
                                        if dy > threshold { shouldDismiss = true }
                                    case .top:
                                        if dy < -threshold { shouldDismiss = true }
                                    }
                                    
                                    if shouldDismiss {
                                        // Trigger dismiss and reset offset
                                        withAnimation(.bouncy(duration: animationDuration)) {
                                            isPresented = false
                                        }
                                    } else {
                                        scheduleAutoDismiss()
                                        // Snap back
                                        withAnimation(.bouncy(duration: animationDuration)) {
                                            dragOffsetY = 0
                                        }
                                    }
                                }
                        )
                        .transition(.move(edge: transitionEdge).combined(with: .blurReplace))
                        .onAppear {
                            scheduleAutoDismiss()
                        }
                }
            }
            .animation(.bouncy, value: isPresented)
    }
}

// MARK: Private methods
private extension ToastOverlayModifier {
    func scheduleAutoDismiss() {
        guard let duration, duration > 0 else { return }
        
        cancelAutoDismiss()
        
        dismissTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            
            if !Task.isCancelled && isPresented {
                isPresented = false
            }
        }
    }
    
    func cancelAutoDismiss() {
        dismissTask?.cancel()
        dismissTask = nil
    }
}

#Preview {
    struct ToastDemo: View {
        @State private var isToastPresented: Bool = false
        
        var body: some View {
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button("Show Toast") {
                        isToastPresented.toggle()
                    }
                    .padding(10)
                    .foregroundStyle(.white)
                    .background(Color.mwPink)
                    
                    Spacer()
                }
                .toastOverlay(isPresented: $isToastPresented,
                              duration: 3.0,
                              edge: .top) {
                    Log.debug("On Dismiss called")
                } content: {
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
            
                Spacer()
            }
            .background(Color.mwBackground)
            
        }
    }
    
    return ToastDemo()
}

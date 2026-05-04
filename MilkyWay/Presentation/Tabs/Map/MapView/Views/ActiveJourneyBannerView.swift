//
//  ActiveJourneyBannerView.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 03.05.2026.
//

import SwiftUI

struct ActiveJourneyBannerView: View {
    let startDate: Date
    let distance: String
    
    @State private var isAnimating = false
    @State private var currentDuration: String = "00:00"
    
    var body: some View {
        HStack(spacing: 12) {
            // Animated blue circle
            animatedCircle
            
            Text("Active Journey")
                .font(Fonts.Poppins.semiBold.swiftUIFont(fixedSize: 16))
                .foregroundStyle(.mwText)
            
            Spacer()
            
            // Time section
            timeSection
            
            // Distance section
            distanceSection
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.mwMapBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.mwCyan.opacity(0.5), lineWidth: 1)
                }
        }
        .onAppear {
            isAnimating = true
            updateDuration()
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            updateDuration()
        }
    }
}

// MARK: Private Methods
private extension ActiveJourneyBannerView {
    func updateDuration() {
        let elapsed = Date.now.timeIntervalSince(startDate)
        let hours = Int(elapsed) / 3600
        let minutes = Int(elapsed) / 60 % 60
        let seconds = Int(elapsed) % 60
        
        if hours > 0 {
            currentDuration = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            currentDuration = String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

// MARK: Views
private extension ActiveJourneyBannerView {
    var animatedCircle: some View {
        Circle()
            .fill(Color.mwCyan)
            .frame(width: 12, height: 12)
            .scaleEffect(isAnimating ? 1.2 : 1.0)
            .opacity(isAnimating ? 0.6 : 1.0)
            .animation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true),
                value: isAnimating
            )
    }
    
    var timeSection: some View {
        VStack(alignment: .center, spacing: 2) {
            Text(currentDuration)
                .font(Fonts.Poppins.semiBold.swiftUIFont(fixedSize: 15))
                .foregroundStyle(.mwCyan)
            
            Text("time")
                .font(Fonts.Poppins.regular.swiftUIFont(fixedSize: 10))
                .foregroundStyle(.mwMutedText)
        }
    }
    
    var distanceSection: some View {
        VStack(alignment: .center, spacing: 2) {
            Text(distance)
                .font(Fonts.Poppins.semiBold.swiftUIFont(fixedSize: 15))
                .foregroundStyle(.mwDeepPurple)
            
            Text("km")
                .font(Fonts.Poppins.regular.swiftUIFont(fixedSize: 10))
                .foregroundStyle(.mwMutedText)
        }
    }
}

#Preview {
    VStack {
        ActiveJourneyBannerView(
            startDate: Date.now.addingTimeInterval(-125), // 2 min 5 sec ago
            distance: "0.65"
        )
        .padding()
        
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.mwBackground)
}

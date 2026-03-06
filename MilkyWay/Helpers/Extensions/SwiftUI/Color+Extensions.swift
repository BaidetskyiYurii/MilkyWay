//
//  Color+Extensions.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 02.06.2025.
//

import SwiftUI

extension Color {
    /// Main app background — use for screen/view backgrounds
    
    /// Card and sheet backgrounds — use for list rows, cards, bottom sheets
    
    /// Default border — use for card outlines, dividers, input field borders
    
    /// Highlighted border — use for focused inputs, selected cards, active states
    
    /// Primary accent (purple) — use for buttons, active tab indicators, links, icons
    
    /// Secondary accent (pink) — use for notifications badges, highlights, secondary buttons
    
    /// Tertiary accent (cyan) — use for speed charts, Greek Isle route, info tags
    
    /// Quaternary accent (yellow) — use for streak indicators, NYC route, warning states)
    
    /// Primary text — use for headings, body text, labels
    
    /// Secondary text — use for subtitles, captions, placeholders, tab labels
    
    /// Splash / outermost background — use for the launch screen background
    
    /// Map background — use as the base fill for map views and mini maps
    
    /// Deep purple — use for gradient starts on buttons and the app logo pin
    
    /// Lavender — use for gradient text (titles, logo), stat values, profile numbers
    
    /// Green — use for battery indicator, success states
    
    /// Notch black — use for the dynamic island / notch background
    
    /// Near black — use for the inner circle of location pin, deepest backgrounds
    
    /// Button red — use for the "End Journey" button gradient start
    
    /// Button pink — use for the "End Journey" button gradient end, toggle track
    
    /// Button mid purple — use for the "Start Journey" button gradient mid-stop
    
    /// Route orange — use for the Barcelona route color and its route cards
    
    /// Route green — use for the Amsterdam route color and its route cards
    
    /// Placeholder text — use for TextField placeholder color
    
    /// Heatmap background — use for the travel heatmap and mini map base fill
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue:  Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

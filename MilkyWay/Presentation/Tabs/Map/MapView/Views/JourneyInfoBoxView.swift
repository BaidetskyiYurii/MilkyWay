//
//  JourneyInfoBoxView.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 01.05.2026.
//

import SwiftUI

enum JourneyInfoBoxType {
    case distance
    case duration
    case pins
    case photos
    
    var imageName: String {
        switch self {
        case .distance:
            "ruler"
        case .duration:
            "clock"
        case .pins:
            "mappin"
        case .photos:
            "photo.stack"
        }
    }
    
    var typeName: String {
        switch self {
        case .distance:
            "Distance"
        case .duration:
            "Duration"
        case .pins:
            "Pins"
        case .photos:
            "Photos"
        }
    }
}

struct JourneyInfoBoxView: View {
    let type: JourneyInfoBoxType
    let value: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                Rectangle()
                    .foregroundStyle(.clear)
                   
                
                Image(systemName: type.imageName)
                    .font(Fonts.Poppins.bold.swiftUIFont(fixedSize: 24))
                    .foregroundStyle(.mwWhite)
            }
            .frame(width: 10, height: 15)
            
            Text(value)
                .font(Fonts.Poppins.semiBold.swiftUIFont(fixedSize: 16))
                .foregroundStyle(.mwWhite)
                .padding(.top, 15)
            
            Text(type.typeName)
                .font(Fonts.Poppins.regular.swiftUIFont(fixedSize: 14))
                .foregroundStyle(.mwMutedText)
                .padding(.top, 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .padding(.horizontal, 5)
        .background(Color.mwHeatmapBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.mwBorder, lineWidth: 2)
        )
    }
}

#Preview {
    HStack(spacing: 12) {
        JourneyInfoBoxView(type: .distance, value: "0.38 km")
        JourneyInfoBoxView(type: .duration, value: "01:35")
        JourneyInfoBoxView(type: .pins, value: "0")
        JourneyInfoBoxView(type: .photos, value: "0")
    }
    .padding(.horizontal, 15)
    .background(.mwBackground)
}

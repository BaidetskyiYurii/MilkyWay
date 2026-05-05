//
//  DropPinView.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 05.05.2026.
//

import SwiftUI
import MapKit

struct DropPinView: View {
    
    @Binding private var isShowSheet: Bool
    
    init(isShowSheet: Binding<Bool>) {
        _isShowSheet = isShowSheet
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 15) {
                header
            }
            
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .onTapGesture {
//            routeNameFocus = false
        }
    }
}

// MARK: Views
private extension DropPinView {
    var header: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Drop Pin")
                    .foregroundColor(.mwText)
                    .font(Fonts.Poppins.bold.swiftUIFont(size: 20))
                
                Text("Mark this moment on your route")
                    .foregroundColor(.mwMutedText)
                    .font(Fonts.Poppins.bold.swiftUIFont(size: 12))
            }
            
            Spacer()
        }
        .padding(.horizontal, 15)
    }
    
//    var routePreviewMap: some View {
//        Map(position: $cameraPosition) {
//            // Draw the route polyline (lowest layer)
//            if recordedLocations.count > 1 {
//                MapPolyline(coordinates: recordedLocations.map { $0.coordinate })
//                    .stroke(.blue, lineWidth: 5)
//                    .mapOverlayLevel(level: .aboveRoads)
//            }
//            
//            // Start location marker (middle layer)
//            Annotation("Start", coordinate: startLocation.coordinate) {
//                ZStack {
//                    Circle()
//                        .fill(.green)
//                        .frame(width: 25, height: 25)
//                    
//                    Image(systemName: "figure.walk")
//                        .foregroundColor(.white)
//                        .font(.system(size: 14, weight: .bold))
//                }
//            }
//            .annotationTitles(.hidden)
//            
//            // End location marker (top layer - appears last, renders on top)
//            Annotation("End", coordinate: endLocation.coordinate) {
//                ZStack {
//                    Circle()
//                        .fill(.red)
//                        .frame(width: 25, height: 25)
//                    
//                    Image(systemName: "flag.checkered")
//                        .foregroundColor(.white)
//                        .font(.system(size: 14, weight: .bold))
//                }
//            }
//            .annotationTitles(.hidden)
//        }
//        .mapStyle(.standard)
//        .preferredColorScheme(.dark)
//        .onAppear {
//            // Calculate the region to show the entire route
//            updateCameraPosition()
//        }
//    }
}

#Preview {
    DropPinView(isShowSheet: .constant(true))
        .background(Color.mwBackground)
}

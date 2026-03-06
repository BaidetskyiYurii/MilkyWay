//
//  RecordRouteButtonView.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 26.02.2026.
//

import SwiftUI
import MapKit

struct RecordRouteButtonView: View {
    var locationService: LocationService
    var viewModel: MapViewModel
    
    @Binding var cameraPosition: MapCameraPosition
    
    var body: some View {
        Button {
            if locationService.isRecording {
                locationService.stopRecording()
                
                Task {
                    let newRoute = viewModel.createNewRoute(
                        isRecording: locationService.isRecording,
                        startLocation: locationService.startLocation,
                        endLocation: locationService.endLocation,
                        recordedLocations: locationService.recordedLocations)
                    
                    if let newRoute {
                        await viewModel.insertNewMapRoute(newRoute)
                    }
                }
            } else {
                withAnimation {
                    cameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
                }
                
                locationService.startRecording()
            }
        } label: {
            Text(locationService.isRecording ? "Stop" : "Start")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(locationService.isRecording ? .red : .green)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
    }
}

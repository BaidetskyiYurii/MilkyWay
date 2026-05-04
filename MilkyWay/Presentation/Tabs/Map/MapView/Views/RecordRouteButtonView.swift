//
//  RecordRouteButtonView.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 26.02.2026.
//

import SwiftUI
import MapKit
import FactoryKit

struct RecordRouteButtonView: View {
    @Environment(LocationService.self) private var locationService
    
    var viewModel: MapViewModel
    
    @Binding var cameraPosition: MapCameraPosition
    let mapScope: Namespace.ID?
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 10) {
                    MapCompass(scope: mapScope)
       
                    mapUserLocationButton
                }
            }
            .padding(.bottom, 10)
            
            if locationService.isRecording {
                HStack(alignment: .center, spacing: 8) {
                    createActionButton(type: .memory)
                    
                    createActionButton(type: .pin)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(Color.mwBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.mwBorder, lineWidth: 1)
                )
            }
            
            journeyButton
        }
        .animation(.default, value: locationService.isRecording)
    }
}

extension RecordRouteButtonView {
    enum ActionType {
        case memory
        case pin
        
        var systemImage: String {
            switch self {
            case .memory:
                "camera.circle"
            case .pin:
                "mappin.and.ellipse.circle"
            }
        }
        
        var title: String {
            switch self {
            case .memory:
                "Add Memory"
            case .pin:
                "Drop Pin"
            }
        }
    }
}

// MARK: Views
extension RecordRouteButtonView {
    func createActionButton(type: ActionType) -> some View {
        Button {
            withAnimation {
                // TODO: add actions
                switch type {
                case .memory:
                    break
                case .pin:
                    break
                }
            }
        } label: {
            HStack(alignment: .center, spacing: 5) {
                Spacer()
                
                Image(systemName: type.systemImage)
                    .font(Fonts.Poppins.regular.swiftUIFont(size: 20))
                
                Text(type.title)
                    .font(Fonts.Poppins.regular.swiftUIFont(size: 16))
                
                Spacer()
            }
            .foregroundStyle(.mwWhite)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color.mwCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.mwBorder, lineWidth: 1)
            )
        }
    }
    
    @ViewBuilder
    var journeyButton: some View {
        let isRecording = locationService.isRecording
        
        Button {
            if isRecording {
                handleStopAction()
            } else {
                handleStartAction()
            }
        } label: {
            HStack(alignment: .center, spacing: 10) {
                Spacer()
                
                Image(systemName: isRecording ? "stop.circle" : "sparkles")
                
                Text(isRecording ? "End Journey" : "Start Journey")
                    .font(Fonts.Poppins.semiBold.swiftUIFont(size: 20))
                
                Spacer()
            }
            .foregroundStyle(.white)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background {
                isRecording ? LinearGradient.endJourney : LinearGradient.startJourney
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    var mapUserLocationButton: some View {
        MapUserLocationButton(scope: mapScope)
            .glassEffect()
            .clipShape(Circle())
            .shadow(radius: 4)
            .tint(locationService.isRecording ? Color.mwButtonPink : .mwLavender)
    }
}

// MARK: Private Methods
extension RecordRouteButtonView {
    func handleStartAction() {
        withAnimation {
            cameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
        }
        
        locationService.startRecording()
    }
    
    func handleStopAction() {
        locationService.stopRecording()
        
        viewModel.createNewRoute(
            isRecording: locationService.isRecording,
            startLocation: locationService.startLocation,
            endLocation: locationService.endLocation,
            recordedLocations: locationService.recordedLocations)
        
        cameraPosition = .automatic
    }
}

#Preview {
    RecordRouteButtonView(
        viewModel: Container.shared.mapViewModel.callAsFunction(),
        cameraPosition: .constant(.userLocation(fallback: .automatic)),
        mapScope: nil
    )
    .environment(Container.shared.locationService.callAsFunction())
    .padding(20)
}

//
//  MapView.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import SwiftUI
import FactoryKit
import MapKit

struct MapView: View {
    @CoordinatorLink var appCoordinator: AppCoordinator
    @CoordinatorLink var coordinator: MapFlowCoordinator
    
    @InjectedObservable(\.mapViewModel) var viewModel
    @InjectedObservable(\.locationService) var locationService
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
    
    @Namespace private var mapScope
    
    var body: some View {
        Map(position: $cameraPosition, scope: mapScope) {
            UserAnnotation()
            
            MapPolyline(
                   coordinates: locationService.recordedLocations.map { $0.coordinate }
               )
               .stroke(.blue, lineWidth: 4)
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                
                RecordRouteButton()
                    .padding(.horizontal, 2)
                
                MapUserLocationButton(scope: mapScope)
                    .background(.thinMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
        }
        .mapScope(mapScope)
        .navigationTitle(LS.Map.navTitle)
        .loadingOverlay($viewModel.isLoading)
        .onAppear {
            updateCameraPosition()
        }
    }
    
    func updateCameraPosition() {
        if let userLocation = locationService.currentLocation {
            let userRegion = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.15,
                    longitudeDelta: 0.15
                )
            )
            withAnimation {
                cameraPosition = .region(userRegion)
            }
        }
    }
}

// MARK: Private UI
private extension MapView {
}

#Preview {
//    let previewContainer = MapItemDTO.preview
//    
//    Container.shared.modelContainer.register {
//        previewContainer
//    }
    MapView()
//            .modelContainer(previewContainer)
}


struct RecordRouteButton: View {

    @InjectedObservable(\.locationService)
    private var locationService

    var body: some View {
        Button {
            if locationService.isRecording {
                locationService.stopRecording()
            } else {
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

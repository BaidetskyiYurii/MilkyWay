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
            
            // Start Marker
            if let start = locationService.startLocation {
                Annotation("Start", coordinate: start.coordinate) {
                    Circle()
                        .fill(.green)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle().stroke(.white, lineWidth: 3)
                        )
                }
            }
            
            // End Marker
            if let end = locationService.endLocation {
                Annotation("Finish", coordinate: end.coordinate) {
                    Circle()
                        .fill(.red)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle().stroke(.white, lineWidth: 3)
                        )
                }
            }
            
           
            let coords = locationService.recordedLocations.map { $0.coordinate }

            MapPolyline(coordinates: coords)
                .stroke(
                    .blue.opacity(0.25),
                    style: StrokeStyle(
                        lineWidth: 12,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )

            MapPolyline(coordinates: coords)
                .stroke(
                    .blue,
                    style: StrokeStyle(
                        lineWidth: 6,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                
                RecordRouteButton(cameraPosition: $cameraPosition)
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
        .onAppear {
            updateCameraPosition()
        }
    }
}

// MARK: Private Methods
private extension MapView {
    func updateCameraPosition() {
//        guard let userLocation = locationService.currentLocation else { return }
//        let userRegion = MKCoordinateRegion(
//            center: userLocation.coordinate,
//            span: MKCoordinateSpan(
//                latitudeDelta: 0.15,
//                longitudeDelta: 0.15
//            )
//        )
        
        withAnimation {
            if locationService.isRecording {
                cameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
            } else {
//                cameraPosition = .region(userRegion)
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
    
    @Binding var cameraPosition: MapCameraPosition
    
    var body: some View {
        Button {
            if locationService.isRecording {
                locationService.stopRecording()
                zoomToRoute()
                
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
    
    func zoomToRoute() {
        let coords = locationService.recordedLocations.map { $0.coordinate }
        guard let rect = MKMapRect.fitting(coords, paddingMeters: 250) else { return }
        
        withAnimation {
            cameraPosition = .rect(rect)
        }
    }
}

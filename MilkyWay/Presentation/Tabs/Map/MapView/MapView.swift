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
        
            ForEach(viewModel.routes) { route in
                let startLocation = route.startLocation.toLocationCoordinate()
                let endLocation = route.endLocation.toLocationCoordinate()
                let coords = route.polylineCoordinates.map { $0.toLocationCoordinate() }
                
                createMapRouteUI(
                    startLocation: startLocation,
                    endLocation: endLocation,
                    polylineCoordinates: coords
                )
            }
            
            if locationService.isRecording {
                let coords = locationService.recordedLocations.map { $0.coordinate }
                createMapRouteUI(
                    startLocation: locationService.startLocation?.coordinate,
                    endLocation: locationService.endLocation?.coordinate,
                    polylineCoordinates: coords
                )
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                
                RecordRouteButtonView(locationService: locationService, viewModel: viewModel, cameraPosition: $cameraPosition)
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
        .task {
            await viewModel.getAllRoutes()
        }
        .onChange(of: viewModel.routeIdToZoomIn) { _, newValue in
            guard let newValue else { return }
            zoomToRoute(with: newValue)
        }
        .onChange(of: viewModel.customError, { _, newError in
            guard let newError else { return }
            
            coordinator
                .alert(newError.errorTitle,
                       message: newError.errorDescription) {
                    
                Button(LS.Common.ok) {
                    withAnimation {
                        viewModel.customError = nil
                    }
                }
            }
        })
    }
}

// MARK: Private UI
private extension MapView {
    @MapContentBuilder
    func createMapRouteUI(
        startLocation: CLLocationCoordinate2D?,
        endLocation: CLLocationCoordinate2D?,
        polylineCoordinates: [CLLocationCoordinate2D]
    ) -> some MapContent {
        // Start Marker
        if let startLocation {
            Annotation("Start", coordinate: startLocation) {
                Circle()
                    .fill(.green)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle().stroke(.white, lineWidth: 3)
                    )
            }
        }
        
        // End Marker
        if let endLocation {
            Annotation("Finish", coordinate: endLocation) {
                Circle()
                    .fill(.red)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle().stroke(.white, lineWidth: 3)
                    )
            }
        }

        MapPolyline(coordinates: polylineCoordinates)
            .stroke(
                .blue.opacity(0.25),
                style: StrokeStyle(
                    lineWidth: 12,
                    lineCap: .round,
                    lineJoin: .round
                )
            )

        MapPolyline(coordinates: polylineCoordinates)
            .stroke(
                .blue,
                style: StrokeStyle(
                    lineWidth: 6,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
    }
    
    func zoomToRoute(with id: String) {
        guard let route = viewModel.routes.first(where: { $0.id == id }) else {
            Log.debug("No route found to zoom")
            return
        }
        
        let routeCoords = route.polylineCoordinates.map { $0.toLocationCoordinate() }
        guard let rect = MKMapRect.fitting(routeCoords, paddingMeters: 250) else { return }
        
        withAnimation {
            cameraPosition = .rect(rect)
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

#Preview {
    let previewContainer = MapRouteDTO.preview
    
    Container.shared.modelContainer.register {
        previewContainer
    }
    
    return MapView()
        .modelContainer(previewContainer)
}

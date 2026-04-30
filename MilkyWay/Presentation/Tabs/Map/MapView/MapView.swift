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
    @Environment(\.scenePhase) private var scenePhase
    @Environment(LocationService.self) private var locationService
    
    @CoordinatorLink var appCoordinator: AppCoordinator
    @CoordinatorLink var coordinator: MapFlowCoordinator
    
    @InjectedObservable(\.mapViewModel) var viewModel
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
    @Namespace private var mapScope
    
    var body: some View {
        map
            .mapStyle(.standard)
            .preferredColorScheme(.dark)
            .overlay(alignment: .bottom) {
                ZStack(alignment: .bottom) {
                    GeometryReader { geo in
                        LinearGradient.mapBottom
                            .frame(height: 220 + geo.safeAreaInsets.bottom)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    .allowsHitTesting(true)
                    
                    RecordRouteButtonView(
                        viewModel: viewModel,
                        cameraPosition: $cameraPosition,
                        mapScope: mapScope)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
                .ignoresSafeArea(edges: .bottom)
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
            .onChange(of: viewModel.customError) { _, newError in
                guard let newError else { return }
                
                coordinator
                    .alert(newError.errorTitle,
                           message: newError.errorDescription) {
                        
                        Button(.ok) {
                            withAnimation {
                                viewModel.customError = nil
                            } 
                        }
                    }
            }
            .onChange(of: scenePhase) { _, newPhase in
                guard newPhase == .active else { return }
                
                updateCameraPosition()
            }
            .sheet(isPresented: $viewModel.isShowFinishRouteSheet) {
                FinishRouteView(
                    viewModel: viewModel,
                    isShowSheet: $viewModel.isShowFinishRouteSheet,
                    startLocation: locationService.startLocation!,
                    endLocation: locationService.endLocation!,
                    recordedLocations: locationService.recordedLocations)
                .presentationDetents([.medium, .large])
                .interactiveDismissDisabled(true)
                .background(Color.mwBackground)
            }
    }
}

// MARK: Private UI
private extension MapView {
    var map: some View {
        Map(position: $cameraPosition, scope: mapScope) {
            // Saved routes (bottom layer)
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
            
            // Currently recording route (middle layer)
            if locationService.isRecording {
                let coords = locationService.recordedLocations.map { $0.coordinate }
                createMapRouteUI(
                    startLocation: locationService.startLocation?.coordinate,
                    endLocation: locationService.endLocation?.coordinate,
                    polylineCoordinates: coords
                )
            }
            
            // User location (top layer - always visible)
            UserAnnotation()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @MapContentBuilder
    func createMapRouteUI(
        startLocation: CLLocationCoordinate2D?,
        endLocation: CLLocationCoordinate2D?,
        polylineCoordinates: [CLLocationCoordinate2D]
    ) -> some MapContent {        
        // Start Marker
        if let startLocation {
            // Start location marker
            Annotation("Start", coordinate: startLocation) {
                ZStack {
                    Circle()
                        .fill(.green)
                        .frame(width: 25, height: 25)
                    
                    Image(systemName: "figure.walk")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .bold))
                }
            }
        }
        
        // End Marker
        if let endLocation {
            Annotation("End", coordinate: endLocation) {
                ZStack {
                    Circle()
                        .fill(.red)
                        .frame(width: 25, height: 25)
                    
                    Image(systemName: "flag.checkered")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .bold))
                }
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
        .environment(Container.shared.locationService.callAsFunction())
}

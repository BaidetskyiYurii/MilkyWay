//
//  FinishRouteView.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 16.04.2026.
//

import SwiftUI
import CoreLocation
import FactoryKit
import MapKit

struct FinishRouteView: View {
    private var viewModel: MapViewModel
    
    @Binding private var isShowSheet: Bool
    
    private let startLocation: CLLocation
    private let endLocation: CLLocation
    private let recordedLocations: [CLLocation]
    
    @FocusState private var routeNameFocus: Bool
    
    @State private var routeName: String = ""
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    init(viewModel: MapViewModel,
         isShowSheet: Binding<Bool>,
         startLocation: CLLocation,
         endLocation: CLLocation,
         recordedLocations: [CLLocation]) {
        self.viewModel = viewModel
        _isShowSheet = isShowSheet
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.recordedLocations = recordedLocations
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 15) {
                header
                
                // Route Preview Map
                routePreviewMap
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.mwBorder, lineWidth: 2)
                    )
                    .padding(.horizontal, 15)
                
                HStack(spacing: 10) {
                    JourneyInfoBox(type: .distance, value: "0.38 km")
                    JourneyInfoBox(type: .duration, value: "01:35")
                    JourneyInfoBox(type: .pins, value: "0")
                    JourneyInfoBox(type: .photos, value: "0")
                }
                .padding(15)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("ROUTE NAME")
                        .foregroundColor(.mwText)
                        .font(Fonts.Poppins.bold.swiftUIFont(size: 20))
                    
                    InputTextFieldView(
                        type: .routeName,
                        text: $routeName,
                        isFocused: $routeNameFocus)
                }
                .padding(.horizontal, 15)
               
                // TODO: implement view for pins and photos
          
                buttons
                    .padding(.top, 15)
              
                Spacer()
            }
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .onTapGesture {
            routeNameFocus = false
        }
    }
}

// MARK: Private views
private extension FinishRouteView {
    var header: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(.journeyCompleteStar)
                .resizable()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Journey Complete")
                    .foregroundColor(.mwText)
                    .font(Fonts.Poppins.bold.swiftUIFont(size: 20))
                
                Text("Review and save your route")
                    .foregroundColor(.mwMutedText)
                    .font(Fonts.Poppins.bold.swiftUIFont(size: 12))
            }
            
            Spacer()
        }
        .padding(.horizontal, 15)
       
    }
    var routePreviewMap: some View {
        Map(position: $cameraPosition) {
            // Draw the route polyline (lowest layer)
            if recordedLocations.count > 1 {
                MapPolyline(coordinates: recordedLocations.map { $0.coordinate })
                    .stroke(.blue, lineWidth: 5)
                    .mapOverlayLevel(level: .aboveRoads)
            }
            
            // Start location marker (middle layer)
            Annotation("Start", coordinate: startLocation.coordinate) {
                ZStack {
                    Circle()
                        .fill(.green)
                        .frame(width: 25, height: 25)
                    
                    Image(systemName: "figure.walk")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .bold))
                }
            }
            .annotationTitles(.hidden)
            
            // End location marker (top layer - appears last, renders on top)
            Annotation("End", coordinate: endLocation.coordinate) {
                ZStack {
                    Circle()
                        .fill(.red)
                        .frame(width: 25, height: 25)
                    
                    Image(systemName: "flag.checkered")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .bold))
                }
            }
            .annotationTitles(.hidden)
        }
        .mapStyle(.standard)
        .preferredColorScheme(.dark)
        .onAppear {
            // Calculate the region to show the entire route
            updateCameraPosition()
        }
    }
    
    var buttons: some View {
        VStack(alignment: .center, spacing: 10) {
            Button {
                Task {
                    let newRoute = MapRoute(
                        id: UUID().uuidString,
                        name: routeName,
                        startLocation: .init(from: startLocation),
                        endLocation: .init(from: endLocation),
                        polylineCoordinates: recordedLocations.map { .init(from: $0) },
                        createdAt: Date()
                    )
                    
                    await viewModel.insertNewMapRoute(newRoute)
                }
            } label: {
                HStack(alignment: .center, spacing: 5) {
                    Spacer()
                    
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.mwWhite)
                    
                    Text("Save Journey")
                        .foregroundColor(.mwWhite)
                        .font(Fonts.Poppins.bold.swiftUIFont(size: 20))
                    
                    Spacer()
                    
                }
                .frame(height: 55)
                .background(LinearGradient.endJourney)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 15)
                .padding(.vertical, 4)
            }
            
            Button {
                withAnimation {
                    isShowSheet = false
                }
            } label: {
                Text("Discard")
                    .foregroundColor(.mwButtonRed)
                    .font(Fonts.Poppins.semiBold.swiftUIFont(size: 16))
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.black.opacity(0.3))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.mwButtonRed.opacity(0.5), lineWidth: 2)
                            .shadow(color: .mwButtonRed.opacity(0.6), radius: 8, x: 0, y: 0)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .mwButtonRed.opacity(0.4), radius: 12, x: 0, y: 0)
            }
            .padding(.horizontal, 15)
        }
    }
}

// MARK: Helper Methods
private extension FinishRouteView {
    func updateCameraPosition(paddingMeters: Double = 1500) {
        guard !recordedLocations.isEmpty else { return }
        
        let coordinates = recordedLocations.map { $0.coordinate }
        
        guard let mapRect = MKMapRect.fitting(coordinates, paddingMeters: paddingMeters) else { return }
        
        cameraPosition = .rect(mapRect)
    }
}

#Preview {
    @Previewable var isShowSheet = true
    
    // Sample route data for preview
    let start = CLLocation(latitude: 37.7749, longitude: -122.4194) // San Francisco
    let end = CLLocation(latitude: 37.7849, longitude: -122.4094)
    let sampleLocations = [
        CLLocation(latitude: 37.7749, longitude: -122.4194),
        CLLocation(latitude: 37.7769, longitude: -122.4174),
        CLLocation(latitude: 37.7789, longitude: -122.4154),
        CLLocation(latitude: 37.7809, longitude: -122.4134),
        CLLocation(latitude: 37.7829, longitude: -122.4114),
        CLLocation(latitude: 37.7849, longitude: -122.4094)
    ]
    
    FinishRouteView(
        viewModel: Container.shared.mapViewModel.callAsFunction(),
        isShowSheet: .constant(isShowSheet),
        startLocation: start,
        endLocation: end,
        recordedLocations: sampleLocations
    )
    .background(Color.mwBackground)
}

//                HStack {
//                    Button {
//                        Task {
//                            let newRoute = MapRoute(
//                                id: UUID().uuidString,
//                                name: routeName,
//                                startLocation: .init(from: startLocation),
//                                endLocation: .init(from: endLocation),
//                                polylineCoordinates: recordedLocations.map { .init(from: $0) },
//                                createdAt: Date()
//                            )
//
//                            await viewModel.insertNewMapRoute(newRoute)
//                        }
//                    } label: {
//                        HStack(alignment: .center, spacing: 5) {
//                            Image(systemName: "checkmark.seal.fill")
//                                .foregroundColor(.mwLavender)
//
//                            Text("Save")
//                                .foregroundColor(.mwLavender)
//                                .font(Fonts.Poppins.semiBold.swiftUIFont(size: 16))
//
//                        }
//                        .padding(.horizontal, 6)
//                        .padding(.vertical, 4)
//                    }
//                    .glassEffect(.clear, in: .capsule)
//
//                    Spacer()
//
//                    Button {
//                        withAnimation {
//                            isShowSheet = false
//                        }
//                    } label: {
//                        Text("Fuggetaboutit")
//                            .foregroundColor(.mwLavender)
//                            .font(Fonts.Poppins.semiBold.swiftUIFont(size: 16))
//                            .padding(.horizontal, 6)
//                            .padding(.vertical, 4)
//                    }
//                    .glassEffect(.clear, in: .capsule)
//                }
//                .padding(.top, 15)
//                .padding(.horizontal, 15)

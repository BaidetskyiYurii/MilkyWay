//
//  FinishRouteView.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 16.04.2026.
//

import SwiftUI
import CoreLocation
import FactoryKit

struct FinishRouteView: View {
    var viewModel: MapViewModel
    
    @Binding var isShowSheet: Bool
    
    let startLocation: CLLocation
    let endLocation: CLLocation
    let recordedLocations: [CLLocation]
    
    @State private var routeName: String = ""
    @FocusState private var routeNameFocus: Bool
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 15) {
                HStack {
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
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.mwLavender)
                            
                            Text("Save")
                                .foregroundColor(.mwLavender)
                                .font(Fonts.Poppins.semiBold.swiftUIFont(size: 16))
                            
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                    }
                    .glassEffect(.clear, in: .capsule)
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            isShowSheet = false
                        }
                    } label: {
                        Text("Fuggetaboutit")
                            .foregroundColor(.mwLavender)
                            .font(Fonts.Poppins.semiBold.swiftUIFont(size: 16))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                    }
                    .glassEffect(.clear, in: .capsule)
                }
                .padding(.top, 15)
                .padding(.horizontal, 15)
                
                Text("Finish Your Route")
                    .foregroundColor(.mwPurple)
                    .font(Fonts.Poppins.bold.swiftUIFont(size: 20))
                    .padding(.top, 15)
                
                InputTextFieldView(
                    type: .routeName,
                    text: $routeName,
                    isFocused: $routeNameFocus)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                
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

#Preview {
    @Previewable var isShowSheet = true
    
    FinishRouteView(
        viewModel: Container.shared.mapViewModel.callAsFunction(),
        isShowSheet: .constant(isShowSheet),
        startLocation: .init(),
        endLocation: .init(),
        recordedLocations: []
    )
}

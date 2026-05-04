//
//  RoutesView.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 18.02.2026.
//

import SwiftUI
import FactoryKit

struct RoutesView: View {
    @InjectedObservable(\.routesViewModel) var viewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewModel.routes.isEmpty {
                ContentUnavailableView(
                    "No Routes Yet",
                    systemImage: "map",
                    description: Text("Start recording to create your first route.")
                )
            } else {
                ScrollView(.vertical) {
                    VStack(spacing: 16) {
                        ForEach(viewModel.routes) { route in
                            RouteCardView(
                                route: route,
                                onTap: {
                                    // TODO: Navigate to route detail
                                    print("Route tapped: \(route.name)")
                                },
                                onDelete: {
                                    Task {
                                        await viewModel.delete(with: route.id)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 100) // Space for tab bar
                }
                .scrollIndicators(.hidden)
            }
        }
        .background(Color.mwBackground)
        .navigationTitle("Routes")
        .loadingOverlay($viewModel.isLoading)
        .task {
            await viewModel.getAllRoutes()
        }
    }
}

#Preview {
    let previewContainer = MapRouteDTO.preview
    
    Container.shared.modelContainer.register {
        previewContainer
    }
    
    return RoutesView()
        .modelContainer(previewContainer)

}

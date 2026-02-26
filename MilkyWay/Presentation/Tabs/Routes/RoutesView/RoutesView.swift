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
                    ForEach(viewModel.routes) { route in
                        createCard(for: route)
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationTitle("Routes")
        .loadingOverlay($viewModel.isLoading)
        .task {
            await viewModel.getAllRoutes()
        }
    }
}

// MARK: Views
private extension RoutesView {
    func createCard(for route: MapRoute) -> some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                Text(route.name)
                    .font(Fonts.Poppins.bold.swiftUIFont(size: 18))
                    .foregroundStyle(.black)
                
                Text(route.createdAt.formatted(.full))
                    .font(Fonts.Poppins.regular.swiftUIFont(size: 16))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button {
                Task {
                    await viewModel.delete(with: route.id)
                }
            } label: {
                Image(systemName: "minus.square.fill")
                    .foregroundStyle(.indigo)
            }
            
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.indigo, lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
    }
}

#Preview {
    RoutesView()
}

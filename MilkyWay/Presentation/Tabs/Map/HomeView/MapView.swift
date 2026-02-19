//
//  MapView.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import SwiftUI
import FactoryKit

struct MapView: View {
//    @EnvironmentObject var appCoordinator: Navigation<AppCoordinator>
//    @EnvironmentObject var coordinator: Navigation<MapFlowCoordinator>
    @CoordinatorLink var appCoordinator: AppCoordinator
    @CoordinatorLink var coordinator: MapFlowCoordinator
    
    @InjectedObservable(\.homeViewModel) var viewModel
    
    var body: some View {
        content
            .task {
                await viewModel.getPosts()
            }
            .navigationTitle(LS.Map.navTitle)
            .toolbar {
                ToolbarItem {
                    Button {
                        withAnimation {
                            coordinator.present(.modalDetails())
                        }
                    } label: {
                        Text(LS.Map.tryModal)
                            .foregroundStyle(.teal)
                            .font(Fonts.Poppins.medium.swiftUIFont(size: 14))
                    }
                }
                
                ToolbarItem {
                    Button {
                        withAnimation {
                            appCoordinator.handleLogOut()
                        }
                    } label: {
                        Text(LS.Map.logOut)
                            .foregroundStyle(.red)
                            .font(Fonts.Poppins.medium.swiftUIFont(size: 14))
                    }
                }
            }
            .loadingOverlay($viewModel.isLoading)
    }
}

// MARK: Private UI
private extension MapView {
    var content: some View {
        VStack {
            List(viewModel.posts) { post in
                Text(post.title)
                    .font(Fonts.Poppins.medium.swiftUIFont(size: 14))
                    .onTapGesture {
                        coordinator.present(.homeDetails(post))
                    }
            }
        }
    }
}

#Preview {
    MapView()
}


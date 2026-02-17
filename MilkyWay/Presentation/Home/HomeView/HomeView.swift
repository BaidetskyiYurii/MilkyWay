//
//  HomeView.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import SwiftUI
import FactoryKit

struct HomeView: View {
//    @EnvironmentObject var appCoordinator: Navigation<AppCoordinator>
//    @EnvironmentObject var coordinator: Navigation<HomeFlowCoordinator>
    @CoordinatorLink var appCoordinator: AppCoordinator
    @CoordinatorLink var coordinator: HomeFlowCoordinator
    
    @InjectedObservable(\.homeViewModel) var viewModel
    
    var body: some View {
        content
            .task {
                await viewModel.getPosts()
            }
            .navigationTitle(LS.Home.title)
            .toolbar {
                ToolbarItem {
                    Button {
                        withAnimation {
                            coordinator.present(.modalDetails())
                        }
                    } label: {
                        Text(LS.Home.tryModal)
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
                        Text(LS.Home.logOut)
                            .foregroundStyle(.red)
                            .font(Fonts.Poppins.medium.swiftUIFont(size: 14))
                    }
                }
            }
            .loadingOverlay($viewModel.isLoading)
    }
}

// MARK: Private UI
private extension HomeView {
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
    HomeView()
}


//
//  HomeView.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import SwiftUI
import FactoryKit

struct HomeView: View {
    @EnvironmentObject var appCoordinator: Navigation<AppCoordinator>
    @EnvironmentObject var coordinator: Navigation<HomeFlowCoordinator>
    
    @StateObject private var viewModel: HomeViewModel
    
    init(homeUseCase: HomeUseCaseProtocol) {
        _viewModel = StateObject(
            wrappedValue: HomeViewModel(
                homeUseCase: homeUseCase))
    }
    
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
                            coordinator().present(.modalDetails())
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
                            appCoordinator().handleLogOut()
                        }
                    } label: {
                        Text(LS.Home.logOut)
                            .foregroundStyle(.red)
                            .font(Fonts.Poppins.medium.swiftUIFont(size: 14))
                    }
                }
            }
            .onReceive(viewModel.$error) { error in
                guard let error else { return }
                
                coordinator().alert(LS.Common.error, message: error.localizedDescription) {
                    Button(LS.Common.ok) {
                        viewModel.error = nil
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
                        coordinator().present(.homeDetails(post))
                    }
            }
        }
    }
}

#Preview {
    @Injected(\.mockHomeUseCase) var mockHomeUseCase
    HomeView(homeUseCase: mockHomeUseCase)
}

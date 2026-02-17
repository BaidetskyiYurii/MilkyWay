//
//  SignInView.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 24.06.2025.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var appCoordinator: Navigation<AppCoordinator>
    @EnvironmentObject var signInCoordinator: Navigation<SignInCoordinator>
   
    var body: some View {
        Button {
            withAnimation {
                appCoordinator().handleSignIn()
            }
        } label: {
            Text(LS.SignIn.tapToSignIn)
        }
    }
}

#Preview {
    SignInView()
}

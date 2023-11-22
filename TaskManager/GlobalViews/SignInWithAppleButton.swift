//
//  SignInWithAppleButton.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 07.11.2023.
//

//import SwiftUI
//
//struct SignInWithAppleButton: View {
//    @Environment(\.colorScheme) var colorScheme
//
//    var body: some View {
//      if colorScheme.self == .dark {
//          SignInButton(SignInWithAppleButton.Style.whiteOutline)
//      }
//      else {
//          SignInButton(SignInWithAppleButton.Style.black)
//      }
//    }
//
//    func SignInButton(_ type: SignInWithAppleButton.Style) -> some View{
//        return SignInWithAppleButton(.signIn) { request in
//            request.requestedScopes = [.fullName, .email]
//        } onCompletion: { result in
//            switch result {
//            case .success(let authResults):
//                print("Authorisation successful \(authResults)")
//            case .failure(let error):
//                print("Authorisation failed: \(error.localizedDescription)")
//            }
//        }
//        .frame(width: 280, height: 60, alignment: .center)
//        .signInWithAppleButtonStyle(type)
//    }
//}
//
//#Preview {
//    SignInWithAppleButton()
//}

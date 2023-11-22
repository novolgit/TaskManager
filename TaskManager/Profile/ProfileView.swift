//
//  ProfileView.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 06.11.2023.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    var body: some View {
        #if os(macOS)
        ProfileForm()
            .labelsHidden()
            .frame(width: 400)
            .padding()
        #else
        NavigationView {
            ProfileForm()
        }
        #endif
    }
}

#Preview {
    ProfileView()
}

struct ProfileForm: View {
    @StateObject var viewModel = ProfileModel()
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    EditableCircularProfileImage(viewModel: viewModel)
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
            #if !os(macOS)
            .padding([.top], 10)
            #endif
            Section {
                TextField("First Name",
                          text: $viewModel.firstName,
                          prompt: Text("First Name"))
                TextField("Last Name",
                          text: $viewModel.lastName,
                          prompt: Text("Last Name"))
            }
            Section {
                TextField("About Me",
                          text: $viewModel.aboutMe,
                          prompt: Text("About Me"))
            }
        }
        .navigationTitle("Account Profile")
    }
}


//
//  SingUpView.swift
//  MiniMate
//
//  Created by Garrett Butchko on 2/6/25.
//


import SwiftUI

struct SignUpView: View {
    @StateObject var authViewModel: AuthViewModel
    @StateObject var viewManager: ViewManager
    
    @State private var confirmPassword = ""
    
    @State private var errorMessage: String?
    
    @State private var user = UserModel(name: "N/A", email: "", password: "")
    
    var body: some View {
        VStack() {
            
            HStack{
                // Close button
                Button(action: {
                    // Close the emergency view with animation
                    withAnimation {
                        viewManager.navigateToLogin()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial) // Semi-transparent circular background
                            .frame(width: 40, height: 40) // Size of the button
                        Image(systemName: "arrow.left")
                            .frame(width: 30, height: 30)
                            .fontWeight(.bold)
                    }
                }
                Spacer()
            }
            .padding(.bottom, 50)
            
            
            VStack{
                HStack{
                    Text("Sign Up")
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundStyle(.accent)
                    Spacer()
                    
                }
                HStack{
                    Text("If you are a new user, please sign up here.")
                        .font(.system(size: 20, weight: .light, design: .default))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .padding(.vertical, 30)
            
            VStack{
                HStack{
                    Text("Email")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .frame(height: 50)
                        .foregroundStyle(.secondary)
                    HStack{
                        Image(systemName: "envelope")
                            .foregroundStyle(.secondary)
                        TextField("example@example", text: $user.email)
                            .foregroundColor(.secondary)
                            .textSelection(.disabled)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding(.trailing, 5)
                            .ignoresSafeArea(.keyboard)
                    }
                    .padding(.leading)
                }
            }
            
            VStack{
                HStack{
                    Text("Password")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .frame(height: 50)
                        .foregroundStyle(.secondary)
                    HStack{
                        Image(systemName: "lock")
                            .foregroundStyle(.secondary)
                            .padding(.trailing, 5)
                        SecureField("123ABC", text: $user.password)
                            .foregroundStyle(.secondary)
                            .padding(.trailing, 5)
                            .ignoresSafeArea(.keyboard)
                    }
                    .padding(.leading, 20)
                }
            }
            
            VStack{
                HStack{
                    Text("Confirm Password")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .frame(height: 50)
                        .foregroundStyle(.secondary)
                    HStack{
                        Image(systemName: "lock")
                            .foregroundStyle(.secondary)
                            .padding(.trailing, 5)
                        SecureField("123ABC", text: $confirmPassword)
                            .foregroundStyle(.secondary)
                            .padding(.trailing, 5)
                    }
                    .padding(.leading, 20)
                }
            }
            
            
                Button {
                    if (user.password == confirmPassword){
                        authViewModel.createUser(email: user.email, password: user.password) { result in
                            switch result {
                            case .success(_):
                                errorMessage = nil
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Slight delay to ensure user is set
                                    authViewModel.saveUserData(user: user) { success in
                                        if success {
                                            withAnimation {
                                                viewManager.navigateToMain()
                                            }
                                        } else {
                                            errorMessage = "Failed to save user data."
                                        }
                                    }
                                }
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    } else {
                        errorMessage = "Passwords do not match."
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 150, height: 50)
                        Text("Sign Up")
                            .foregroundStyle(.white)
                    }
                }
                .padding(.top)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Spacer()
            
        }
        .padding()
    }
}

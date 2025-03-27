//
//  LoginPage.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/28/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var authViewModel: AuthViewModel
    @StateObject var viewManager: ViewManager
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    var body: some View {
        
        
        
        
        VStack(spacing: 20) {
        
            Spacer()
            
            VStack{
                HStack{
                    Text("Login")
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundStyle(.accent)
                    Spacer()
                    
                }
                HStack{
                    Text("If you are an existing user, please login here.")
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
                        TextField("example@example", text: $email)
                            .foregroundColor(.secondary)
                            .textSelection(.disabled)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding(.trailing, 5)
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
                        SecureField("123ABC", text: $password)
                            .foregroundStyle(.secondary)
                            .padding(.trailing, 5)
                    }
                    .padding(.leading, 20)
                }
            }
            
            
            HStack{
                HStack{
                    Button {
                        authViewModel.signInWithGoogle { result in
                            switch result {
                            case .success:
                                errorMessage = nil
                                withAnimation(){
                                    viewManager.navigateToMain()
                                }
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.ultraThinMaterial)
                            Image("google")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                
                VStack{
                    Button {
                        authViewModel.signIn(email: email, password: password) { result in
                            switch result {
                            case .success:
                                errorMessage = nil
                                withAnimation(){
                                    viewManager.checkUserStatus()
                                }
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 150, height: 50)
                            Text("Login")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Spacer()
            
            HStack{
                Text("If you are a new user")
                    .foregroundStyle(.secondary)
                Button {
                    withAnimation(){
                        viewManager.navigateToSignUp()
                    }
                } label: {
                    
                    Text("sign up here")
                }
            }
            
            HStack{
                Text("If you are a location")
                    .foregroundStyle(.secondary)
                Button {
                    withAnimation(){
                        viewManager.navigateToSignUpShelter()
                    }
                } label: {
                    Text("sign up here")
                }
            }
            
        }
        .padding()
    }
}


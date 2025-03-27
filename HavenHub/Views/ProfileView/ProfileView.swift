import SwiftUI

struct ProfileView: View {
    @StateObject var viewManager: ViewManager
    @StateObject var authViewModel: AuthViewModel

    @State var editProfile: Bool = false
    
    @State private var user : UserModel = UserModel(name: "", email: "", password: "")
    
    var body: some View {
        VStack {
            Capsule()
                .frame(width: 38, height: 6)
                .foregroundColor(.gray)
                .padding(10)
            
            Text("Profile")
                .frame(width: 250, height: 40)
                .font(.title)
                .foregroundColor(.primary)
                .fontWeight(.bold)
        }
        
        List {
            HStack {
                Text("Name:")
                if !editProfile {
                    Text(user.name) // Use @State variable
                } else {
                    TextField("Name", text: $user.name) // Bind to @State variable
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(.ultraThinMaterial)
                }
            }
            
            Text("Email: \(user.email)") // Show email from @State
            
            if authViewModel.user != nil {
                if !editProfile {
                    Button("Edit Profile") {
                        editProfile = true
                    }
                } else {
                    Button("Save") {
                        editProfile = false
                        authViewModel.saveUserData(user: user) { _ in }
                    }
                }
                
                Button("Logout") {
                    withAnimation {
                        viewManager.navigateToLogin()
                    }
                    authViewModel.logout()
                }
            } else {
                Button(action: {
                    withAnimation {
                        viewManager.navigateToLogin()
                    }
                }) {
                    Text("Login")
                }
            }
        }
        .onAppear {
            authViewModel.fetchUserData() { user in
                if let newUser = user {
                    self.user = newUser
                }
            }
        }
    }
}

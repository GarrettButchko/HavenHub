import SwiftUI

struct ShelterView: View {
    @StateObject var viewManager: ViewManager
    @StateObject var authViewModel: AuthViewModel

    @State var editProfile: Bool = false
    
    @State private var user = ShelterModel(id: "", name: "", contact: Contact(phone: "", email: ""), location: Location(address: "", city: "", state: "", zip: "", latitude: 0, longitude: 0), info: ShelterInfo(subtitle: "", description: "", capacity: 0, subType: ""), verified: true, password: "")
    
    var body: some View {
        VStack {
            Text("Location Profile")
                .frame(width: 250, height: 40)
                .font(.title)
                .foregroundColor(.primary)
                .fontWeight(.bold)
        }
        
        List {
            Section(header: Text("Info")) {
                HStack {
                    Text("Name:")
                    if !editProfile {
                        Text(user.name)
                    } else {
                        TextField("name", text: $user.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .background(.ultraThinMaterial)
                    }
                }
                HStack {
                    Text("Description:")
                    if !editProfile {
                        Text(user.info.description)
                    } else {
                        TextField("description", text: $user.info.description)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .background(.ultraThinMaterial)
                    }
                }
            }
            
            
            
            Section(header: Text("Location")) {
                HStack {
                    Text("Address:")
                    if !editProfile {
                        Text(user.location.address)
                    } else {
                        TextField("address", text: $user.location.address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .background(.ultraThinMaterial)
                    }
                }
                HStack {
                    Text("City:")
                    if !editProfile {
                        Text(user.location.city)
                    } else {
                        TextField("city", text: $user.location.city)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .background(.ultraThinMaterial)
                    }
                }
                HStack {
                    Text("Zip:")
                    if !editProfile {
                        Text(user.location.zip)
                    } else {
                        TextField("zip", text: $user.location.zip)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .background(.ultraThinMaterial)
                    }
                }
            }
            
            
            Section(header: Text("Contacts")) {
                HStack {
                    Text("Phone Number:")
                    if !editProfile {
                        Text(user.contact.phone)
                    } else {
                        TextField("phone", text: $user.contact.phone)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .background(.ultraThinMaterial)
                    }
                }
                
                Text("Email: \(authViewModel.user?.email ?? "No email")")
            }
            
            
            VStack{
                HStack{
                    Text("Capacity: \(Int(user.info.capacity) + 1)")
                    Spacer()
                }
            
                Slider(value: $user.info.capacity, in: 0...4, step: 1)
                    .onChange(of: user.info.capacity) { oldValue, newValue in
                        authViewModel.saveShelterData(user: user) { _ in }
                    }
            }
            
            
            if authViewModel.user != nil {
                if !editProfile {
                    Button("Edit Profile") {
                        editProfile = true
                    }
                } else {
                    Button("Save") {
                        editProfile = false
                        authViewModel.saveShelterData(user: user) { _ in }
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
            authViewModel.fetchShelterData() { user in
                if let newUser = user {
                    self.user = newUser
                }
            }
        }
    }
}


import SwiftUI
import CoreLocation

struct SignUpViewShelter: View {
    @StateObject var authViewModel: AuthViewModel
    @StateObject var viewManager: ViewManager
    
    @State private var coordinates: CLLocationCoordinate2D?
    @State private var errorMessage: String?
    
    @State private var shelter = ShelterModel(
        id: "",
        name: "",
        contact: Contact(phone: "", email: ""),
        location: Location(address: "", city: "", state: "", zip: "", latitude: 0, longitude: 0),
        info: ShelterInfo(subtitle: "", description: "", capacity: 0, subType: "Other"),
        verified: false,
        password: ""
    )
    
    var body: some View {
        VStack {
            HeaderView(viewManager: viewManager)
            
            ScrollView {
                ShelterInfoSection(shelter: $shelter)
                LocationSection(shelter: $shelter)
                ContactInfoSection(shelter: $shelter)
                PasswordSection(shelter: $shelter)
            }
            .frame(height: 300)
            
            SignUpButton(shelter: $shelter, authViewModel: authViewModel, errorMessage: $errorMessage, saveShelterData: saveShelterData)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()
        }
        .padding()
    }

    private func saveShelterData() {
        geocodeAddress(address: "\(shelter.location.address), \(shelter.location.city), \(shelter.location.state), \(shelter.location.zip)") { cords in
            if let cords = cords {
                shelter.location.latitude = cords.latitude
                shelter.location.longitude = cords.longitude
            }
            
            authViewModel.saveShelterData(user: shelter) { success in
                if success {
                    withAnimation {
                        viewManager.navigateText()
                    }
                } else {
                    errorMessage = "Failed to save user data."
                }
            }
        }
    }

    func geocodeAddress(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                completion(location.coordinate)
            } else {
                print("Error geocoding address: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    var viewManager: ViewManager
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    viewManager.navigateToLogin()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 40, height: 40)
                    Image(systemName: "arrow.left")
                        .frame(width: 30, height: 30)
                        .fontWeight(.bold)
                }
            }
            Spacer()
        }
        .padding(.bottom, 50)
        
        // Title
                    VStack(alignment: .leading) {
                        HStack{
                            Text("Shelter Sign Up")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.accent)
                            Spacer()
                        }
                        HStack{
                            Text("Register your shelter to connect with those in need.")
                                .font(.system(size: 20, weight: .light))
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        
                        
                    }
                    .padding(.vertical, 30)
    }
}

// MARK: - Shelter Info Section
struct ShelterInfoSection: View {
    @Binding var shelter: ShelterModel
    var subTypes: [String] = ["Shelter", "Food Bank", "Clinic/Health Center", "Clothing Center", "Other"]
    
    var body: some View {
        VStack(alignment: .leading) {
            inputField(title: "Shelter Name", text: $shelter.name, icon: "building.2")
            
            VStack(alignment: .leading) {
                Text("Subtype")
                    .foregroundStyle(.secondary)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .frame(height: 50)
                        .foregroundStyle(.secondary)
                    HStack {
                        Image(systemName: "list.bullet")
                            .foregroundStyle(.secondary)
                        Picker("Subtype", selection: $shelter.info.subType) {
                            ForEach(subTypes, id: \.self) { subtype in
                                Text(subtype)
                            }
                        }
                        Spacer()
                    }
                    .padding(.leading)
                }
            }
        }
    }
}

// MARK: - Location Section
struct LocationSection: View {
    @Binding var shelter: ShelterModel
    
    var body: some View {
        Group {
            inputField(title: "Address", text: $shelter.location.address, icon: "map")
            inputField(title: "City", text: $shelter.location.city, icon: "building.2")
            inputField(title: "State", text: $shelter.location.state, icon: "flag")
            inputField(title: "Zip Code", text: $shelter.location.zip, icon: "number")
        }
    }
}

// MARK: - Contact Info Section
struct ContactInfoSection: View {
    @Binding var shelter: ShelterModel
    
    var body: some View {
        Group {
            inputField(title: "Phone Number", text: $shelter.contact.phone, icon: "phone", keyboard: .phonePad)
            inputField(title: "Email", text: $shelter.contact.email, icon: "envelope", keyboard: .emailAddress)
        }
    }
}

// MARK: - Password Section
struct PasswordSection: View {
    @Binding var shelter: ShelterModel
    
    var body: some View {
        secureInputField(title: "Password", text: $shelter.password, icon: "lock")
    }
}

// MARK: - Sign Up Button
struct SignUpButton: View {
    @Binding var shelter: ShelterModel
    var authViewModel: AuthViewModel
    @Binding var errorMessage: String?
    var saveShelterData: () -> Void
    
    var body: some View {
        Button {
            if shelter.name.isEmpty || shelter.contact.email.isEmpty || shelter.password.isEmpty || shelter.location.address.isEmpty || shelter.location.city.isEmpty || shelter.location.state.isEmpty || shelter.location.zip.isEmpty || shelter.contact.phone.isEmpty {
                errorMessage = "All fields are required."
                return
            }
            
            authViewModel.createUser(email: shelter.contact.email, password: shelter.password) { result in
                switch result {
                case .success(_):
                    errorMessage = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        saveShelterData()
                    }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 150, height: 50)
                    .foregroundStyle(.accent)
                Text("Sign Up")
                    .foregroundStyle(.white)
                    .font(.headline)
            }
        }
        .padding(.top)
    }
}

// MARK: - Helper Views for Text Fields
@ViewBuilder
private func inputField(title: String, text: Binding<String>, icon: String, keyboard: UIKeyboardType = .default) -> some View {
    VStack(alignment: .leading) {
        Text(title)
            .foregroundStyle(.secondary)
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .frame(height: 50)
                .foregroundStyle(.secondary)
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                TextField(title, text: text)
                    .autocapitalization(.none)
                    .keyboardType(keyboard)
                    .padding(.trailing, 5)
                    .foregroundColor(.primary)
            }
            .padding(.leading)
        }
    }
}

@ViewBuilder
private func secureInputField(title: String, text: Binding<String>, icon: String) -> some View {
    inputField(title: title, text: text, icon: icon)
}

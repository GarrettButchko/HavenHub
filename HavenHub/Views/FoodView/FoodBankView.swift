import SwiftUI
import MapKit

struct FoodBankView: View {
//    @Binding var visibleRegion: MKCoordinateRegion?
//    @Binding var shelters: [MKMapItem]
//    @Binding var showBottomSheet: Bool
//    @Binding var showFoodBank: Bool
//    @Binding var showTitle: Bool
//    @State private var isKeyboardVisible: Bool = false
//    @State var offsetY: CGFloat = 540
//    @State var lastDragPosition: CGFloat = 0
    @StateObject var viewManager: ViewManager
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer() // Push the list to the bottom
                
                VStack(spacing: 0) {
                    Capsule()
                        .frame(width: 40, height: 6)
                        .foregroundColor(.gray)
                        .padding(10)
                    
                    List(viewManager.shelters, id: \.self) { shelter in
                        NavigationLink(destination: FoodBankDetailView(shelter: shelter)) {
                            VStack(alignment: .leading) {
                                Text(shelter.name ?? "Unnamed Food Bank")
                                    .font(.headline)
                                Text(shelter.placemark.title ?? "Address unavailable")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: geometry.size.height * 0.4) // Restrict the list to 40% of the screen height
                    
                    Button(action: {
                        withAnimation {
//                            showFoodBank = false
//                            showBottomSheet = true
                            viewManager.navigateToMain()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 70, height: 70)
                            
                            Text("X")
                                .font(.system(size: 25))
                                .foregroundStyle(Color.primary)
                        }
                    }
                    .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.sub)
                        .shadow(radius: 10)
                )
            }
        }
    }
}

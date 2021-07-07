

import SwiftUI
import MapKit

struct LocationView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @State private var landmarks: [Landmark] = [Landmark]()
    @State private var search: String = ""
    @State private var tapped: Bool = false
    @Environment(\.presentationMode) var presentation
    
    private func getNearByLandmarks() {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
                
                let mapItems = response.mapItems
                self.landmarks = mapItems.map {
                    Landmark(placemark: $0.placemark)
                }
                
            }
            
        }
        
    }
    
    func calculateOffset() -> CGFloat {
        
        if self.landmarks.count > 0 && !self.tapped {
            return UIScreen.main.bounds.size.height - UIScreen.main.bounds.size.height / 4
        }
        else if self.tapped {
            return 100
        } else {
            return UIScreen.main.bounds.size.height
        }
    }
    
    var body: some View {
        
        Button(action: {
            presentation.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.gray)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
        })


        
     /*   NavigationLink(destination: HomeView(), label: {
            Image(systemName: "arrow.left")
                .foregroundColor(Color.green)
                .padding()
                .clipShape(Circle())
                
        })*/
        
        ZStack(alignment: .top) {
            
            MapView(landmarks: landmarks)
            
            TextField("Search", text: $search, onEditingChanged: { _ in })
            {
                // commit
                self.getNearByLandmarks()
            }.textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .offset(y: 44)
            
            PlaceListView(landmarks: self.landmarks) {
                // on tap
                self.tapped.toggle()
            }.animation(.spring())
                .offset(y: calculateOffset())
            
        }
    }
}

struct Location_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}

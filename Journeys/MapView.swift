//
//  MapView.swift
//  Journeys
//
//  Created by Luke Inger on 13/07/2020.
//

import SwiftUI
import MapKit


struct MapView: View {
    
    @EnvironmentObject var locations: Locations
    @ScaledMetric var frame: CGFloat = 80
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40))
    
    var body: some View {
        
        Map(coordinateRegion: $region, annotationItems: locations.places) { location in
            MapAnnotation(coordinate: location.coordinate){
                
                NavigationLink(destination: DiscoverView(location: location)){
                    Image(location.country)
                        .renderingMode(.original)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .frame(width: frame, height: frame/2)
            }
        }

    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MapView()
        }
    }
}

//
//  DiscoverView.swift
//  Journeys
//
//  Created by Paul Hudson on 06/07/2020.
//

import AVKit
import MapKit
import SwiftUI
import VisualEffects

struct DiscoverView: View {
    
    @State private var region: MKCoordinateRegion
    @State private var disclosureShowing = false
    @State private var selectedPicture: String?
    
    @Namespace var animation
    
    let location: Location
    
    init(location: Location){
        
        self.location = location
        
        _region = State(wrappedValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))
    }
    
    let manager = CLLocationManager()

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Image(location.heroPicture)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: geo.size.width)
                    .frame(height: geo.size.height * 0.7)

                ScrollView(showsIndicators: false) {
                    Spacer().frame(height: geo.size.height * 0.35)

                    HStack {
                        Text(location.name)
                            .font(.system(size: 48, weight: .bold))
                            .bold()
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(1), radius: 5)

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(location.country)
                                .font(.title)
                                .bold()
                            Spacer()

                            Button {
                                print("Bookmarked")
                            } label: {
                                Image(systemName: "heart")
                                    .font(.title)
                                    .padding(20)
                                    .background(Circle().fill(Color.white))
                                    .shadow(radius: 10)
                            }
                            .offset(y: -40)
                        }
                        .padding(.horizontal, 20)
                        
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            LazyHStack{
                                ForEach(location.pictures, id: \.self) { picture in
                                    if picture == selectedPicture{
                                        //Dont show the picture
                                        Color.clear.frame(width: 150)
                                    } else {
                                        Image(picture)
                                            .resizable()
                                            .frame(width: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                            .matchedGeometryEffect(id: picture, in: animation)
                                            .onTapGesture {
                                                withAnimation(.interactiveSpring()){
                                                    selectedPicture = picture
                                                }
                                            }
                                    }
                                }
                            }
                            .frame(height: 100)
                            .padding([.horizontal, .bottom], 20)
                        }
                        .transition(.none)
                        
                        VStack(alignment: .leading) {
                            Text(location.description)
                                .fixedSize(horizontal: false, vertical: true)

                            Text("Don't miss")
                                .font(.title3)
                                .bold()
                                .padding(.top, 20)

                            Text(location.more)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Map(coordinateRegion: $region, interactionModes: [])
                                .frame(height: 300)
                            
                            if location.advisory.isEmpty == false {
                                DisclosureGroup("Travel Advisories", isExpanded:$disclosureShowing){
                                    Text(location.advisory)
                                }.onTapGesture {
                                    withAnimation {
                                        disclosureShowing.toggle()
                                    }
                                }
                            }
 
                            
                        }.onAppear {
                            manager.requestWhenInUseAuthorization()
                        }
                        
                        .padding(.horizontal, 20)
                        .padding(.bottom, 50)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("Background"))
                    )
                }
                
                //Overlay
                if let picture = selectedPicture {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ZStack(alignment: .topTrailing) {
                                Image(picture)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: .infinity)
                                    .matchedGeometryEffect(id: picture, in: animation)
                                
                                Button {
                                    withAnimation {
                                        selectedPicture = nil
                                    }
                                } label : {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.largeTitle)
                                        .padding(2)
                                        .background(Color.black)
                                        .clipShape(Circle())
                                }
                                .padding()
                                .offset(x: -10, y: 30)
                            }
                            
                            Text("Title")
                        }
                    }
                    .background(
                        VisualEffectBlur(blurStyle: .systemThinMaterial)
                    )
                    .zIndex(100)
                }
            }
        }
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension AnyTransition {
    struct NoneModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
        }
    }
    
    static var none: AnyTransition {
        AnyTransition.modifier(
            active: NoneModifier(),
            identity: NoneModifier()
        )
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView(location: Location.example)
    }
}

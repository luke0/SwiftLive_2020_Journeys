//
//  PicksView.swift
//  Journeys
//
//  Created by Paul Hudson on 06/07/2020.
//

import SwiftUI

struct PicksView: View {
    
    @EnvironmentObject var locations: Locations
    
    var layout = [
        GridItem(.adaptive(minimum: 160))
    ]

    var body: some View {
        ScrollView{
            TabView(){
                ForEach(1..<9) { i in
                    GeometryReader { geo in
                        Image("photo\(i)")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width)
                            .clipped()
                    }
                }
            }
            .frame(height: 300)
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            VStack(){
                Text("Locations")
                LazyVGrid(columns: layout){
                    ForEach(locations.places) { place in
                        NavigationLink(
                            destination: DiscoverView(location: place),
                            label: {
                                VStack(){
                                    Image(place.country)
                                        .renderingMode(.original)
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 5, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                                        
                                        .overlay(
                                            Text(place.name)
                                                .font(.headline)
                                                .foregroundColor(Color.black)
                                                .padding(5)
                                            , alignment: .bottom)
                                }
                            })
                    }
                }
            }

        }
        .background(Color(white: 0.95))
        .navigationTitle("Our Top Picks")
    }
}

struct PicksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PicksView()
        }
        .environmentObject(Locations())
    }
}

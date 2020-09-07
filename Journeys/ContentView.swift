//
//  ContentView.swift
//  Journeys
//
//  Created by Paul Hudson on 06/07/2020.
//

import SwiftUI

//Scrolling stack of picture under the title

//

struct ContentView: View {
    @EnvironmentObject var locations: Locations
    @Environment (\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        
        if sizeClass == .compact {
            TabView {
                DiscoverView(location: locations.primary)
                    .tabItem {
                        Label("Discover", systemImage: "airplane.circle.fill")
                    }

                NavigationView {
                    PicksView()
                }
                .tabItem {
                    Label("Picks", systemImage: "star.fill")
                }
                
                NavigationView {
                    MapView()
                }
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }

                NavigationView {
                    TipsView()
                }
                .tabItem {
                    Label("Tips", systemImage: "list.bullet")
                }
            }
        } else {
            NavigationView {
                List {
                    NavigationLink(
                        destination: DiscoverView(location: locations.primary)){
                        Label("Discover", systemImage: "airplane.circle.fill")
                    }
                    NavigationLink(
                        destination: PicksView()){
                        Label("Picks", systemImage: "star.fill")
                    }
                    NavigationLink(
                        destination: MapView()){
                        Label("Map", systemImage: "map.fill")
                    }
                    NavigationLink(
                        destination: TipsView()){
                        Label("Tips", systemImage: "list.bullet")
                    }
                }
                .navigationTitle("Journeys")
                .listStyle(SidebarListStyle())
                
                DiscoverView(location: locations.primary)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

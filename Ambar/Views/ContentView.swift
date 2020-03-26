//
//  ContentView.swift
//  Ambar
//
//  Created by Anagh Sharma on 12/11/19.
//  Copyright © 2019 Golden Chopper. All rights reserved.
//

import SwiftUI
import AppKit


struct ContentView: View {
    
    init() {
        
    }
    
    var plugins:[Plugin] {
        get {
            return PluginManager.default.loadPlugins()
        }
    }
    
    var preferences = MenuButton("+") {
        
        Button("change plugin folder") {
            PluginManager.default.pickPluginDirectory()
        }
    }
    
    var body: some View {

        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 10) {
                Text("Ambar").frame(width: 280.0, height: 20.0, alignment: .center)
                preferences
            }
            
            Divider().frame(width: 300, height: 2, alignment: .leading).foregroundColor(.white)

            List(plugins,id: \.id) { plugin in
                PluginRow(plugin: plugin)
            }

        }.frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment:.leading)
    }
    
}
    
struct PluginRow: View {
    var plugin: Plugin

    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Text(plugin.name).font(Font.system(size: 14.0))
                .fontWeight(.regular)
                .padding(.horizontal, 12.0)
                .frame(minWidth: 100, idealWidth: 200, maxWidth: 220, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
//                .frame(width: 250, height: 30 , alignment: .leading)
            
            MenuButton("+") {
                Text("xxxx")
                Button("refresh") {

                }

                ForEach(plugin.getResult(), id: \.self) { result in
                    Button(result) {
                        print("Create new contact")
                    }
                }
            }.frame(minWidth: 20, idealWidth: 40, maxWidth: 80, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
        }
//        frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
    }
}

struct LandmarkDetail:View {
    var body: some View {
        Text("Landmarks")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

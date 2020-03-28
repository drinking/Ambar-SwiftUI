//
//  ContentView.swift
//  Cuber
//
//  Created by Anagh Sharma on 12/11/19.
//  Copyright © 2019 Golden Chopper. All rights reserved.
//

import SwiftUI
import AppKit
import Combine


struct ContentView: View {
    
    init() {
        
    }
    
    var plugins:[Plugin] {
        get {
            return PluginManager.default.loadPlugins()
        }
    }
    
    var preferences = MenuButton("+") {
        
        Button("Refresh All") {
            PluginManager.default.refreshAll()
        }
        
        Button("Change Plugin Folder") {
            PluginManager.default.pickPluginDirectory()
        }
        
        Button("Quit") {
            NSApp.terminate(NSApplication.shared)
        }
        
    }
    
    var body: some View {

        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .trailing) {
                Text("Cuber").frame(width: 260.0, height: 20.0, alignment: .center).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                preferences.frame(width: 30, height: 30, alignment: .center)
            }
            
            Divider().frame(width: 300, height: 2, alignment: .leading).foregroundColor(.white)

            List(plugins,id: \.id) { plugin in
                PluginRow(plugin: plugin)
            }

        }.frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment:.leading)
    }
    
}
    
struct PluginRow: View {
    @ObservedObject var plugin: Plugin
    @State var spin = false

    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Text(plugin.name).font(Font.system(size: 14.0))
                .fontWeight(.regular)
                .padding(.horizontal, 12.0)
                .frame(minWidth: 100, idealWidth: 200, maxWidth: 220, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
            
            
            if(self.plugin.executing) {
                Image("icon_wait").rotationEffect(.degrees(spin ? 360:0))
                    .animation(Animation.linear(duration: 2.0)
                        .repeatForever(autoreverses: false))
                    .onAppear() {
                        self.spin.toggle()
                }
            }else {
                
                MenuButton(label:Image("icon_item_settings")) {
                    
                    ForEach(plugin.result, id: \.self) { result in
                        Group {
                            if result == "---" {
                                Text("-----").foregroundColor(.gray).frame(width: 100, height: 3, alignment: .leading)
                            }else {
                                Button(result) {
                                    print("Create new contact")
                                }
                            }
                        }
                            
                    }
                }.menuButtonStyle(BorderlessButtonMenuButtonStyle())
                .frame(minWidth: 20, idealWidth: 20, maxWidth: 20, minHeight: nil, idealHeight: nil, maxHeight: 20, alignment: .center)
            }
            

        }
        

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

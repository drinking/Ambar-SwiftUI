//
//  PluginManager.swift
//  Ambar
//
//  Created by drinking on 2020/3/26.
//  Copyright © 2020 Golden Chopper. All rights reserved.
//

import Foundation
import AppKit

let kPluginDirectory = "pluginDirectory"

class Plugin :Identifiable {
    
    let id : Int
    let name : String
    let path : String
    
    init(id:Int,name:String,path:String) {
        self.id = id
        self.name = name
        self.path = path
    }
    
    var result:[String] = []
    var executing = false
    
    func getResult() -> [String] {
        
        if result.count == 0 && !executing {
            executing = true
            DispatchQueue.global(qos: .background).async {
                
                self.result = executePlugin(plugin: self)
                self.executing = false
                DispatchQueue.main.async {
                    //to do somthing
                    print("This is run on the main queue, after the previous code in outer block")
                }
            }
            return ["loading"]
        }
        
     
        return result
    }
    
}



class PluginManager:NSObject,NSOpenSavePanelDelegate {
    
    
    
    
    var pluginDirectory:String? {
        get {
             UserDefaults.standard.string(forKey: kPluginDirectory)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: kPluginDirectory)
        }
    }
    
    let panel = NSOpenPanel()
    
    static let `default` = PluginManager()
    
    
    func pickPluginDirectory() {
        
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.prompt = "Use as Plugins Directory"
        panel.title = "Select BitBar Plugins Directory"
        if panel.runModal() == .OK {
            
            guard let path = panel.url?.path else {
                // error popup
                return
            }
            
            pluginDirectory = path
            _ = loadPlugins()
        }
        
    }
    
    var plugins:[Plugin]?
    
    func loadPlugins() -> [Plugin] {
        
        if let pls = self.plugins {
            return pls
        }
        
        guard let path = PluginManager.default.pluginDirectory else {
            return []
        }
        
        do {
            let urls = try FileManager.default.contentsOfDirectory(atPath: path)
            
            self.plugins = urls.filter { (url) -> Bool in
                return url.contains(".sh") || url.contains(".py")
            }.enumerated().map { (index,element) -> Plugin in
                return Plugin(id: index, name: element, path: "\(path)/\(element)")
            }
            return self.plugins!
        } catch {
             print("Error:", error)
        }
        
        return []
    }
    
    
}

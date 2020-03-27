//
//  PluginManager.swift
//  Cuber
//
//  Created by drinking on 2020/3/26.
//  Copyright © 2020 Golden Chopper. All rights reserved.
//

import Foundation
import AppKit
import Combine

let kPluginDirectory = "pluginDirectory"

class Plugin :Identifiable, ObservableObject{
    
    let objectWillChange = PassthroughSubject<Void, Never>()

    
    let id : Int
    let name : String
    let path : String
    
    init(id:Int,name:String,path:String) {
        self.id = id
        self.name = name
        self.path = path
        result = []
    }
    
    var result:[String] {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    var executing = false
    
    func execute() {
        if result.count == 0 && !executing {
            executing = true
            DispatchQueue.global(qos: .background).async {
                 let result = executePlugin(plugin: self)
                DispatchQueue.main.async {
                    self.executing = false
                    self.result = result
                }
            }
        }
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
            refreshAll()
            return self.plugins!
        } catch {
             print("Error:", error)
        }
        
        return []
    }
    
    func refreshAll() {
        self.plugins?.forEach({ (plugin) in
            plugin.result = []
            plugin.execute()
        })
    }
    
    
}

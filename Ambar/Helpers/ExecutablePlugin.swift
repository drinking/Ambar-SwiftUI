//
//  ExecutablePlugin.swift
//  Ambar
//
//  Created by drinking on 2020/3/26.
//  Copyright © 2020 Golden Chopper. All rights reserved.
//

import Foundation
import Cocoa

func executePlugin(plugin:Plugin?) -> [String] {
    do {
        guard let p = plugin?.path else {
            return ["No executable files"]
        }
            
        let task = Process()
        let pipe = Pipe()

        task.executableURL = URL(fileURLWithPath: p)
//            task.arguments = ["-la","/Users/"] //multiple options
        task.standardOutput = pipe
        try task.run()

        let handle = pipe.fileHandleForReading
        let data = handle.readDataToEndOfFile()
        let printing = String (data: data, encoding: String.Encoding.utf8)
        if let output = printing?.split(whereSeparator: { $0.isNewline }).map({ (sub) -> String in
            String(sub)
        }) {
            return output
        }
        return ["Split error \(printing)"]
    } catch let e {
        return ["Execute error \(e)"]
    }
        
    return []
}


//
//  main.swift
//  UnusedImportRemover
//
//  Created by Kenneth Parker Ackerson on 9/18/18.
//  Copyright © 2018 Kenneth Ackerson. All rights reserved.
//

import Foundation

// The path of the project you want to run this on
let path = "/Users/Ken/Dev/APPNAME"

// The command to build your project - you can really use anything that uses reasonable exit codes but this command should build most iOS projects that use workspaces, after you replace APPNAME with your information
let command = "cd \(path) && xcodebuild ARCHS=arm64 ONLY_ACTIVE_ARCH=YES -configuration Debug -workspace ./APPNAME.xcworkspace -scheme APPNAME"



@discardableResult
private func shell(_ args: String) -> (String, Int32) {
    var outstr = ""
    let task = Process()
    task.launchPath = "/bin/sh"
    task.arguments = ["-c", args]
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    if let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
        outstr = output as String
    }
    task.waitUntilExit()
    
    return (outstr, task.terminationStatus)
}

//

let fileManager = FileManager.default
let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: path)!

for element in enumerator {
    //do something
    if let d = element as? String, d.contains(".swift") || d.contains(".m") || d.contains(".h"), !d.contains("Tests"), !d.contains("build/"), !d.contains("Pods") {
        print(d)
        let url = URL.init(fileURLWithPath: "\(path)/\(d)")
        let strings = try! String(contentsOf: url).split(separator: "\n", omittingEmptySubsequences: false)
        
        var i = 0
        var temporaryStrings = strings

        for s in strings {
            if s.count >= 7 &&
                (s[s.utf8.startIndex..<s.utf8.index(s.utf8.startIndex, offsetBy: 6)] == "import" ||
                    s[s.utf8.startIndex..<s.utf8.index(s.utf8.startIndex, offsetBy: 7)] == "#import"
                    ){
                print(s)
                temporaryStrings.remove(at: i)
                i -= 1
                let string = temporaryStrings.joined(separator: "\n")
                try! string.write(to: url, atomically: true, encoding: .utf8)
                let result = shell(command)
                if result.1 != 0 {
                    i+=1
                    temporaryStrings.insert(s, at: i)
                    let string = temporaryStrings.joined(separator: "\n")
                    try! string.write(to: url, atomically: true, encoding: .utf8)
                }
                
            }
            i+=1

        }
    }
    
}



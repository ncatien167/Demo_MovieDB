//
//  Logger.swift
//  BaseStructure
//
//  Created by Phong Cao on 6/1/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

enum LogEvent: String{
    
    case error = "[🔥]"
    case info = "[ℹ️]"
    case debug = "[💬]"
    case warning = "[⚠️]"
    
}

final class Logger {
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!.replacingOccurrences(of: ".swift", with: "")
    }

    
    class func log(message: String,event: LogEvent, fileName: String = #file, line: Int = #line, funcName: String = #function){
        
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd hh:mm"
        let dateStr = date.string(from: Date())
        print("\(dateStr) \(event.rawValue) [\(sourceFileName(filePath: fileName)).\(funcName)] [\(line)]: \(message)")
        
    }
    
}

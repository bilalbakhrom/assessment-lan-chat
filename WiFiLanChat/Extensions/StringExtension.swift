//
//  String+Ext.swift
//  WiFiLanChat
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import Foundation

extension String {
    var isBackSpace: Bool {
        strcmp(self.cString(using: .utf8)!, "\\b") == -92
    }
    
    var isIPAddr: Bool {
        guard self.filter({ $0 == "." }).count == 3 else {
            return false
        }
        
        let newString = self.replacingOccurrences(of: ".", with: "")
        let characterSet = CharacterSet(charactersIn: newString)
        
        return CharacterSet.decimalDigits.isSuperset(of: characterSet)
    }
    
    func withoutWhitespace() -> String {
        replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\0", with: "")
    }
}

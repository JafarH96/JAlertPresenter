//
//  AlertError.swift
//
//
//  Created by jafar heidari on 12/3/23.
//

import Foundation

public enum JAlertError: String, LocalizedError {
    case alertExists = "Alert already added"
    case unknown = "Unknown"
    
    public var errorDescription: String? {
        return self.rawValue
    }
}

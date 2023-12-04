//
//  JAlertPriority.swift
//
//
//  Created by jafar heidari on 12/3/23.
//

import Foundation

public enum JAlertPriority: UInt8, Comparable {
    case highest = 0
    case high = 1
    case normal = 2
    case low = 3
    case veryLow = 4
    
    var order: UInt8 {
        return self.rawValue
    }
    
    public static func < (lhs: JAlertPriority, rhs: JAlertPriority) -> Bool {
        return lhs.order > rhs.order
    }
    
    public static func == (lhs: JAlertPriority, rhs: JAlertPriority) -> Bool {
        return lhs.order == rhs.order
    }
}

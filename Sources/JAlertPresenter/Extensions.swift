//
//  Extensions.swift
//
//
//  Created by jafar heidari on 12/3/23.
//

import UIKit

extension Dictionary where Key == UUID, Value == JAlertQueueStructure {
    var presentedAlertID: UUID? {
        for (key, value) in self {
            if value.state == .presenting { return key }
        }
        return nil
    }
    
    var presentedAlert: Value? {
        return values.filter { $0.state == .presenting }.last
    }
    
    var highestOrderAlert: Value? {
        return self.values.sorted(by: {$0 < $1}).last
    }
    
    var anyAlertIsPresenting: Bool {
        return values.filter { $0.state == .presenting }.count > 0
    }
    
    var currentAlert: Value? {
        return values.filter { $0.state == .presenting }.last
    }
}


extension UIAlertController {
    public func getJUIAlertController()-> JUIAlertController {
        return JUIAlertController(title: self.title, message: self.message, preferredStyle: self.preferredStyle)
    }
}

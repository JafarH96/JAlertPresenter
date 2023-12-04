//
//  JAlertQueueStructure.swift
//
//
//  Created by jafar heidari on 12/3/23.
//

import UIKit

public class JAlertQueueStructure: Comparable {
    let priority: JAlertPriority
    var state: JAlertStructureState
    var alert: JUIAlertController
    let completion: (()-> Void)?
    
    public init(priority: JAlertPriority, state: JAlertStructureState, alert: JUIAlertController, completion: (() -> Void)? = nil) {
        self.priority = priority
        self.state = state
        self.alert = alert
        self.completion = completion
    }
    
    public static func < (lhs: JAlertQueueStructure, rhs: JAlertQueueStructure) -> Bool {
        return lhs.priority < rhs.priority
    }
    
    public static func == (lhs: JAlertQueueStructure, rhs: JAlertQueueStructure) -> Bool {
        return lhs.priority == rhs.priority
    }
}

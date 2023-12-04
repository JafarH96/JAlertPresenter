//
//  JUIAlertController.swift
//  
//
//  Created by jafar heidari on 12/3/23.
//

import UIKit

public class JUIAlertController: UIAlertController {

    static let notificationKey = Notification.Name("606C4886-9C85-424D-AF69-9D4C6295D7C6")
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        restorationIdentifier = UUID().uuidString
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        restorationIdentifier = UUID().uuidString
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(
            name: Self.notificationKey,
            object: self,
            userInfo: ["ID": restorationIdentifier!]
        )
    }
}

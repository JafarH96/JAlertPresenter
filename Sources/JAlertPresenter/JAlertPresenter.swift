// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public class JAlertPresenter: NSObject {
    
    /// The priority queue that stores the alert controllers that will be presented
    public private(set) var alertQueue: [UUID: JAlertQueueStructure] = [:]
    /// The root view controller that the alert controllers will be present on it
    public private(set) weak var rootViewController: UIViewController?
    
    
    public required init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(alertDismissedNotification),
            name: JUIAlertController.notificationKey,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /// Add the alert controller to the priority queue and present it
    /// - Parameters:
    ///   - alert: `JUIAlertController`
    ///   - priority: The priority of the presentation
    ///   - completion: Trigger when the alert presented
    /// - Returns: `True` on success, `JAlertError` on failure
    @discardableResult public func present(_ alert: JUIAlertController, priority: JAlertPriority = .normal, completion: @escaping ()-> Void)-> (Bool, JAlertError?) {
        let key = UUID(uuidString: alert.restorationIdentifier!)!
        guard !alertQueue.keys.contains(key) else { return (false, .alertExists) }
        let structure = JAlertQueueStructure(priority: priority, state: .inQueue, alert: alert, completion: completion)
        
        alertQueue[key] = structure
        refresh()
        
        return (true, nil)
    }
    
    /// Dismiss the alert controller that is presenting or added to the queue
    /// - Parameter alert: `JUIAlertController`
    public func dismiss(_ alert: UIAlertController) {
        let key = UUID(uuidString: alert.restorationIdentifier!)!
        guard alertQueue.keys.contains(key) else { return }
        dismiss(key)
    }
    
    /// Dismiss the alert controller with the specific restoration identifier
    /// - Parameter id: Restoration identifier of the view controller in UUID string format
    public func dismiss(restorationIdentifier id: String) {
        guard let key = UUID(uuidString: id) else { return }
        guard alertQueue.keys.contains(key) else { return }
        dismiss(key)
    }
    
}


extension JAlertPresenter {
    
    private func refresh() {
        for (key, value) in alertQueue {
            if value.state == .presented {
                alertQueue.removeValue(forKey: key)
            }
        }
        
        if alertQueue.count == 1, let alert = alertQueue.values.first, alert.state == .inQueue {
            alert.state = .presenting
            present(alert.alert)
            return
        }
        
        if let alert = alertQueue.highestOrderAlert, alert.state == .inQueue {
            if let presentedAlert = alertQueue.currentAlert {
                if presentedAlert >= alert {
                    return
                }
                
                presentedAlert.state = .inQueue
                presentedAlert.alert.dismiss(animated: true) {[weak self] in
                    guard let self else { return }
                    alert.state = .presenting
                    present(alert.alert)
                }
                return
            }
            alert.state = .presenting
            present(alert.alert)
        }
    }
    
    private func updateState(_ key: UUID, newState: JAlertStructureState) {
        self.alertQueue[key]?.state = newState
        refresh()
    }
    
    private func present(_ alert: UIViewController) {
        DispatchQueue.main.async {
            let currentKey = UUID(uuidString: alert.restorationIdentifier!)!
            if let presented = self.rootViewController?.presentedViewController {
                if let restorationIdentifier = presented.restorationIdentifier {
                    if let previousKey = UUID(uuidString: restorationIdentifier) {
                        self.alertQueue[previousKey]?.state = .inQueue
                    }
                }
                if (presented is UIAlertController) || (presented is JUIAlertController) {
                    presented.dismiss(animated: false) {
                        self.rootViewController?.present(alert, animated: true, completion: self.alertQueue[currentKey]?.completion)
                    }
                } else {
                    presented.present(alert, animated: true, completion: self.alertQueue[currentKey]?.completion)
                }
            } else {
                self.rootViewController?.present(alert, animated: true, completion: self.alertQueue[currentKey]?.completion)
            }
        }
    }
    
    private func dismiss(_ key: UUID) {
        DispatchQueue.main.async {[weak self] in
            guard let self else { return }
            if let alert = alertQueue[key], alert.state == .presenting {
                alert.alert.dismiss(animated: true)
            } else {
                alertQueue.removeValue(forKey: key)
            }
        }
    }
    
    @objc private func alertDismissedNotification(_ notification: NSNotification) {
        guard let id = notification.userInfo?["ID"] as? String, let key = UUID(uuidString: id) else { return }
        if let alert = alertQueue[key], alert.state != .inQueue {
            updateState(key, newState: .presented)
        }
    }
    
}

# JAlertPresenter

Present the app's alert controllers with prioritization without any conflicts or missing. 

## Quick sample

### Presenting an Alert Controller

When you send an alert controller to present, there are three possible states:
 - If no controller is being presented, the sent controller will be presented.
 - If a controller with a higher priority is being presented, the sent controller will be placed in a priority queue and will be presented after the higher priority controllers are presented.
 - If a controller with a lower priority is being presented, first that controller will be dismissed and the newer controller will be presented instead, and then the controller with the lower priority will be presented again.

```swift
import JAlertPresenter

// The root view controller that must present the alerts
let presenter = JAlertPresenter(rootViewController: self)

let alert1 = JUIAlertController(title: "High", message: "High priority alert", preferredStyle: .alert)
let action1 = UIAlertControllerAction(title: "Dismiss")
alert1.addAction(action1)

presenter.present(alert1, priority: .high) {
    print("High priority alert presented")
}

let alert2 = JUIAlertController(title: "Low", message: "Low priority alert", preferredStyle: .alert)
let action2 = UIAlertControllerAction(title: "Dismiss")
alert2.addAction(action2)

presenter.present(alert1, priority: .low) {
    print("Low priority alert presented")
}
```

### Dismissing an Alert Controller

If a controller is being displayed, it will be closed immediately.
But if it is in the priority queue, it will be removed from the queue and will not be displayed.

```swift
presenter.dismiss(alert1)
```
or
```swift
presenter.dismiss(restorationIdentifier: alert1.restorationIdentifier!)
```

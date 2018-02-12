//  Copyright © 2017 Markus Staas. All rights reserved.

import UIKit

class UIControls: UIViewController {

    @objc func managedObjectContextDidSave(notification: NSNotification) {
        if notification.name == NSNotification.Name.NSManagedObjectContextDidSave {
            let alert = UIAlertController(
                title: "Workout Saved",
                message: "Your workout has been saved. Tap OK to return to the start screen",
                preferredStyle: .actionSheet)
            let savedAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
                self.navigationController?.popViewController(animated: false)
                self.performSegue(withIdentifier: "homeSegue", sender: self)
            }

            alert.addAction(savedAction)
            present(alert, animated: true)
        }
    }

}

import UIKit

extension UIViewController {
    func showSimpleAlert(with title: String) {
        let alertController = UIAlertController(
            title: "Error occurred",
            message: title,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

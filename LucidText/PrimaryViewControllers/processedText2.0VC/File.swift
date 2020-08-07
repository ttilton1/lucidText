import UIKit

//HOW TO CALL
//self.showSpinner(onView: self.view)
//self.removeSpinner()

var v2Spinner : UIView?
 
extension ProcessedTextTwoViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        v2Spinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            v2Spinner?.removeFromSuperview()
            v2Spinner = nil
        }
    }
}

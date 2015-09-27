# Swift 2.0 Protocol Extension Example
Playground showing how to use Swift2 protocol extensions to render errors in UIViews and UIViewControllers without subclassing or creating classes

<img height="333px" width="187px" src="./example.gif" ></img>

**UIViewControllers** will render an error as a toast banner

**UIViews** will render an error by adding a generic error label to the views top right corner.

This was inspired by a [sweet article](http://krakendev.io/blog/subclassing-can-suck-and-heres-why) by [KrakenDev](http://krakendev.io)



```swift   

import UIKit
import XCPlayground

struct ErrorOptions {
    let message: String
    let tintColor: UIColor
    
    init(message: String = "Error!", tintColor: UIColor = UIColor.clearColor()) {
        self.message = message
        self.tintColor = tintColor
    }
}

typealias ErrorRenderingCompletionBlock = ()->()

protocol ErrorPopoverRenderer {
    func presentError(errorOptions: ErrorOptions)
    func presentError(errorOptions: ErrorOptions, completion : ErrorRenderingCompletionBlock?)
}

extension ErrorPopoverRenderer {
    func presentError(errorOptions: ErrorOptions = ErrorOptions()) {
        self.presentError(errorOptions, completion: nil)
    }
}

extension ErrorPopoverRenderer where Self: UIViewController {

    func presentError(errorOptions: ErrorOptions = ErrorOptions(), completion : ErrorRenderingCompletionBlock?) {
        let errorBanner = UILabel()
        errorBanner.backgroundColor = errorOptions.tintColor
        errorBanner.textAlignment = .Center
        errorBanner.adjustsFontSizeToFitWidth = true
        errorBanner.font = UIFont.systemFontOfSize(20.0)
        errorBanner.textColor = UIColor.whiteColor()
        errorBanner.text = errorOptions.message
        let height : CGFloat = 50
        errorBanner.frame = CGRect(x: 0, y: -height, width: CGRectGetWidth(self.view.bounds), height: height)
        self.view.addSubview(errorBanner)
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            errorBanner.transform = CGAffineTransformMakeTranslation(0, height)
            }) { (done1) -> Void in
                UIView.animateWithDuration(0.8, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    errorBanner.transform = CGAffineTransformIdentity
                    }, completion: { (done2) -> Void in
                        errorBanner.removeFromSuperview()
                        if let completionBlock = completion {
                            completionBlock()
                        }
                })
        }
    }
}

extension ErrorPopoverRenderer where Self: UIView {
    
    func presentError(errorOptions: ErrorOptions = ErrorOptions(), completion : ErrorRenderingCompletionBlock?) {
        let errorBanner = UILabel()
        errorBanner.backgroundColor = errorOptions.tintColor
        errorBanner.textAlignment = .Center
        errorBanner.adjustsFontSizeToFitWidth = true
        errorBanner.font = UIFont.systemFontOfSize(18.0)
        errorBanner.text = "!"
        errorBanner.textColor = UIColor.redColor()
        let size : CGFloat = 32.0
        let padding : CGFloat = 8.0
        errorBanner.layer.cornerRadius = size/2.0
        errorBanner.layer.borderColor = UIColor.redColor().CGColor
        errorBanner.layer.borderWidth = 1.0
        errorBanner.frame = CGRect(x: CGRectGetWidth(self.bounds) - size - padding, y: padding, width: size, height: size)
        self.addSubview(errorBanner)
        if let completionBlock = completion {
            completionBlock()
        }
    }
}

extension UIViewController : ErrorPopoverRenderer {}
extension UIView : ErrorPopoverRenderer {}


let viewController = UIViewController()
viewController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
viewController.view.backgroundColor = UIColor.whiteColor()
XCPShowView("Controller View", view: viewController.view)

let errorOptions = ErrorOptions(message: "OMG an error!", tintColor: UIColor.redColor())
viewController.presentError(errorOptions) { () -> () in
    viewController.view.presentError()
}



```
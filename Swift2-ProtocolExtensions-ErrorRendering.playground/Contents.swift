//: Playground - noun: a place where people can play
//: Inspired by http://krakendev.io/blog/subclassing-can-suck-and-heres-why

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
XCPlaygroundPage.currentPage.liveView = viewController
let errorOptions = ErrorOptions(message: "OMG an error!", tintColor: UIColor.redColor())
viewController.presentError(errorOptions) { () -> () in
    viewController.view.presentError()
}


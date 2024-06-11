//
//  Extensions.swift
//  appsonair
//
//  Created by vishal-zaveri-us on 22/04/24.
//

import Foundation
import UIKit
import CoreMotion
import Toast_Swift
import ZLImageEditor

// MARK: - EXTENSION UIViewController
typealias ToastCompletionHandler = (_ success:Bool) -> Void
var isFeedbackInProgress = false
var screenshot: UIImage?
extension UIViewController {
    
    static let classInit: Void = {
        let originalSelector = #selector(UIViewController.viewDidLoad)
        let swizzledSelector = #selector(UIViewController.swizzled_viewDidLoad)
        
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
        
    }()
    
    @objc func swizzled_viewDidLoad() {
        self.swizzled_viewDidLoad()
        setupMotionDetection()
    }
    
    @objc func swizzled_dealloc() {
           // Clean up resources here if needed
           self.swizzled_dealloc()
       }
    
    func setupMotionDetection() {
        // Set the view controller to become the first responder
        _ = self.view // Ensure the view is loaded
        self.becomeFirstResponder()
        
        // Add motion detection
        let motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    
    }
   
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
       
            
            
            if motion == .motionShake {
                print("Shake Gesture Detected")
                print("feedback progress ===> \(isFeedbackInProgress)")
                guard !isFeedbackInProgress else {
                    return
                }
                print("cancel selected =====> \( ZLEditImageViewController(image:screenshot ?? UIImage()).cancelBtn)")
               
                isFeedbackInProgress = true
                
                if let captureImage = UIApplication.shared.windows.first?.takeScreenshot() {
                    // Do something with the screenshot, like saving it to the photo library
                    // UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
                    screenshot = captureImage
                }
                
           
                ZLImageEditorConfiguration.default()
                    .editImageTools([.draw, .clip, .textSticker])
                    .adjustTools([.brightness, .contrast, .saturation])
                
//                print("cancel selected =====> \(ZLEditImageViewController(image: screenshot ?? UIImage()).cancelBtn.isSelected)")
            
                ZLEditImageViewController.showEditImageVC(parentVC: self, image: screenshot ?? UIImage()) { image, Editmodel in
                    screenshot = image
                    
                    // let bundle = Bundle(for: type(of: self))
                    let bundle = Bundle(identifier: "org.cocoapods.AppsOnAir")
                    let storyboard = UIStoryboard(name: "Feedback", bundle: bundle)
                    let Vc = storyboard.instantiateViewController(withIdentifier: "FeedbackController") as? FeedbackController
                    
                    Vc?.selectedImage = [screenshot ?? UIImage()]
                    
                    Vc?.navBarColor = AppsOnAirServices.shared.navBarColor
                    Vc?.navBarTitle = AppsOnAirServices.shared.navBarTitle
                    Vc?.navBarTitleTextColor = AppsOnAirServices.shared.navBarTitleTextColor
                    
                    Vc?.backgroundColor = AppsOnAirServices.shared.backgroundColor
                    
                    Vc?.labelTextColor = AppsOnAirServices.shared.labelTextColor
                    Vc?.inputHintTextColor = AppsOnAirServices.shared.inputHintTextColor
                    Vc?.backgroundColor = AppsOnAirServices.shared.backgroundColor
                    
                    Vc?.labelTextColor = AppsOnAirServices.shared.labelTextColor
                    Vc?.inputHintTextColor = AppsOnAirServices.shared.inputHintTextColor
                    
                    
                    Vc?.txtDescriptionCharLimit = AppsOnAirServices.shared.txtDescriptionCharLimit ?? 255
                    Vc?.txtDescriptionHintText = AppsOnAirServices.shared.txtDescriptionHintText
                    
                    Vc?.txtEmailHintText = AppsOnAirServices.shared.txtEmailHintText
                    
                    Vc?.btnSubmitText = AppsOnAirServices.shared.btnSubmitText
                    Vc?.btnSubmitTextColor = AppsOnAirServices.shared.btnSubmitTextColor
                    Vc?.btnSubmitBackgroundColor = AppsOnAirServices.shared.btnSubmitBackgroundColor
                    
                    
                    self.presentScreenFromTop(Vc ?? UIViewController())
                    isFeedbackInProgress = false
                    print("end feedback progress ===> \(isFeedbackInProgress)")
                }
                
                
            }
    }
    
    func presentScreenFromTop(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .overFullScreen // or .overCurrentContext
    
        DispatchQueue.main.async { [weak self] in
            self?.present(viewController, animated: animated, completion: completion)
        }
    }
    
    func showToast(message : String, duration: Double = 2.0,completion:@escaping ToastCompletionHandler){
        
        self.view.makeToast(message,duration: duration)
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            completion(true)
        })
        
    }
}

// MARK: - EXTENSION UIView
extension UIView {
    /*===================================================
     * function Purpose: CAPTURE SNAPSHOT OF SCREEN
     ===================================================*/
    ///capture screen snapshot
    func takeScreenshot() -> UIImage? {
        // Get the screen bounds including the status bar
        let screenBounds = UIScreen.main.bounds
        
        // Begin image context
        UIGraphicsBeginImageContextWithOptions(screenBounds.size, false, UIScreen.main.scale)
        
        // Render the window's layer into the current context
        UIApplication.shared.windows.forEach { window in
            window.drawHierarchy(in: screenBounds, afterScreenUpdates: true)
        }
        
        // Get the captured image
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        
        // End image context
        UIGraphicsEndImageContext()
        
        return screenshot
    }
    
    /*===================================================
     * function Purpose: ADD BOTTOM SHADOW TO VIEW
     ===================================================*/
    ///set shadow in bottom of view
    func addShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,y: bounds.maxY - layer.shadowRadius,
                                                         width: bounds.width,
                                                         height: layer.shadowRadius)).cgPath
    }
    
    // OLD
     func addShadows(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0,
                   cornerRadiusIs:CGFloat = 0.0) {
        
            layer.cornerRadius = cornerRadiusIs
            layer.shadowColor = shadowColor
            layer.shadowOffset = shadowOffset
            layer.shadowOpacity = shadowOpacity
            layer.shadowRadius = shadowRadius
        
    }
    
    func addCorrnerRaduis(color: UIColor = UIColor.lightGray, raduis: CGFloat?)  {
        self.layer.cornerRadius = raduis ?? 8.0
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true 
        self.layer.borderColor = color.cgColor
    }
    
    /*===================================================
     * function Purpose: ROUND CORRNERS ON SPECIFIC SIDES
     ===================================================*/
    ///set round corrners on specific side
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
    }

}

//
//  ConfigurableResourceProvider.swift
//  OkayiOSDemo
//
//  Created by Ben Ogie on 24/01/2022.
//

import Foundation
import PSA

class ConfigurableResourceProvider: NSObject, ResourceProvider {
    var invalidPinRetryErrorText: String = "Please try again later."
    
    var biometricAlertReasonText: NSAttributedString! = NSAttributedString(string: "Biometric Alert!")
    
    var confirmButtonText: NSAttributedString! = NSAttributedString(string: "Confirm")
    
    var confirmBiometricTouchButtonText: NSAttributedString! = NSAttributedString(string: "Confirm")
    
    var confirmBiometricFaceButtonText: NSAttributedString! = NSAttributedString(string: "Confirm")
    
    var cancelButtonText: NSAttributedString! = NSAttributedString(string: "Cancel")
    
    var massPaymentDetailsButtonText: NSAttributedString! = NSAttributedString(string: "Mass Payment Details")
    
    var massPaymentDetailsHeaderText: NSAttributedString! = NSAttributedString(string: "Mass Payment")
    
    var feeLabelText: NSAttributedString! = NSAttributedString(string: "Fee")
    
    var recepientLabelText: NSAttributedString! = NSAttributedString(string: "Receipient")
    
    var enrollmentTitleText: NSAttributedString! = NSAttributedString(string: "Enrollment")
    
    var enrollmentDescriptionText: NSAttributedString! = NSAttributedString(string: "Enrollment in progress")
    
    func string(for transactionInfo: TransactionInfo!) -> NSAttributedString! {
        let attr: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.red,
            .backgroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 36)
        ]
        return NSAttributedString(string: "Default Implementation", attributes: attr)
    }
    
    func string(forConfirmActionHeader transactionInfo: TransactionInfo!) -> NSAttributedString! {
        let attr: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.red,
            .backgroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 36)
        ]
        return NSAttributedString(string: "Default Header", attributes: attr)
    }
    
    
}

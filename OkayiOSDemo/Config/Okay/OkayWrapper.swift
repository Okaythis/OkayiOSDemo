//
//  OkayWrapper.swift
//  OkayiOSDemo
//
//  Created by Ben Ogie on 24/01/2022.
//

import Foundation
import PSA

public class OkayWrapper {
    
    func enrollDevice(){
        if PSAModule.isReadyForEnrollment() {
            PSAModule.startEnrollment(withHost: BaseURLManager.shared.activeURL, invisibly: false, installationId: OkayDefaultConfig.installationId, resourceProvider: ConfigurableResourceProvider(), pubPssBase64: OkayDefaultConfig.pubPssBase64) { enrolmentStatus in
                if(enrolmentStatus.rawValue == 1){
                    print("Enrolment was successful")
                } else{
                    print("Enrolment failed")
                }
            }
        } else {
            print("Okay SDK is not ready for enrollment")
        }
    }
    
    func linkDeviceToTenant(linkingCode: String) {
        PSAModule.linkTenant(withLinkingCode: linkingCode){ (linkingStatus, tenant) in
            if(linkingStatus.rawValue == 1){
                print("linking with \(String(describing: tenant.tenantId)) was successful")
            } else{
                print("linking failed")
            }
        }
    }
    
    func unlinkDeviceFromTenant(tenantID: String){
        PSAModule.unlinkTenant(withTenantId: NSNumber(value: Int(tenantID) ?? 0)){ (unlinkingStatus, number) in
            if(unlinkingStatus.rawValue == 1){
                print("Unlinking was successful")
            } else{
                print("Unlinking failed")
            }
        }
    }
}

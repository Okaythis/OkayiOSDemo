//
//  OkayWrapper.swift
//  OkayiOSDemo
//
//  Created by Ben Ogie on 24/01/2022.
//

import Foundation
import PSA

enum APIStatus {
    case success
    case failure(_ code: Int)
}

public class OkayWrapper {
    
    func enrollDevice(_ block: @escaping (APIStatus) -> Void){
        if PSAModule.isReadyForEnrollment() {
            PSAModule.startEnrollment(withHost: BaseURLManager.shared.activeURL, invisibly: false, installationId: OkayDefaultConfig.installationId, resourceProvider: ConfigurableResourceProvider(), pubPssBase64: OkayDefaultConfig.pubPssBase64) { enrolmentStatus in
                if(enrolmentStatus.rawValue == 1){
                    print("Enrolment was successful")
                    block(.success)
                } else{
                    print("Enrolment failed")
                    block(.failure(Int(enrolmentStatus.rawValue)))
                }
            }
        } else {
            block(.failure(-1))
            print("Okay SDK is not ready for enrollment")
        }
    }
    
    func linkDeviceToTenant(linkingCode: String, _ block: @escaping (APIStatus) -> Void){
        PSAModule.linkTenant(withLinkingCode: linkingCode){ (linkingStatus, tenant) in
            if(linkingStatus.rawValue == 1){
                print("linking with \(String(describing: tenant.tenantId)) was successful")
                block(.success)
            } else{
                print("linking failed")
                block(.failure(Int(linkingStatus.rawValue)))
            }
        }
    }
    
    func unlinkDeviceFromTenant(tenantID: String, _ block: @escaping (APIStatus) -> Void){
        PSAModule.unlinkTenant(withTenantId: NSNumber(value: Int(tenantID) ?? 0)){ (unlinkingStatus, number) in
            if(unlinkingStatus.rawValue == 1){
                print("Unlinking was successful")
                block(.success)
            } else{
                print("Unlinking failed")
                block(.failure(Int(unlinkingStatus.rawValue)))
            }
        }
    }
}

//
//  FcmModel.swift
//  OkayiOSDemo
//
//  Created by Ben Ogie on 24/01/2022.
//

import Foundation

final class FcmModel : ObservableObject {
    @Published var fcmToken: String? = nil
}

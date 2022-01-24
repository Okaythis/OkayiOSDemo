//
//  ContentView.swift
//  OkayiOSDemo
//
//  Created by Ben Ogie on 20/01/2022.
//

import SwiftUI
import PSA
import Firebase
import FirebaseMessaging

struct ContentView: View {
    @EnvironmentObject var fcmModel: FcmModel
    @State private var linkingCodeText: String = ""
    @State private var unlinkingCodeText: String = ""
    let okayWrapper = OkayWrapper()
    
    var body: some View {
        VStack {
            Spacer()
            Button {
                okayWrapper.enrollDevice()
            } label: {
                Text("Enroll Device")
                    .font(.subheadline)
                    .fontWeight(Font.Weight.bold)
                    .padding()
                    .background(Color("Primary"))
                    .foregroundColor(.white)
            }
            Spacer()
           
            
            TextField("Enter linking code here", text: $linkingCodeText)
                .textContentType(.oneTimeCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(16)
            Button {
                okayWrapper.linkDeviceToTenant(linkingCode: linkingCodeText)
            } label: {
                Text("Link Device")
                    .font(.subheadline)
                    .fontWeight(Font.Weight.bold)
                    .padding()
                    .background(Color("Primary"))
                    .foregroundColor(.white)
            }
            .contentShape(Rectangle())
            .foregroundColor(.blue)
            Spacer()

            
            TextField("Enter tenant ID here", text: $unlinkingCodeText)
                .padding(16)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button {
                okayWrapper.unlinkDeviceFromTenant(tenantID: unlinkingCodeText)
            } label: {
                Text("Unlink Device")
                    .font(.subheadline)
                    .fontWeight(Font.Weight.bold)
                    .padding()
                    .background(Color("Primary"))
                    .foregroundColor(.white)
            }
            .contentShape(Rectangle())
            .foregroundColor(.blue)
            
            Spacer()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

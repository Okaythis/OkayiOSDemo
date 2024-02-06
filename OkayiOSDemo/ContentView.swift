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
    
    @State private var openSettings: Bool = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State private var showEnrollmentSuccess: Bool = false
    @State private var showEnrollmentFailure: Bool = false
    @State private var showLinkingSuccess: Bool = false
    @State private var showLinkingFailure: Bool = false
    @State private var showUnlinkingSuccess: Bool = false
    @State private var showUnlinkingFailure: Bool = false
    
    @State private var responseCode: Int = -1
        
    let okayWrapper = OkayWrapper()
    
    var body: some View {
        NavigationView{
            VStack {
                Spacer()
                buttonSection
                Spacer()
                linkingSection
                Spacer()
                unlinkingSection
                Spacer()
                Spacer()
                
                NavigationLink(destination: UrlListView(), isActive: $openSettings) { EmptyView() }
            }
            .alert("Enrollment was successful.", isPresented: $showEnrollmentSuccess) {}
            .alert("Enrollment was not successful (code: \(responseCode))", isPresented: $showEnrollmentFailure) {}
            .alert("Linking was successful.", isPresented: $showLinkingSuccess) {}
            .alert("Linking was not successful (code: \(responseCode))", isPresented: $showLinkingFailure) {}
            .alert("Unlinking was successful.", isPresented: $showUnlinkingSuccess) {}
            .alert("Unlinking was not successful (code: \(responseCode))", isPresented: $showUnlinkingFailure) {}
            .navigationTitle("Okay iOS Demo")
        }
    }
    
    var buttonSection: some View {
        HStack {
            Spacer()
            Button {
                okayWrapper.enrollDevice { status in
                    switch status {
                    case .success:
                        responseCode = -1
                        showEnrollmentSuccess =  true
                    case .failure(let code):
                        print(code)
                        responseCode = code
                        showEnrollmentFailure = true
                    }
                }
            } label: {
                Text("Enroll Device")
                    .font(.subheadline)
                    .fontWeight(Font.Weight.bold)
                    .padding()
                    .background(Color("Primary"))
                    .foregroundColor(colorScheme == .light ? .white : .black)
            }
            .clipShape(.rect(cornerRadius: 5.0))
            Spacer()
        
                Button {
                    openSettings = true
                } label: {
                    Text("Change Base URL")
                        .font(.subheadline)
                        .fontWeight(Font.Weight.bold)
                        .padding()
                        .background(Color("Primary"))
                        .foregroundColor(colorScheme == .light ? .white : .black)
                }
                .clipShape(.rect(cornerRadius: 5.0))
                Spacer()
            
        }
    }
    
    var linkingSection: some View {
        VStack {
            TextField("Enter linking code here", text: $linkingCodeText)
                .textContentType(.oneTimeCode)
                .padding(16)
                .border(colorScheme == .dark ? .white : .gray, width: 2)
                .padding()
            
            Button {
                if linkingCodeText.isEmpty { return }
                okayWrapper.linkDeviceToTenant(linkingCode: linkingCodeText) { status in
                    switch status {
                    case .success:
                        responseCode = -1
                        showLinkingSuccess =  true
                    case .failure(let code):
                        print(code)
                        responseCode = code
                        showLinkingFailure = true
                    }
                }
            } label: {
                Text("Link Device")
                    .font(.subheadline)
                    .fontWeight(Font.Weight.bold)
                    .padding()
                    .background(Color("Primary"))
                    .foregroundColor(colorScheme == .light ? .white : .black)
            }
            .clipShape(.rect(cornerRadius: 5.0))
        }
    }
    
    var unlinkingSection: some View {
        VStack {
            TextField("Enter tenant ID here", text: $unlinkingCodeText)
                .padding(16)
                .border(colorScheme == .dark ? .white : .gray, width: 2)
                .padding()
            
            Button {
                if unlinkingCodeText.isEmpty { return }
                okayWrapper.unlinkDeviceFromTenant(tenantID: unlinkingCodeText) { status in
                    switch status {
                    case .success:
                        responseCode = -1
                        showUnlinkingSuccess =  true
                    case .failure(let code):
                        print(code)
                        responseCode = code
                        showUnlinkingFailure = true
                    }
                }
            } label: {
                Text("Unlink Device")
                    .font(.subheadline)
                    .fontWeight(Font.Weight.bold)
                    .padding()
                    .background(Color("Primary"))
                    .foregroundColor(colorScheme == .light ? .white : .black)
            }
            .clipShape(.rect(cornerRadius: 5.0))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

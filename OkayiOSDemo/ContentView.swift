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
    
    var hideSettingsButton: Bool = false // debug pruposes..
    
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
            .navigationTitle("Okay iOS Demo")
        }
    }
    
    var buttonSection: some View {
        HStack {
            Spacer()
            Button {
                okayWrapper.enrollDevice()
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
            if !hideSettingsButton {
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
    }
    
    var linkingSection: some View {
        VStack {
            TextField("Enter linking code here", text: $linkingCodeText)
                .textContentType(.oneTimeCode)
                .padding(16)
                .border(colorScheme == .dark ? .white : .gray, width: 2)
                .padding()
            
            Button {
                okayWrapper.linkDeviceToTenant(linkingCode: linkingCodeText)
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
                okayWrapper.unlinkDeviceFromTenant(tenantID: unlinkingCodeText)
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

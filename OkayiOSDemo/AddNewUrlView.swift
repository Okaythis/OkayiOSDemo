//
//  AddNewUrlView.swift
//  OkayiOSDemo
//
//  Created by SK on 30/01/24.
//

import SwiftUI

struct AddNewUrlView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State private var urlName: String = ""
    @State private var urlValue: String = ""
    
    @State private var showDulicateAlert = false
    @State private var showInvalidAlert = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                nameSection
                valueSection
                buttonSection
            }
            .navigationTitle("Add New URL")
            .alert("Same url already available in another name.", isPresented: $showDulicateAlert) {}
            .alert("Please enter a valid url.", isPresented: $showInvalidAlert) {}
            .alert("New url added successfully", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            }
        }
    }
    
    var nameSection: some View {
        Section("Url Name / Identifier:") {
            TextField("Enter url name/identifier.", text: $urlName)
                .textContentType(.name)
                .padding(15)
                .border(colorScheme == .dark ? .white : .gray, width: 2)
                .autocorrectionDisabled()
        }
        .listRowBackground(Color.clear)
    }
    
    var valueSection: some View {
        Section("Url:") {
            TextField("Enter url", text: $urlValue)
                .textContentType(.URL)
                .padding(15)
                .border(colorScheme == .dark ? .white : .gray, width: 2)
                .keyboardType(.URL)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
        .listRowBackground(Color.clear)
    }
    
    var buttonSection: some View {
        Section {
            addButton
            cancelButton
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .frame(maxWidth: .infinity, alignment:.center)
    }
    
    var addButton: some View {
        Button {
            checkAndAddURL()
        } label: {
            Text("Add URL")
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(minWidth: 200)
                .contentShape(Rectangle())
                .padding()
                .background(Color("Primary"))
                .foregroundColor(colorScheme == .light ? .white : .black)
        }
        .clipShape(.rect(cornerRadius: 5.0))
    }
    
    var cancelButton: some View {
        Button(role: .destructive) {
            dismiss()
        } label: {
            Text("Cancel")
                .padding()
        }
        .clipShape(.rect(cornerRadius: 5.0))
    }
    
    private func checkAndAddURL() {
        guard !urlName.isEmpty || !urlValue.isEmpty else { return }
        
        guard BaseURLManager.shared.isValidUrl(urlValue) else {
            showInvalidAlert = true
            urlValue = ""
            return
        }
        
        guard !BaseURLManager.shared.isDuplicateData(urlValue) else {
            showDulicateAlert = true
            return
        }
        
        BaseURLManager.shared.addURLData(UrlData(name: urlName, url: urlValue)) {
            showSuccessAlert = true
        }
    }
}

#Preview {
    AddNewUrlView()
}

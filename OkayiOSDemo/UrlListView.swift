//
//  UrlListView.swift
//  OkayiOSDemo
//
//  Created by SK on 29/01/24.
//

import SwiftUI

struct UrlListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var urlManager = BaseURLManager.shared
    
    @State private var openAddUrlScreen = false
    @State private var showUrlDeleteAlert = false
    
    @State private var processingUrl: UrlData?
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            urlList
            addButton
        }
        .alert("Are you sure you want to delete this URL?", isPresented: $showUrlDeleteAlert) {
            Button("Cancel", role: .cancel){}
            Button("Delete", role: .destructive, action: deleteURL)
        }
    }
    
    var urlList: some View {
        List(urlManager.allURLs) { data in
            Button {
                urlManager.activeURL = data.url
                dismiss()
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(data.name)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.gray)
                        
                        Text(data.url)
                            .font(.title3)
                            .foregroundColor(Color.blue)
                    }
                    
                    Spacer()
                    if data.url == urlManager.activeURL {
                        VStack {
                            Spacer()
                            Image(systemName: "checkmark.circle")
                                .foregroundStyle(.blue)
                            Spacer()
                        }
                    }
                }
            }
            .swipeActions {
                if data.url != OkayDefaultConfig.okayStagingServerUrl {
                    Button(role: .destructive) {
                        processingUrl = data
                        showUrlDeleteAlert = true
                    }label: {
                        Text("Delete")
                        Image(systemName: "bin.xmark")
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
    
    var addButton: some View {
        Button {
            openAddUrlScreen = true
        } label: {
            Image(systemName: "plus")
                .font(.title.weight(.semibold))
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
        }
        .padding()
        .fullScreenCover(isPresented: $openAddUrlScreen) {
            AddNewUrlView()
        }
    }
    
    private func deleteURL() {
        guard let urlData = self.processingUrl else { return }
        BaseURLManager.shared.deleteURLData(urlData) {
            self.processingUrl = nil
        }
    }
}

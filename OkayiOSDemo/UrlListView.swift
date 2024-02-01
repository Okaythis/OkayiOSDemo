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
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            urlList
            addButton
        }
    }
    
    var urlList: some View {
        List(urlManager.allURLs) { data in
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
            .onTapGesture {
                urlManager.activeURL = data.url
                dismiss()
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
}

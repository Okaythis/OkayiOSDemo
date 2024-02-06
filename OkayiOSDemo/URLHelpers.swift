//
//  URLHelpers.swift
//  OkayiOSDemo
//
//  Created by SK on 30/01/24.
//

import Foundation
import UIKit

struct UrlData: Codable, Identifiable {
    var id = UUID()
    var name: String
    var url: String
}

class BaseURLManager: ObservableObject {
    
    @Published var allURLs = [UrlData]()
    
    static let shared = BaseURLManager()
    static let fileName = "BaseURLs.txt"
    
    var activeURL: String = OkayDefaultConfig.okayStagingServerUrl
    
    private init() {
        loadInitialData()
        readUrlData()
    }
    
    private func loadInitialData() {
        let filePath = LocalStorageManager.fileURL(for: Self.fileName)
        
        guard !FileManager.default.fileExists(atPath: filePath.absoluteString) else { print("File exists.."); return }
        
        let defaultURL = UrlData(name: "Stage", url: OkayDefaultConfig.okayStagingServerUrl)
        self.storeUrlData([defaultURL])
    }
    
    private func storeUrlData(_ urls: [UrlData]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(urls)
            LocalStorageManager.store(data: data)
        } catch {
            print("Can't convert intial values to Data..")
        }
    }
    
    func readUrlData() {
        guard let data = LocalStorageManager.retrive() else { return }
        do {
            let urls = try JSONDecoder().decode([UrlData].self, from: data)
            self.allURLs = urls
            print(urls)
        } catch {
            print("Can't convert Data to URLData..")
        }
    }
    
    func addURLData(_ urlData: UrlData, _ finished: ()->Void) {
        allURLs.append(urlData)
        self.storeUrlData(allURLs)
        self.readUrlData()
        finished()
    }
    
    func deleteURLData(_ urlData: UrlData, _ finished: ()->Void) {
        if let firstIndex = self.allURLs.firstIndex(where: { $0.id == urlData.id }) {
            self.allURLs.remove(at: firstIndex)
            self.storeUrlData(allURLs)
            self.readUrlData()
        }
        finished()
    }
    
    func isDuplicateData(_ url: String) -> Bool {
        let filtered = self.allURLs.first { $0.url == url }
        return filtered == nil ? false : true
    }
    
    func isValidUrl(_ urlString: String) -> Bool {
        if let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
}

class LocalStorageManager {
    private init() { }
    
    static func fileURL(for file: String) -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent(file)
    }
    
    static func store(data: Data, to file: String = BaseURLManager.fileName) {
        let fileURL = self.fileURL(for: file)
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Can't store data locally..")
        }
    }
    
    static func retrive(from file: String = BaseURLManager.fileName) -> Data? {
        let fileURL = self.fileURL(for: file)
        
        var data: Data?
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            print("Can't store data locally..")
        }
        return data
    }
}

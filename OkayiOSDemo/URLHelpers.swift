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
    
    private static func fileURL(for file: String) -> URL? {
        guard let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(file) else {
            return nil
        }
        return url
    }
    
    static func store(data: Data, to file: String = BaseURLManager.fileName) {
        guard let fileURL = self.fileURL(for: file) else { print("Can't create file locally.."); return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Can't store data locally..")
        }
    }
    
    static func retrive(from file: String = BaseURLManager.fileName) -> Data? {
        guard let fileURL = self.fileURL(for: file) else { print("Can't find file locally.."); return nil }
        
        var data: Data?
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            print("Can't store data locally..")
        }
        return data
    }
}

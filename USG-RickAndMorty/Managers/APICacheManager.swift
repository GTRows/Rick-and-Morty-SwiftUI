//
//  APICacheManager.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 21.04.2023.
//

import Foundation
import SwiftUI

final class APICacheManager {
    init() { setUpCache() }

    private var cacheDictionary: [
        RMEndpoint: NSCache<NSString, NSData>
    ] = [:]

    func removeAllData() {
        cacheDictionary.removeAll()
    }

    func getCachedAPIResponse(
        for endpoint: RMEndpoint,
        url: URL?
    ) -> Data? {
        guard let cache = cacheDictionary[endpoint], let url = url else {
            return nil // Cache yoksa nil döndür
        }

        if let cachedData = cache.object(forKey: url.absoluteString as NSString) {
            return cachedData as Data // Cache'te veri varsa döndür
        } else {
            return nil // Cache'te veri yoksa nil döndür
        }
    }

    public func setCache(
        for endpoint: RMEndpoint,
        url: URL?,
        data: Data
    ) {
        guard let cache = cacheDictionary[endpoint], let url = url else {
            return // Cache yoksa nil döndür
        }
        cache.setObject(data as NSData, forKey: url.absoluteString as NSString)
    }

    private func setUpCache() {
        for endpoint in RMEndpoint.allCases {
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }

    public func cachedResponse(for endpoint: RMEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return nil
        }
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
}

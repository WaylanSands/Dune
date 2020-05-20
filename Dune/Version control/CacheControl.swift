//
//  ImageCache.swift
//  Dune
//
//  Created by Waylan Sands on 14/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import LinkPresentation


class CacheControl {
    
    
    @available(iOS 13.0, *)
    static func cache(metadata: LPLinkMetadata) {
        // Check if the metadata already exists for this URL
        do {
            guard retrieve(urlString: metadata.url!.absoluteString) == nil else {
                return
            }
            
            // Transform the metadata to a Data object and
            // set requiringSecureCoding to true
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: metadata,
                requiringSecureCoding: true)
            
            // Save to user defaults
            UserDefaults.standard.setValue(data, forKey: metadata.url!.absoluteString)
        }
        catch let error {
            print("Error when caching: \(error.localizedDescription)")
        }
    }
    
    @available(iOS 13.0, *)
    static func retrieve(urlString: String) -> LPLinkMetadata? {
        do {
            // Check if data exists for a particular url string
            guard
                let data = UserDefaults.standard.object(forKey: urlString) as? Data,
                // Ensure that it can be transformed to an LPLinkMetadata object
                let metadata = try NSKeyedUnarchiver.unarchivedObject(
                    ofClass: LPLinkMetadata.self,
                    from: data)
                else { return nil }
            return metadata
        }
        catch let error {
            print("Error when caching: \(error.localizedDescription)")
            return nil
        }
    }

}

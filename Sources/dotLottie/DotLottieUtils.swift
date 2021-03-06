//
//  DotLottieUtils.swift
//  LottieFiles
//
//  Created by Evandro Harrison Hoffmann on 27/06/2020.
//  Copyright © 2020 LottieFiles. All rights reserved.
//

import Foundation

public struct DotLottieUtils {
    public static let dotLottieExtension = "lottie"
    public static let jsonExtension = "json"
    
    /// Temp folder to app directory
    public static var tempDirectoryURL: URL {
        if #available(iOS 10.0, *) {
            return FileManager.default.temporaryDirectory
        }
        
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    /// Returns url temp foder with animation name
    /// - Parameter url: Animation url
    /// - Returns: url to animation temp folder
    public static func tempDirectoryURL(for url: URL) -> URL {
        return tempDirectoryURL.appendingPathComponent(url.lastPathComponent)
    }
    
    /// Temp downloads folder to app directory
    public static var downloadsDirectoryURL: URL {
        DotLottieUtils.tempDirectoryURL.appendingPathComponent("downloads")
    }
    
    /// Returns temp download url for file
    /// - Parameter url: Animation url
    /// - Returns: url to animation temp folder
    public static func downloadsDirectoryURL(for url: URL) -> URL {
        DotLottieUtils.downloadsDirectoryURL.appendingPathComponent(url.lastPathComponent)
    }
    
    /// Returns url to file in local bundle with given name
    /// - Parameter name: name of animation file
    /// - Returns: URL to local animation
    public static func bundleURL(for name: String) -> URL? {
        guard let url = Bundle.main.url(forResource: name, withExtension: dotLottieExtension, subdirectory: nil) else {
            guard let url = Bundle.main.url(forResource: name, withExtension: jsonExtension, subdirectory: nil) else {
                return nil
            }
            return url
        }
        return url
    }
}

extension URL {
    
    /// Checks if url is a lottie file
    var isDotLottieFile: Bool {
        return pathExtension == DotLottieUtils.dotLottieExtension
    }
    
    /// Checks if url is a json file
    var isJsonFile: Bool {
        return pathExtension == DotLottieUtils.jsonExtension
    }
    
    /// Checks if file is remote
    var isRemoteFile: Bool {
        return absoluteString.contains("http")
    }
}

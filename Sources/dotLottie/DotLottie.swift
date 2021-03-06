//
//  DotLottieAnimation.swift
//  dotLottie-ios
//
//  Created by whit3hawks on 02/07/2020.
//  Copyright (c) 2020 whit3hawks. All rights reserved.
//
import Foundation
import CoreGraphics
import Lottie

public class DotLottie {
    
    /// Loads animation in bundle with given name
    /// - Parameters:
    ///   - name: name of animation in bundle
    ///   - completion: Lottie Animation
    public static func load(name: String, completion: @escaping (Animation?) -> Void) {
        if let url = DotLottieUtils.bundleURL(for: name) {
            animation(for: DotLottieFile(url: url)?.animationUrl ?? url, completion: completion)
        } else {
            completion(nil)
        }
    }
    
    /// Loads an animation from a URL
    /// If it's a remote .lottie file, we download, unzip and extract the animation
    /// For .json files, we simply show the animation
    /// - Parameters:
    ///   - url: url to load animation from
    ///   - completion: Lottie Animation
    public static func load(from url: URL, completion: @escaping (Animation?) -> Void) {
        if url.isDotLottieFile {
            if url.isRemoteFile {
                download(from: url) { (path) in
                    guard let path = path else {
                        completion(nil)
                        return
                    }
                    self.animation(for: path, completion: completion)
                }
            } else {
                animation(for: DotLottieFile(url: url)?.animationUrl ?? url, completion: completion)
            }
        } else {
            animation(for: url, completion: completion)
        }
    }
    
    /// Downloads file from given URL and save in local app temp folder
    /// - Parameters:
    ///   - url: remote url to download file from
    ///   - completion: Path URL to downloaded file
    public static func download(from url: URL, completion: @escaping (_ path: URL?) -> Void) {
        guard url.isRemoteFile else {
            completion(DotLottieFile(url: url)?.animationUrl ?? url)
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data else {
                print("Failed to download data: \(error?.localizedDescription ?? "no description")")
                completion(nil)
                return
            }
            
            do {
                try FileManager.default.createDirectory(at: DotLottieUtils.downloadsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                let downloadUrl = DotLottieUtils.downloadsDirectoryURL(for: url)
                try data.write(to: downloadUrl)
                
                completion(DotLottieFile(url: downloadUrl)?.animationUrl)
            } catch {
                print("Failed to save downloaded data: \(error.localizedDescription)")
                completion(nil)
            }
        }).resume()
    }
    
    /// Loads Lottie animation with url to JSON file
    /// - Parameters:
    ///   - url: url to load animation from
    ///   - completion: Lottie animation
    public static func animation(for url: URL, completion: @escaping (Animation?) -> Void) {
        guard url.isJsonFile else {
            print("""
                    Not a JSON file, instead use:
                    DotLottieAnimation.load(from: URL, completion: (Animation?) -> Void)
                  """)
            completion(nil)
            return
        }
        
        Animation.loadedFrom(url: url, closure: { (animation) in
            completion(animation)
        }, animationCache: .none)
    }
}

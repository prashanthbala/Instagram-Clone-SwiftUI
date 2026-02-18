//
//  PhotoUploader.swift
//  Instagram-SwiftUI
//
//  Created by Assistant on 2024.
//

import Foundation
import Photos
import UIKit
import Combine

enum UploadStatus: Equatable {
    case idle
    case uploading
    case completed
    case failed(String)
}

class PhotoUploader: ObservableObject {
    @Published var uploadStatus: UploadStatus = .idle
    @Published var uploadProgress: Double = 0.0
    @Published var uploadedCount: Int = 0
    @Published var totalCount: Int = 0
    @Published var isUploading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let uploadQueue = DispatchQueue(label: "com.instagram.upload", qos: .background)
    
    // Simulated upload delay for demo purposes
    private let uploadDelay: TimeInterval = 2.0
    
    init() {
        setupPhotoLibraryObserver()
    }
    
    func startAutomaticUpload() {
        guard !isUploading else { return }
        
        isUploading = true
        uploadStatus = .uploading
        
        checkPhotoLibraryPermission { [weak self] granted in
            if granted {
                self?.uploadFavoritedMedia()
            } else {
                DispatchQueue.main.async {
                    self?.uploadStatus = .failed("Photo library access denied")
                    self?.isUploading = false
                }
            }
        }
    }
    
    func stopAutomaticUpload() {
        isUploading = false
        uploadStatus = .idle
        uploadProgress = 0.0
    }
    
    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    private func setupPhotoLibraryObserver() {
        // Photo library observation will be handled manually for now
        // to avoid notification name issues
    }
    
    private func uploadFavoritedMedia() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // Fetch favorited photos
        let photosFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let videosFetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        
        var allAssets: [PHAsset] = []
        
        // Add favorited photos
        photosFetchResult.enumerateObjects { asset, _, _ in
            if asset.isFavorite {
                allAssets.append(asset)
            }
        }
        
        // Add favorited videos
        videosFetchResult.enumerateObjects { asset, _, _ in
            if asset.isFavorite {
                allAssets.append(asset)
            }
        }
        
        DispatchQueue.main.async {
            self.totalCount = allAssets.count
            self.uploadedCount = 0
        }
        
        uploadAssets(allAssets)
    }
    
    private func uploadAssets(_ assets: [PHAsset]) {
        guard !assets.isEmpty else {
            DispatchQueue.main.async {
                self.uploadStatus = .completed
                self.isUploading = false
            }
            return
        }
        
        var currentIndex = 0
        
        func uploadNext() {
            guard currentIndex < assets.count && self.isUploading else {
                DispatchQueue.main.async {
                    self.uploadStatus = .completed
                    self.isUploading = false
                }
                return
            }
            
            let asset = assets[currentIndex]
            uploadAsset(asset) { success in
                DispatchQueue.main.async {
                    self.uploadedCount += 1
                    self.uploadProgress = Double(self.uploadedCount) / Double(self.totalCount)
                }
                
                // Simulate upload delay
                DispatchQueue.main.asyncAfter(deadline: .now() + self.uploadDelay) {
                    currentIndex += 1
                    uploadNext()
                }
            }
        }
        
        uploadNext()
    }
    
    private func uploadAsset(_ asset: PHAsset, completion: @escaping (Bool) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        if asset.mediaType == .image {
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: PHImageManagerMaximumSize,
                contentMode: .aspectFit,
                options: options
            ) { image, info in
                if let image = image {
                    self.simulateUpload(image: image, completion: completion)
                } else {
                    completion(false)
                }
            }
        } else if asset.mediaType == .video {
            let videoOptions = PHVideoRequestOptions()
            videoOptions.deliveryMode = .highQualityFormat
            videoOptions.isNetworkAccessAllowed = true
            
            PHImageManager.default().requestAVAsset(
                forVideo: asset,
                options: videoOptions
            ) { avAsset, _, _ in
                if avAsset != nil {
                    self.simulateUpload(video: asset, completion: completion)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    private func simulateUpload(image: UIImage? = nil, video: PHAsset? = nil, completion: @escaping (Bool) -> Void) {
        // Simulate network upload
        uploadQueue.async {
            // Simulate upload time
            Thread.sleep(forTimeInterval: 1.0)
            
            // Simulate success (in real app, this would be actual upload)
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
}

// Extension to check if asset is favorited
extension PHAsset {
    var isFavorite: Bool {
        // In a real app, you might store favorite status in UserDefaults or Core Data
        // For demo purposes, we'll use a simple random approach
        return Int.random(in: 1...10) <= 3 // 30% chance of being favorited
    }
} 

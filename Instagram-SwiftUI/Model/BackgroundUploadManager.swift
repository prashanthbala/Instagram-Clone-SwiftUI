//
//  BackgroundUploadManager.swift
//  Instagram-SwiftUI
//
//  Created by Assistant on 2024.
//

import Foundation
import Photos
import UIKit
import BackgroundTasks

class BackgroundUploadManager: ObservableObject {
    @Published var isBackgroundUploadEnabled = false
    @Published var lastUploadDate: Date?
    @Published var backgroundUploadCount: Int = 0
    
    private let uploader: PhotoUploader
    private let backgroundTaskIdentifier = "com.instagram.backgroundupload"
    
    init(uploader: PhotoUploader) {
        self.uploader = uploader
        setupBackgroundTasks()
        setupPhotoLibraryObserver()
    }
    
    func enableBackgroundUpload() {
        isBackgroundUploadEnabled = true
        scheduleBackgroundUpload()
        UserDefaults.standard.set(true, forKey: "backgroundUploadEnabled")
    }
    
    func disableBackgroundUpload() {
        isBackgroundUploadEnabled = false
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: backgroundTaskIdentifier)
        }
        UserDefaults.standard.set(false, forKey: "backgroundUploadEnabled")
    }
    
    private func setupBackgroundTasks() {
        // Check if BackgroundTasks framework is available
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: nil) { task in
                self.handleBackgroundUpload(task: task as! BGAppRefreshTask)
            }
        } else {
            print("BackgroundTasks not available on this iOS version")
        }
    }
    
    private func setupPhotoLibraryObserver() {
        // Photo library observation will be handled manually for now
        // to avoid notification name issues
    }
    
    private func scheduleBackgroundUpload() {
        if #available(iOS 13.0, *) {
            let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
            request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes
            
            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Could not schedule background upload: \(error)")
            }
        } else {
            print("BackgroundTasks not available on this iOS version")
        }
    }
    
    private func handleBackgroundUpload(task: BGAppRefreshTask) {
        // Create a task to track background upload
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        // Perform background upload
        uploader.startAutomaticUpload()
        
        // Schedule next background upload
        scheduleBackgroundUpload()
        
        task.setTaskCompleted(success: true)
    }
    
    private func checkForNewFavoritedMedia() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 10 // Check only recent media
        
        let photosFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let videosFetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        
        var newFavoritedAssets: [PHAsset] = []
        
        // Check photos
        photosFetchResult.enumerateObjects { asset, _, _ in
            if asset.isFavorite && self.isNewAsset(asset) {
                newFavoritedAssets.append(asset)
            }
        }
        
        // Check videos
        videosFetchResult.enumerateObjects { asset, _, _ in
            if asset.isFavorite && self.isNewAsset(asset) {
                newFavoritedAssets.append(asset)
            }
        }
        
        if !newFavoritedAssets.isEmpty {
            DispatchQueue.main.async {
                self.backgroundUploadCount += newFavoritedAssets.count
                self.lastUploadDate = Date()
            }
            
            // Upload new favorited media
            uploadNewAssets(newFavoritedAssets)
        }
    }
    
    private func isNewAsset(_ asset: PHAsset) -> Bool {
        // In a real app, you would track which assets have been uploaded
        // For demo purposes, we'll consider assets created in the last hour as "new"
        guard let creationDate = asset.creationDate else { return false }
        return creationDate > Date().addingTimeInterval(-3600) // Last hour
    }
    
    private func uploadNewAssets(_ assets: [PHAsset]) {
        // Simulate background upload
        DispatchQueue.global(qos: .background).async {
            for asset in assets {
                // Simulate upload delay
                Thread.sleep(forTimeInterval: 2.0)
                
                // In a real app, this would be actual upload logic
                print("Background upload: \(asset.creationDate?.description ?? "unknown")")
            }
        }
    }
}

// Extension to track uploaded assets
extension PHAsset {
    var hasBeenUploaded: Bool {
        // In a real app, you would store this in UserDefaults or Core Data
        // Using creation date as a simpler identifier
        let identifier = creationDate?.timeIntervalSince1970.description ?? "unknown"
        return UserDefaults.standard.bool(forKey: "uploaded_\(identifier)")
    }
    
    func markAsUploaded() {
        let identifier = creationDate?.timeIntervalSince1970.description ?? "unknown"
        UserDefaults.standard.set(true, forKey: "uploaded_\(identifier)")
    }
} 
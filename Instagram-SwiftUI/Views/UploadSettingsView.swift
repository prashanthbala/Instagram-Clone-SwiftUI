//
//  UploadSettingsView.swift
//  Instagram-SwiftUI
//
//  Created by Assistant on 2024.
//

import SwiftUI

struct UploadSettingsView: View {
    @ObservedObject var photoUploader: PhotoUploader
    @ObservedObject var backgroundManager: BackgroundUploadManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isBackgroundUploadEnabled = false
    @State private var uploadOnlyOnWifi = true
    @State private var uploadOnlyWhenCharging = false
    @State private var autoUploadFavorites = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Auto Upload Settings")) {
                    Toggle("Enable Background Upload", isOn: $isBackgroundUploadEnabled)
                        .onChange(of: isBackgroundUploadEnabled) { newValue in
                            if newValue {
                                backgroundManager.enableBackgroundUpload()
                            } else {
                                backgroundManager.disableBackgroundUpload()
                            }
                        }
                    
                    Toggle("Upload only on Wi-Fi", isOn: $uploadOnlyOnWifi)
                    Toggle("Upload only when charging", isOn: $uploadOnlyWhenCharging)
                    Toggle("Auto-upload favorited media", isOn: $autoUploadFavorites)
                }
                
                Section(header: Text("Upload Statistics")) {
                    HStack {
                        Text("Total Uploaded")
                        Spacer()
                        Text("\(photoUploader.uploadedCount)")
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("Background Uploads")
                        Spacer()
                        Text("\(backgroundManager.backgroundUploadCount)")
                            .foregroundColor(.green)
                    }
                    
                    if let lastUpload = backgroundManager.lastUploadDate {
                        HStack {
                            Text("Last Upload")
                            Spacer()
                            Text(lastUpload, style: .relative)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("Upload Status")) {
                    HStack {
                        Text("Current Status")
                        Spacer()
                        Text(statusText)
                            .foregroundColor(statusColor)
                    }
                    
                    if photoUploader.isUploading {
                        HStack {
                            Text("Progress")
                            Spacer()
                            Text("\(Int(photoUploader.uploadProgress * 100))%")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Section(header: Text("Actions")) {
                    Button("Start Manual Upload") {
                        photoUploader.startAutomaticUpload()
                    }
                    .foregroundColor(.blue)
                    
                    if photoUploader.isUploading {
                        Button("Stop Upload") {
                            photoUploader.stopAutomaticUpload()
                        }
                        .foregroundColor(.red)
                    }
                    
                    Button("Reset Statistics") {
                        photoUploader.uploadedCount = 0
                        backgroundManager.backgroundUploadCount = 0
                        backgroundManager.lastUploadDate = nil
                    }
                    .foregroundColor(.orange)
                }
                
                Section(header: Text("About"), footer: Text("This feature automatically uploads your favorited photos and videos to Instagram in the background, similar to Google Photos. Only media marked as favorites will be uploaded.")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Upload Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            isBackgroundUploadEnabled = backgroundManager.isBackgroundUploadEnabled
        }
    }
    
    private var statusText: String {
        switch photoUploader.uploadStatus {
        case .idle:
            return "Idle"
        case .uploading:
            return "Uploading"
        case .completed:
            return "Completed"
        case .failed(let error):
            return "Failed: \(error)"
        }
    }
    
    private var statusColor: Color {
        switch photoUploader.uploadStatus {
        case .idle:
            return .gray
        case .uploading:
            return .blue
        case .completed:
            return .green
        case .failed:
            return .red
        }
    }
}

struct UploadSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UploadSettingsView(
            photoUploader: PhotoUploader(),
            backgroundManager: BackgroundUploadManager(uploader: PhotoUploader())
        )
    }
} 
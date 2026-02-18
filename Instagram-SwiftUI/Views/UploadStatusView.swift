//
//  UploadStatusView.swift
//  Instagram-SwiftUI
//
//  Created by Assistant on 2024.
//

import SwiftUI

struct UploadStatusView: View {
    @ObservedObject var photoUploader: PhotoUploader
    @State private var showingUploadSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Upload status indicator
            if photoUploader.isUploading {
                uploadProgressView
            } else if case .completed = photoUploader.uploadStatus {
                uploadCompletedView
            } else if case .failed(let error) = photoUploader.uploadStatus {
                uploadFailedView(error: error)
            }
        }
        .sheet(isPresented: $showingUploadSheet) {
            UploadDetailView(photoUploader: photoUploader)
        }
    }
    
    private var uploadProgressView: some View {
        HStack(spacing: 12) {
            // Upload icon with animation
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    .frame(width: 24, height: 24)
                
                Circle()
                    .trim(from: 0, to: photoUploader.uploadProgress)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .frame(width: 24, height: 24)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.3), value: photoUploader.uploadProgress)
                
                Image(systemName: "icloud.and.arrow.up")
                    .font(.system(size: 10))
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Uploading photos...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                
                Text("\(photoUploader.uploadedCount) of \(photoUploader.totalCount) uploaded")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Details") {
                showingUploadSheet = true
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.blue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    private var uploadCompletedView: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.green)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Upload completed")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                
                Text("\(photoUploader.uploadedCount) photos uploaded")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("View") {
                showingUploadSheet = true
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.blue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    private func uploadFailedView(error: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 20))
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Upload failed")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(error)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Retry") {
                photoUploader.startAutomaticUpload()
            }
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.blue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct UploadDetailView: View {
    @ObservedObject var photoUploader: PhotoUploader
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Progress circle
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: photoUploader.uploadProgress)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.3), value: photoUploader.uploadProgress)
                    
                    VStack {
                        Text("\(Int(photoUploader.uploadProgress * 100))%")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Complete")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Upload stats
                VStack(spacing: 16) {
                    HStack {
                        Text("Uploaded")
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        Text("\(photoUploader.uploadedCount)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("Total")
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        Text("\(photoUploader.totalCount)")
                            .font(.system(size: 16, weight: .bold))
                    }
                    
                    HStack {
                        Text("Remaining")
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                        Text("\(photoUploader.totalCount - photoUploader.uploadedCount)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.orange)
                    }
                }
                .padding(.horizontal, 20)
                
                // Status message
                VStack(spacing: 8) {
                    Image(systemName: statusIcon)
                        .font(.system(size: 40))
                        .foregroundColor(statusColor)
                    
                    Text(statusMessage)
                        .font(.system(size: 18, weight: .medium))
                        .multilineTextAlignment(.center)
                    
                    if case .failed(let error) = photoUploader.uploadStatus {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
                
                // Action buttons
                if photoUploader.isUploading {
                    Button("Stop Upload") {
                        photoUploader.stopAutomaticUpload()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                } else if case .completed = photoUploader.uploadStatus {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                } else if case .failed = photoUploader.uploadStatus {
                    Button("Retry") {
                        photoUploader.startAutomaticUpload()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Upload Status")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private var statusIcon: String {
        switch photoUploader.uploadStatus {
        case .idle:
            return "icloud"
        case .uploading:
            return "icloud.and.arrow.up"
        case .completed:
            return "checkmark.circle.fill"
        case .failed:
            return "exclamationmark.triangle.fill"
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
            return .orange
        }
    }
    
    private var statusMessage: String {
        switch photoUploader.uploadStatus {
        case .idle:
            return "Ready to upload"
        case .uploading:
            return "Uploading favorited photos..."
        case .completed:
            return "Upload completed successfully!"
        case .failed:
            return "Upload failed"
        }
    }
}

struct UploadStatusView_Previews: PreviewProvider {
    static var previews: some View {
        UploadStatusView(photoUploader: PhotoUploader())
    }
} 
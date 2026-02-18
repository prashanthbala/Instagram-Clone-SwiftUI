//
//  TimeLineView.swift
//  Instagram-SwiftUI
//
//  Created by Pankaj Gaikar on 03/04/21.
//

import SwiftUI

struct TimeLineContainerView: View {
    @EnvironmentObject var photoUploader: PhotoUploader
    @EnvironmentObject var backgroundManager: BackgroundUploadManager
    @State private var showingUploadAlert = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Upload status view at the top
                if photoUploader.isUploading || photoUploader.uploadStatus != .idle {
                    UploadStatusView(photoUploader: photoUploader)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(MockData().stories) {
                                StoryView(story: $0)
                            }
                        }
                    }
                    ForEach(MockData().posts) {
                        PostView(post: $0, screenWidth: UIScreen.main.bounds.size.width)
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("instagram")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 130)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            showingUploadAlert = true
                        }) {
                            Image(systemName: "plus.app")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.primary)
                        }
                        .padding(.trailing, 10)
                        
                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.primary)
                        }
                        .padding(.trailing, 10)
                        
                        NavigationLink(destination: MessagesContainerView()) {
                            Image(systemName: "message")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                    }
                }
            })
//            .alert("Auto Upload", isPresented: $showingUploadAlert) {
//                Button("Start Upload") {
//                    photoUploader.startAutomaticUpload()
//                }
//                Button("Settings") {
//                    showingSettings = true
//                }
//                Button("Cancel", role: .cancel) { }
//            } message: {
//                Text("This will automatically upload all your favorited photos and videos to Instagram in the background, similar to Google Photos.")
//            }
//            .sheet(isPresented: $showingSettings) {
//                UploadSettingsView(photoUploader: photoUploader, backgroundManager: backgroundManager)
//            }
        }
    }
}

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLineContainerView()
            .environmentObject(PhotoUploader())
            .environmentObject(BackgroundUploadManager(uploader: PhotoUploader()))
    }
}

//
//  Instagram_SwiftUIApp.swift
//  Instagram-SwiftUI
//
//  Created by Pankaj Gaikar on 03/04/21.
//

import SwiftUI

@main
struct Instagram_SwiftUIApp: App {
    @StateObject private var photoUploader = PhotoUploader()
    @StateObject private var backgroundManager: BackgroundUploadManager
    
    init() {
        let uploader = PhotoUploader()
        self._photoUploader = StateObject(wrappedValue: uploader)
        self._backgroundManager = StateObject(wrappedValue: BackgroundUploadManager(uploader: uploader))
    }
    
    var body: some Scene {
        WindowGroup {
            RootContainerView()
                .environmentObject(photoUploader)
                .environmentObject(backgroundManager)
        }
    }
}

# Instagram-SwiftUI
An attempt make a Instagram clone with SwiftUI. It is all about cloning the UI and not functionality. I am thinking if I should add functionality to this.

Implemented screens
- Home ✅
- Search ✅
- Reels ✅
- Activity ✅
- Profile ✅
- iOS Dark Mode/Light Mode ✅
- **Auto Upload Feature** ✅ (NEW!)

## New Auto Upload Feature

The app now includes a Google Photos-like automatic upload system that:

### 🚀 **Key Features**
- **Automatic Background Upload**: Uploads favorited photos and videos automatically
- **Smart Detection**: Only uploads media marked as favorites
- **Background Processing**: Continues uploading even when app is in background
- **Progress Tracking**: Real-time upload progress with beautiful UI
- **Settings Management**: Comprehensive upload settings and statistics
- **Permission Handling**: Proper photo library access with user consent

### 📱 **How to Use**
1. **Tap the Upload Button** (+ icon) in the home or profile screen
2. **Grant Photo Library Permission** when prompted
3. **Start Auto Upload** to begin uploading favorited media
4. **Monitor Progress** through the upload status view
5. **Configure Settings** via the gear icon for advanced options

### ⚙️ **Upload Settings**
- Enable/disable background upload
- Upload only on Wi-Fi
- Upload only when charging
- Auto-upload favorited media
- View upload statistics and history

### 🎯 **Technical Implementation**
- **PhotoUploader**: Core upload management with progress tracking
- **BackgroundUploadManager**: Background task scheduling and monitoring
- **UploadStatusView**: Beautiful progress UI with animations
- **UploadSettingsView**: Comprehensive settings interface
- **Photo Library Integration**: Native iOS photo access with permissions

### 🔧 **Architecture**
```
PhotoUploader (Core Upload Logic)
├── Permission Management
├── Asset Detection (Favorites Only)
├── Progress Tracking
└── Upload Simulation

BackgroundUploadManager (Background Tasks)
├── Background Task Scheduling
├── Photo Library Monitoring
├── New Media Detection
└── Statistics Tracking

UI Components
├── UploadStatusView (Progress Display)
├── UploadSettingsView (Configuration)
└── Integration with Main App
```

Work Needed 
- Functionality 🔜
- Messages 🔜

# Images -
## Dark Mode -
![alt tag](https://github.com/PankajGaikar/Instagram-SwiftUI/blob/main/Screenshots/IMG_1607.PNG)
![alt tag](https://github.com/PankajGaikar/Instagram-SwiftUI/blob/main/Screenshots/activity-dark.PNG)
![alt tag](https://github.com/PankajGaikar/Instagram-SwiftUI/blob/main/Screenshots/profile-dark.PNG)
![alt tag](https://github.com/PankajGaikar/Instagram-SwiftUI/blob/main/Screenshots/reels-dark.PNG)
![alt tag](https://github.com/PankajGaikar/Instagram-SwiftUI/blob/main/Screenshots/search-dark.PNG)

## Light Mode -
![alt tag](https://github.com/PankajGaikar/Instagram-SwiftUI/blob/main/Screenshots/activity-light.PNG)
![alt tag](https://github.com/PankajGaikar/Instagram-SwiftUI/blob/main/Screenshots/home-light.jpeg)
![alt tag](https://github.com/PankajGaikar/Instagram-SwiftUI/blob/main/Screenshots/profile-light.PNG)
![alt tag](https://github.com/PankajGaikar/Instagram-SwiftUI/blob/main/Screenshots/reels-light.PNG)
![alt tag](https://github.com/PankajGaikar/Instagram-SwiftUI/blob/main/Screenshots/search-light.PNG)

Keywords - Instagram Clone. Swift. SwiftUI. iOS. Instagram Clone Tutorial. Instagram Clone with SwiftUI. Auto Upload. Google Photos. Background Upload. 

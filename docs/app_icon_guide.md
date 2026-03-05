# App Icon Guide

## Icon Design Specifications

### App Icon (Launcher)
- **Size**: 1024x1024px
- **Format**: PNG with transparency
- **Design**: Modern notebook with gradient blue background
- **Corner Radius**: 22% (Apple standard)

### Icon Layers
1. **Background**: Linear gradient from #007AFF to #5856D6
2. **Notebook**: White outline with rounded corners
3. **Decoration**: Small pencil icon in bottom right
4. **Text**: "KPM" in center (optional)

### Color Palette
- Primary: #007AFF (Apple Blue)
- Secondary: #5856D6 (Purple)
- Accent: #FFFFFF (White)
- Shadow: rgba(0,0,0,0.2)

### Icon Generation
Required sizes for iOS:
- 1024x1024 (App Store)
- 180x180 (iPhone @3x)
- 167x167 (iPad Pro @2x)
- 152x152 (iPad @2x)
- 120x120 (iPhone @3x)
- 87x87 (iPhone @3x)
- 80x80 (iPhone @2x)
- 76x76 (iPad @1x)
- 60x60 (iPhone @2x)
- 58x58 (iPhone @2x)
- 40x40 (iPhone @2x)
- 29x29 (iPhone @1x)
- 20x20 (iPhone @1x)

Required sizes for Android:
- 512x512 (Play Store)
- 192x192 (xxxhdpi)
- 144x144 (xxhdpi)
- 96x96 (xhdpi)
- 72x72 (hdpi)
- 48x48 (mdpi)

### Tools for Icon Generation
- **Online**: Canva, Figma, Sketch
- **Code**: flutter_launcher_icons package
- **Manual**: Adobe Illustrator, Photoshop

### Flutter Launcher Icons Setup
Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon.png"
  adaptive_icon_background: "#007AFF"
  adaptive_icon_foreground: "assets/icons/app_icon_foreground.png"
```

Run:
```bash
flutter pub run flutter_launcher_icons
```

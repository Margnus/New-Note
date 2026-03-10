# Flutter 安装和配置指南

## 当前状态

✅ **已安装**:
- Flutter SDK (位于 C:\tools\flutter)
- Android SDK (位于 C:\Users\Administrator\AppData\Local\Android\Sdk)
- Chocolatey 包管理器
- Git

⚠️ **待配置**:
- Flutter 环境变量配置
- Flutter 首次初始化（可能需要网络连接）
- Android 模拟器创建

## 快速启动步骤

### 方法1：使用 Android Studio 运行项目（推荐）

#### 1. 打开项目
```bash
# 在 Android Studio 中
# File → Open → 选择 E:\work\StudioProjects\kpm 目录
```

#### 2. 等待 Gradle 同步
- Android Studio 会自动检测到 Flutter 项目
- 等待 Gradle 同步完成（首次可能需要几分钟）
- 点击 "Run" 按钮（绿色三角形）或按 Shift+F10

#### 3. 创建或选择模拟器
- 点击设备下拉菜单
- 如果有模拟器，直接选择并运行
- 如果没有，点击 "Device Manager" 创建新设备

### 方法2：使用命令行运行

#### 步骤1：配置环境变量

**临时配置（当前会话）**:
```powershell
# 在 PowerShell 中运行
$env:PATH = "C:\tools\flutter\bin;" + $env:PATH

# 验证
flutter --version
```

**永久配置**:
1. 右键"此电脑" → 属性
2. 高级系统设置 → 环境变量
3. 在"系统变量"中找到 `Path`
4. 点击编辑 → 新建 → 添加 `C:\tools\flutter\bin`
5. 确定并重启终端

#### 步骤2：初始化 Flutter

```powershell
# 首次运行 Flutter（可能需要几分钟）
flutter doctor

# 安装依赖
flutter pub get

# 生成代码
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 步骤3：创建 Android 模拟器

**使用 Android Studio 创建**:
1. 打开 Android Studio
2. Tools → Device Manager
3. 点击 "Create Device"
4. 选择设备（推荐：Pixel 6 或 Pixel 7）
5. 选择系统镜像（推荐：Android 13 或 14）
6. 完成

**使用命令行创建**:
```bash
# 列出可用设备
sdkmanager --list | findstr "system-images"

# 创建 AVD（示例：Pixel 6, Android 13）
avdmanager create avd -n "Pixel_6" -k "system-images;android-33;google_apis_playstore;x86_64"

# 启动模拟器
emulator -avd Pixel_6
```

#### 步骤4：运行项目

```bash
# 进入项目目录
cd E:\work\StudioProjects\kpm

# 查看可用设备
flutter devices

# 运行到模拟器
flutter run

# 或运行到特定设备
flutter run -d <device_id>
```

### 方法3：处理 Flutter 初始化问题

如果 Flutter 初始化卡住（由于网络/代理问题），尝试：

#### 方案A：手动下载依赖

```bash
# 1. 手动下载 Flutter 的依赖包
# 访问 https://github.com/flutter/flutter/releases
# 下载最新的 stable 版本并解压到 C:\tools\flutter

# 2. 设置代理（如果需要）
$env:HTTP_PROXY="http://127.0.0.1:7897"
$env:HTTPS_PROXY="http://127.0.0.1:7897"

# 3. 禁用代理尝试
$env:NO_PROXY="*"

# 4. 使用国内镜像（推荐）
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"

# 5. 运行 Flutter
flutter --version
flutter doctor
```

#### 方案B：使用国内镜像

创建或编辑 `C:\tools\flutter\bin\.flutter_tool_env`:

```bash
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

然后运行：
```bash
flutter --version
```

#### 方案C：直接使用 Gradle 构建

```bash
cd E:\work\StudioProjects\kpm\android
./gradlew assembleDebug

# APK 将位于：build/app/outputs/flutter-apk/app-debug.apk
# 可以直接安装到设备或模拟器
adb install build/app/outputs/flutter-apk/app-debug.apk
```

## Android 模拟器创建指南

### 推荐配置

| 设备 | 系统 | API 级别 | CPU |
|------|------|---------|-----|
| Pixel 6 | Android 13 | 33 | x86_64 |
| Pixel 7 | Android 14 | 34 | x86_64 |
| Pixel 7 Pro | Android 14 | 34 | x86_64 |

### 详细步骤

1. **打开 AVD Manager**
   - Android Studio: Tools → Device Manager
   - 或命令行: `avdmanager`

2. **创建虚拟设备**
   - 点击 "Create Device"
   - 选择手机类型
   - 选择设备型号

3. **选择系统镜像**
   - 选择 Android 13 (API 33) 或更高
   - 确保选择了 Google APIs
   - 点击 "Next"

4. **配置设备**
   - AVD Name: 例如 "Pixel_6"
   - 启动方向: Portrait
   - 点击 "Finish"

5. **启动模拟器**
   - 在 Device Manager 中点击 "Play" 按钮
   - 或命令行: `emulator -avd Pixel_6`

## 常见问题解决

### 1. Flutter 命令未找到

**解决方案**:
```powershell
# 临时添加到 PATH
$env:PATH = "C:\tools\flutter\bin;" + $env:PATH

# 验证
flutter --version
```

### 2. Flutter 初始化卡住

**原因**: 网络连接或代理设置

**解决方案**:
- 使用国内镜像
- 禁用代理
- 手动下载依赖
- 使用 VPN

### 3. 模拟器启动慢

**解决方案**:
- 启用 HAXM (Intel) 或 Hyper-V (AMD)
- 在 AVD 设置中启用 "Graphics: Hardware - GLES 2.0"
- 分配更多 RAM（至少 2GB）
- 使用较新的系统镜像

### 4. Gradle 同步失败

**解决方案**:
```bash
cd android
./gradlew clean
./gradlew build

# 或使用国内 Gradle 镜像
# 编辑 android/build.gradle
allprojects {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/public' }
        google()
        jcenter()
    }
}
```

### 5. 缺少 Android SDK 组件

**解决方案**:
```bash
# 使用 Android Studio SDK Manager 安装
# Settings → Appearance & Behavior → System Settings → Android SDK

# 或使用命令行
sdkmanager "platform-tools"
sdkmanager "platforms;android-33"
sdkmanager "build-tools;33.0.0"
sdkmanager "system-images;android-33;google_apis_playstore;x86_64"
```

## 项目运行检查清单

运行前，确保：

- [ ] Flutter SDK 已安装并配置到 PATH
- [ ] 已运行 `flutter pub get`
- [ ] 已运行 `flutter pub run build_runner build`
- [ ] Android SDK 和 Platform-Tools 已安装
- [ ] 已创建 Android 模拟器
- [ ] 模拟器正在运行
- [ ] `flutter devices` 显示可用设备

## 推荐的工作流

### 日常开发

```bash
# 1. 进入项目目录
cd E:\work\StudioProjects\kpm

# 2. 启动模拟器（如果未运行）
emulator -avd Pixel_6

# 3. 运行应用
flutter run

# 4. 热重载（保存后按 'r'）
# 热重启（保存后按 'R'）
# 退出（按 'q'）
```

### 代码更新后

```bash
# 重新生成代码（如果修改了数据模型）
flutter pub run build_runner build --delete-conflicting-outputs

# 重新运行
flutter run
```

## 下一步

1. **选择方法**:
   - Android Studio（推荐）- 图形界面，易于使用
   - 命令行 - 更快，适合熟悉命令行的开发者

2. **配置环境**:
   - 添加 Flutter 到 PATH
   - 配置代理或使用国内镜像
   - 创建 Android 模拟器

3. **运行项目**:
   - `flutter pub get`
   - `flutter pub run build_runner build`
   - `flutter run`

## 需要帮助？

如果遇到问题，请提供以下信息：

1. 错误信息的完整输出
2. 运行的命令
3. Flutter 版本 (`flutter --version`)
4. Android SDK 版本
5. 操作系统版本

---

**祝开发愉快！** 🚀

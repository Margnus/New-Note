# Flutter 快速启动指南

## 问题说明

由于网络/代理问题，Flutter 首次初始化可能需要较长时间或卡住。以下是几种解决方案。

## 推荐方案

### ✅ 方案1：使用 init_flutter.bat 脚本（最简单）

1. **双击运行脚本**
   - 打开文件资源管理器
   - 导航到 `E:\work\StudioProjects\kpm`
   - 双击 `init_flutter.bat`
   - 等待脚本完成（可能需要 5-10 分钟）

2. **运行项目**
   ```bash
   flutter run
   ```

### ✅ 方案2：使用 Android Studio（推荐，无需 Flutter CLI）

1. **打开 Android Studio**
   - File → Open
   - 选择 `E:\work\StudioProjects\kpm` 目录
   - 等待项目加载

2. **配置 Flutter 插件**
   - File → Settings → Plugins
   - 搜索 "Flutter"
   - 安装 Flutter 插件
   - 重启 Android Studio

3. **运行项目**
   - 等待 Gradle 同步完成（首次需要几分钟）
   - 点击 "Run" 按钮（绿色三角形）
   - 选择或创建 Android 模拟器

### ⚙️ 方案3：手动配置环境（适合命令行用户）

#### 步骤1：配置环境变量

**临时配置（当前 PowerShell 会话）**:
```powershell
$env:PATH = "C:\tools\flutter\bin;" + $env:PATH
```

**永久配置**:
1. 按 Win 键，搜索 "环境变量"
2. 选择 "编辑系统环境变量"
3. 点击 "环境变量"
4. 在 "系统变量" 中找到 "Path"
5. 点击 "编辑" → "新建"
6. 添加 `C:\tools\flutter\bin`
7. 点击 "确定" 并关闭所有窗口

#### 步骤2：配置代理（如需要）

**如果使用代理**:
```powershell
$env:HTTP_PROXY="http://127.0.0.1:7897"
$env:HTTPS_PROXY="http://127.0.0.1:7897"
```

**如果代理导致问题，禁用代理**:
```powershell
$env:NO_PROXY="*"
```

#### 步骤3：使用国内镜像（推荐）

```powershell
# 设置 Flutter 国内镜像
$env:PUB_HOSTED_URL="https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"

# 验证设置
flutter --version
```

#### 步骤4：初始化 Flutter

```powershell
# 进入项目目录
cd E:\work\StudioProjects\kpm

# 安装依赖
flutter pub get

# 生成代码
flutter pub run build_runner build --delete-conflicting-outputs

# 查看可用设备
flutter devices

# 运行项目
flutter run
```

### 🐛 方案4：处理网络问题

如果 Flutter 初始化卡住，可能是以下原因：

#### 原因1：代理配置问题

**症状**: Flutter 命令没有输出或卡住

**解决方案**:
```powershell
# 禁用代理尝试
$env:NO_PROXY="*"
$env:HTTP_PROXY=""
$env:HTTPS_PROXY=""

flutter --version
```

#### 原因2：GitHub/Google 访问慢

**解决方案**: 使用国内镜像

创建文件 `C:\tools\flutter\bin\.flutter_tool_env`:
```bash
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

然后重新运行 Flutter。

#### 原因3：防火墙/杀毒软件拦截

**解决方案**:
- 暂时禁用防火墙/杀毒软件
- 或将 Flutter 添加到白名单
- 重新运行 Flutter 命令

## Android 模拟器创建

### 使用 Android Studio（推荐）

1. 打开 Android Studio
2. Tools → Device Manager
3. 点击 "Create Device"
4. 选择设备类型
5. 选择系统镜像（推荐：Pixel 6, Android 13）
6. 点击 "Finish"
7. 点击 "Play" 按钮启动模拟器

### 使用命令行

```bash
# 列出可用的系统镜像
sdkmanager --list | findstr system-images

# 创建模拟器（示例）
avdmanager create avd -n "Pixel_6" -k "system-images;android-33;google_apis_playstore;x86_64"

# 启动模拟器
emulator -avd Pixel_6
```

## 快速测试清单

运行项目前，确保：

- [ ] Flutter SDK 路径在 PATH 中
- [ ] 可以运行 `flutter --version`
- [ ] 已运行 `flutter pub get`
- [ ] 已运行 `flutter pub run build_runner build`
- [ ] Android 模拟器正在运行
- [ ] `flutter devices` 显示设备

## 故障排除

### 问题1：flutter 命令未找到

**错误**: `'flutter' 不是内部或外部命令`

**解决**:
```powershell
# 临时添加
$env:PATH = "C:\tools\flutter\bin;" + $env:PATH

# 验证
flutter --version
```

### 问题2：pub get 失败

**错误**: `pub get failed`

**解决**:
```bash
# 清理缓存
flutter clean
flutter pub cache repair

# 重新获取
flutter pub get
```

### 问题3：build_runner 失败

**错误**: `build_runner failed`

**解决**:
```bash
# 清理并重新生成
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 问题4：找不到 Android 设备

**错误**: `No devices found`

**解决**:
1. 确保 Android 模拟器正在运行
2. 检查 USB 调试是否启用（使用真机）
3. 运行 `adb devices` 检查设备

### 问题5：Gradle 同步失败

**解决**:
```bash
cd android
./gradlew clean
./gradlew build
```

## 推荐工作流

### 日常开发

```bash
# 1. 确保环境配置
$env:PATH = "C:\tools\flutter\bin;" + $env:PATH

# 2. 进入项目目录
cd E:\work\StudioProjects\kpm

# 3. 启动模拟器（如果未运行）
emulator -avd Pixel_6

# 4. 运行项目
flutter run

# 5. 热重载（按 r）
# 热重启（按 R）
# 退出（按 q）
```

### 修改代码后

```bash
# 如果修改了数据模型，重新生成
flutter pub run build_runner build --delete-conflicting-outputs

# 重新运行
flutter run
```

## 获取帮助

如果问题仍未解决：

1. 查看详细日志：
   ```bash
   flutter doctor -v
   ```

2. 清理并重新开始：
   ```bash
   flutter clean
   flutter pub get
   ```

3. 查看 Flutter 文档：
   - https://flutter.dev/docs
   - https://flutter.cn/docs (中文)

## 推荐操作步骤

**对于 Windows 用户，推荐按以下顺序尝试**:

1. ✅ **最简单**: 双击运行 `init_flutter.bat`
2. ✅ **最可靠**: 使用 Android Studio 图形界面
3. ✅ **最灵活**: 手动配置环境变量并使用命令行

---

**选择最适合你的方法开始吧！** 🚀

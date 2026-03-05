# KPM 快速开始指南

## 前置准备

### 1. 安装 Flutter

确保已安装 Flutter SDK (版本 >= 3.0.0):

```bash
flutter --version
```

如果没有安装，请访问 [Flutter 官网](https://flutter.dev/docs/get-started/install) 下载安装。

### 2. 配置开发环境

根据你的操作系统配置相应的开发环境：

- **Windows**: 安装 Android Studio 和 VS Code
- **macOS**: 安装 Xcode (用于 iOS 开发) 和 VS Code
- **Linux**: 安装 Android Studio 和 VS Code

### 3. 验证环境

运行以下命令验证环境配置：

```bash
flutter doctor
```

## 项目设置

### 1. 克隆项目

```bash
cd E:\work\StudioProjects\kpm
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 生成代码

项目使用代码生成，需要运行：

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. 准备资源文件

#### 应用图标（可选）
- 将 1024x1024px 的应用图标命名为 `app_icon.png`
- 放置到 `assets/icons/` 目录
- 运行 `flutter pub run flutter_launcher_icons` 生成各平台图标

#### 字体文件（可选）
- 将 SF Pro 字体文件放置到 `assets/fonts/` 目录
- 如果不需要自定义字体，可以暂时注释掉 `pubspec.yaml` 中的字体配置

## 运行项目

### 在模拟器/真机上运行

```bash
# 查看可用设备
flutter devices

# 运行到指定设备
flutter run -d <device_id>

# 或直接运行（自动选择设备）
flutter run
```

### 热重载和热重启

```bash
# 热重载（保存更改后按 r）
r

# 热重启（保存更改后按 R）
R

# 退出（按 q）
q
```

## 项目结构概览

```
kpm/
├── lib/                    # 源代码目录
│   ├── main.dart          # 应用入口
│   ├── core/              # 核心功能
│   ├── data/              # 数据层
│   ├── domain/            # 业务逻辑层
│   └── presentation/      # UI 层
├── assets/                # 资源文件
├── android/               # Android 平台配置
├── ios/                   # iOS 平台配置
├── web/                   # Web 平台配置
└── pubspec.yaml          # 项目配置文件
```

## 核心功能使用指南

### 1. 创建笔记

- 点击主页右下角的 `+` 按钮
- 输入标题和内容
- 点击保存按钮或返回键自动保存

### 2. 管理文件夹

- 点击右上角菜单 → 文件夹
- 点击 `+` 按钮创建新文件夹
- 点击文件夹查看其中的笔记

### 3. 使用标签

- 点击右上角菜单 → 标签
- 点击 `+` 按钮创建新标签
- 选择标签颜色
- 点击标签查看相关笔记

### 4. 搜索笔记

- 在主页顶部的搜索框输入关键词
- 支持搜索标题和内容
- 实时显示搜索结果

### 5. 切换视图

- 点击主页右上角的图标切换列表/网格视图

### 6. 切换主题

- 点击右上角菜单 → 设置
- 选择亮色/暗色/跟随系统

### 7. 回收站

- 点击右上角菜单 → 回收站
- 可以恢复或永久删除笔记

## 开发工作流

### 1. 添加新功能

```bash
# 1. 创建新的功能文件
# 2. 添加到 pubspec.yaml 依赖（如需要）
# 3. 运行 flutter pub get
# 4. 生成代码（如使用代码生成）
# 5. 运行 flutter run
```

### 2. 代码检查

```bash
# 代码分析
flutter analyze

# 代码格式化
dart format .
```

### 3. 运行测试

```bash
# 运行所有测试
flutter test

# 运行特定测试
flutter test test/widget_test.dart
```

### 4. 构建发布版本

#### Android
```bash
# 构建 APK
flutter build apk --release

# 构建 App Bundle (推荐用于 Google Play)
flutter build appbundle --release
```

#### iOS
```bash
# 构建 iOS 应用
flutter build ios --release
```

#### Web
```bash
# 构建 Web 应用
flutter build web
```

## 常见问题

### 1. 代码生成失败

**问题**: 运行 `build_runner` 时出现错误

**解决方案**:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. 数据库相关错误

**问题**: 运行应用时提示数据库相关错误

**解决方案**:
```bash
# 删除生成的代码
rm -rf .dart_tool/build
# 重新生成
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. 依赖冲突

**问题**: `flutter pub get` 时出现依赖冲突

**解决方案**:
```bash
# 清除缓存
flutter pub cache repair
# 重新获取依赖
flutter pub get
```

### 4. 模拟器无法启动

**问题**: 模拟器启动失败

**解决方案**:
- 检查 Android Studio 模拟器配置
- 确保 HAXM (Windows) 或 Hypervisor (macOS) 已启用
- 尝试使用真机调试

### 5. iOS 构建失败

**问题**: macOS 上构建 iOS 应用失败

**解决方案**:
```bash
# 安装 CocoaPods
sudo gem install cocoapods
# 进入 iOS 目录
cd ios
pod install
cd ..
# 重新构建
flutter build ios
```

## 调试技巧

### 1. 查看日志

```bash
# 运行时查看详细日志
flutter run --verbose
```

### 2. 性能分析

```bash
# 使用 Flutter DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

### 3. 断点调试

- 在 VS Code 中，点击代码行号设置断点
- 按 F5 或点击调试按钮启动调试
- 在断点处可以查看变量值、调用栈等

## 下一步

- 阅读 `PROJECT_SUMMARY.md` 了解项目详情
- 查看 `docs/` 目录下的文档
- 开始添加新功能或修复 bug
- 参与项目贡献

## 获取帮助

- 查看 [Flutter 官方文档](https://flutter.dev/docs)
- 查看 [Riverpod 文档](https://riverpod.dev/)
- 查看 [Drift 文档](https://drift.simonbinder.eu/)
- 在 GitHub 上提交 Issue

---

祝开发愉快！🚀

# KPM

<div align="center">

![KPM Logo](https://img.shields.io/badge/KPM-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

**一个现代化的离线优先笔记应用，采用 Apple 设计风格**

[功能特性](#功能特性) • [快速开始](#快速开始) • [项目结构](#项目结构) • [文档](#文档) • [贡献](#贡献)

</div>

---

## 简介

KPM 是一个基于 Flutter 开发的现代化笔记应用，采用 Apple 设计理念，提供简洁、优雅的用户体验。应用支持离线优先，数据本地存储，确保隐私安全，同时提供流畅的跨平台体验。

### 核心亮点

- 🎨 **现代简约设计** - Apple 风格的 UI 设计，优雅流畅
- 📱 **跨平台支持** - 支持 Android、iOS 和 Web 平台
- 💾 **离线优先** - 基于 SQLite 的本地存储，无需联网即可使用
- ⚡ **流畅体验** - 精心设计的动画和交互
- 🔒 **隐私安全** - 数据本地存储，隐私无忧

## 功能特性

### ✅ 已实现功能

#### 📝 笔记管理
- 创建、编辑、删除笔记
- 网格/列表视图切换
- 笔记置顶功能
- 按时间排序
- 最后编辑时间显示

#### ✏️ 富文本编辑器
- 基于 flutter_quill 的强大编辑器
- 支持粗体、斜体、下划线等格式
- 标题、列表、引用块支持
- 代码块和分割线
- Markdown 渲染
- 自动保存

#### 📁 文件夹管理
- 创建、编辑、删除文件夹
- 按文件夹分类笔记
- 文件夹内笔记管理
- 删除文件夹及其内容

#### 🏷️ 标签系统
- 创建、编辑、删除标签
- 自定义标签颜色
- 为笔记添加/移除标签
- 按标签筛选笔记

#### 🔍 搜索功能
- 全文搜索
- 实时搜索结果
- 搜索标题和内容
- 清空搜索

#### 🗑️ 回收站
- 软删除笔记
- 恢复已删除笔记
- 永久删除笔记
- 清空回收站

#### 🎨 主题系统
- 亮色主题
- 暗色主题
- 跟随系统主题
- Apple 风格配色

#### ✨ UI/UX
- 现代简约设计
- 流畅的动画效果
- 自定义组件
- 响应式布局
- 空状态页面

### 🚧 即将推出

#### 图片和附件
- 图片上传和预览
- 附件管理
- 文件类型支持

#### 分享和导出
- 分享笔记
- 导出为 Markdown/PDF
- 批量操作

#### 云端同步
- 用户认证
- 数据同步
- 跨设备支持

#### 高级功能
- 笔记模板
- 快捷键支持
- 手势操作
- 高级搜索

#### AI 辅助
- 智能分类
- 自动摘要
- 内容推荐

## 快速开始

### 前置要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / Xcode（用于原生开发）
- VS Code（推荐）

### 安装

```bash
# 克隆项目
git clone <repository-url>
cd kpm

# 安装依赖
flutter pub get

# 生成代码
flutter pub run build_runner build --delete-conflicting-outputs

# 运行应用
flutter run
```

### 快速体验

1. **创建笔记** - 点击右下角 `+` 按钮
2. **编辑笔记** - 使用富文本编辑器编写内容
3. **管理文件夹** - 在菜单中选择"文件夹"
4. **使用标签** - 在菜单中选择"标签"
5. **搜索笔记** - 在顶部搜索框输入关键词
6. **切换主题** - 在设置中选择主题模式

## 项目结构

```
kpm/
├── lib/
│   ├── main.dart                    # 应用入口
│   │
│   ├── core/                        # 核心功能
│   │   ├── constants/              # 常量定义
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   └── app_constants.dart
│   │   ├── theme/                  # 主题配置
│   │   │   └── app_theme.dart
│   │   └── utils/                  # 工具函数
│   │
│   ├── data/                        # 数据层
│   │   ├── database/               # 数据库
│   │   │   ├── app_database.dart
│   │   │   ├── app_database_class.dart
│   │   │   └── dao/                # 数据访问对象
│   │   ├── models/                 # 数据模型
│   │   ├── repositories/           # 仓储实现
│   │   └── datasources/            # 数据源
│   │
│   ├── domain/                      # 业务逻辑层
│   │   ├── entities/               # 实体定义
│   │   ├── repositories/           # 仓储接口
│   │   └── usecases/               # 用例定义
│   │
│   └── presentation/                # 表现层
│       ├── providers/              # 状态管理
│       ├── pages/                  # 页面
│       └── widgets/                # 组件
│           ├── common/             # 通用组件
│           └── note/               # 笔记组件
│
├── assets/                          # 资源文件
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── android/                         # Android 平台
├── ios/                             # iOS 平台
├── web/                             # Web 平台
│
├── docs/                            # 文档
│   ├── app_icon_guide.md
│   └── ...
│
├── pubspec.yaml                     # 项目配置
├── analysis_options.yaml           # 代码分析规则
├── .gitignore                       # Git 忽略文件
│
├── README.md                        # 项目说明
├── QUICK_START.md                   # 快速开始指南
├── PROJECT_SUMMARY.md               # 项目总结
└── FEATURES.md                      # 功能清单
```

## 技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Flutter | 3.x | 跨平台框架 |
| Dart | 3.x | 编程语言 |
| Riverpod | 2.x | 状态管理 |
| Drift | 2.x | SQLite ORM |
| flutter_quill | 9.x | 富文本编辑器 |
| Hive | 2.x | 轻量级存储 |
| uuid | 4.x | 唯一 ID 生成 |
| intl | 0.18.x | 国际化 |

## 架构设计

KPM 采用 Clean Architecture 架构模式，分为三层：

### 1. 表现层 (Presentation Layer)
- 负责 UI 渲染和用户交互
- 使用 Riverpod 进行状态管理
- 包含页面、组件和提供者

### 2. 业务逻辑层 (Domain Layer)
- 定义业务规则和用例
- 包含实体和仓储接口
- 与数据层解耦

### 3. 数据层 (Data Layer)
- 负责数据存储和检索
- 实现仓储接口
- 包含数据模型和数据源

## 数据库设计

### 主要数据表

```sql
-- 笔记表
Notes {
  id, title, content, folder_id,
  is_pinned, created_at, updated_at,
  is_deleted, deleted_at
}

-- 文件夹表
Folders {
  id, name, parent_id, created_at
}

-- 标签表
Tags {
  id, name, color
}

-- 笔记-标签关联表
NoteTags {
  note_id, tag_id
}
```

## 文档

- [快速开始指南](QUICK_START.md) - 详细的环境设置和使用教程
- [项目总结](PROJECT_SUMMARY.md) - 完整的项目功能和技术文档
- [功能清单](FEATURES.md) - 已实现和待开发的功能列表
- [应用图标指南](docs/app_icon_guide.md) - 应用图标设计规范

## 开发指南

### 代码规范

遵循 Dart 官方代码风格：

```bash
# 代码格式化
dart format .

# 代码分析
flutter analyze

# 运行测试
flutter test
```

### 提交规范

采用 Conventional Commits 规范：

```
feat: 新功能
fix: 修复 bug
docs: 文档更新
style: 代码格式调整
refactor: 重构
test: 测试相关
chore: 构建/工具相关
```

## 路线图

### v1.0.0 (当前) - MVP ✅
- ✅ 基础笔记功能
- ✅ 本地存储
- ✅ 基础编辑器
- ✅ 文件夹和标签

### v1.1.0 - 短期更新 🚧
- 🚧 图片上传
- 🚧 附件管理
- 🚧 分享功能
- 🚧 导出功能
- 🚧 UI 优化

### v2.0.0 - 中期更新 📅
- 📅 云端同步
- 📅 编辑器增强
- 📅 笔记模板
- 📅 快捷键支持

### v3.0.0 - 长期更新 🔮
- 🔮 协作编辑
- 🔮 AI 辅助
- 🔮 插件系统
- 🔮 知识图谱

## 贡献

欢迎贡献代码、报告问题或提出建议！

### 如何贡献

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'feat: Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

### 报告问题

请在 [Issues](../../issues) 页面提交问题，并尽可能提供：

- 详细的问题描述
- 重现步骤
- 预期行为
- 实际行为
- 环境信息（Flutter 版本、操作系统等）

## License

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 致谢

感谢以下开源项目：

- [Flutter](https://flutter.dev/)
- [Riverpod](https://riverpod.dev/)
- [Drift](https://drift.simonbinder.eu/)
- [flutter_quill](https://github.com/singerdmx/flutter-quill)

## 联系方式

- 作者: KPM Team
- 邮箱: support@kpm.app
- 网站: https://kpm.app

---

<div align="center">

**如果这个项目对你有帮助，请给我们一个 ⭐️**

Made with ❤️ by KPM Team

</div>

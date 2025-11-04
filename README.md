# DReader

一个基于Flutter实现的跨平台的Epub小说阅读软件

## 项目简介

DReader 是一款基于 Flutter 构建的跨平台 EPUB 阅读器，目的是提供一个私有化、可多端同步的云端书库方案。
项目采用客户端/服务端架构，配合自托管的服务端程序[DReader-Server](https://github.com/qqaazz2/DReader-Server)，可以便捷地管理个人书籍，并在不同设备间无缝同步阅读进度。

## 部分预览

### 移动端截图

<img width="150" height="300" alt="屏幕截图 2025-10-27 223144" src="https://github.com/user-attachments/assets/366c3248-f97a-43c1-912e-c888ae18da63" />
<img width="150" height="300" alt="屏幕截图 2025-10-27 222849" src="https://github.com/user-attachments/assets/1b86a66c-911a-4ec6-b68d-ee992eef88e2" />
<img width="150" height="300" alt="屏幕截图 2025-10-27 223003" src="https://github.com/user-attachments/assets/45e02ddf-524b-4f87-b349-62712b00f64c" />
<img width="150" height="300" alt="屏幕截图 2025-10-27 223034" src="https://github.com/user-attachments/assets/7e815f9c-0fb0-4756-9e9b-072cb5462d7b" />
<img width="150" height="300" alt="屏幕截图 2025-10-27 222749" src="https://github.com/user-attachments/assets/616d4795-faa7-4bb6-9059-f768dadaae1a" />
<img width="150" height="300" alt="屏幕截图 2025-10-27 222812" src="https://github.com/user-attachments/assets/ed3d6a95-7f14-4702-9e74-c80b089e7cc4" />

### 桌面端截图

<img width="300" height="200" alt="屏幕截图 2025-10-27 220930" src="https://github.com/user-attachments/assets/f27fde17-54d3-4cfa-a6ec-f2ffb482fbc1" />
<img width="300" height="200" alt="屏幕截图 2025-10-27 221209" src="https://github.com/user-attachments/assets/656c953d-74c1-4bc9-9189-ea6e09aa5044" />
<img width="300" height="200" alt="屏幕截图 2025-10-27 221220" src="https://github.com/user-attachments/assets/a3193d96-092f-46d8-81ac-4106b409ce06" />
<img width="300" height="200" alt="屏幕截图 2025-10-27 221637" src="https://github.com/user-attachments/assets/bf4e6cbb-164c-4f0b-a541-99001fb881b8" />
<img width="300" height="200" alt="屏幕截图 2025-10-27 222428" src="https://github.com/user-attachments/assets/e32d9168-ec39-463a-aa68-0c1079fa2bd0" />
<img width="300" height="200" alt="屏幕截图 2025-10-27 222547" src="https://github.com/user-attachments/assets/7719db2e-e3ab-40e3-bb6f-54c774578fc9" />
<img width="300" height="200" alt="屏幕截图 2025-10-27 222639" src="https://github.com/user-attachments/assets/8c138506-d288-4f94-b2c1-23bceb05793e" />

## 核心功能

- 📚本地解析: EPUB 文件解析完全基于 Dart 实现，在设备本地即可完成，无需依赖任何原生平台代码或第三方服务，保证了高效与纯粹。
- 👆手动扫描入库: 通过客户端的扫描按钮，您可以随时让服务端扫描指定文件夹内的 EPUB 文件，并将其整理成书籍和系列。
- ☁️多端同步: 在任何设备上都能接续上次的阅读进度，实现无缝阅读体验。
- 🏷️阅读状态: 通过简洁直观的图标，可以轻松区分书库中书籍，让阅读进度管理更加清晰有序
- 📱跨平台客户端: 基于 Flutter 开发，一套代码支持多种平台。

## 当前支持平台
- ✅Windows
- ✅Android
- ✅Web

## 开发环境设置

### 1. 环境要求

- Dart 3.81
- Flutter 3.32.5

### 2. 初始步骤

```bash
# 克隆项目
git clone https://github.com/qqaazz2/DReader.git
cd DReader

# 安装依赖
flutter pub get
```

### 3. 项目结构

```
├── lib/                   # 主源码目录
│   ├── common/            # 公共工具方法
│   ├── entity/            # 数据实体类定义
│   ├── epub/              # EPUB 文件解析与处理逻辑
│   ├── routes/            # 页面路由与导航
│   ├── state/             # 状态管理相关代码
│   ├── widgets/           # 公用 UI 控件
│
├── test/                  # 测试代码
│
├── android/               # Android 平台工程文件
├── web/                   # Web 平台工程文件
├── windows/               # Windows 平台工程文件
│
├── images/                # 静态资源（图片等）
│
├── pubspec.yaml           # 项目依赖与配置
├── pubspec.lock           # 依赖版本锁定文件
```

## 待实现功能

### 🚀 功能规划

- ~~⏱️ 阅读时长统计：自动记录并分析用户的阅读时长~~ ✔
- 📂 文件管理优化：支持本地文件阅读与上传，实现统一管理
- ~~⚙️ 设置页面完善：补充并优化功能模块~~ ✔
- ~~📖 阅读界面优化：支持字体大小调整、背景颜色切换等个性化体验~~ ✔
- 🏷️ 标签管理功能：系列以及书籍标签

## 许可证

MIT

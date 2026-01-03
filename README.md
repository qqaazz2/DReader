# DReader

<p align="center">
  <img src="https://github.com/user-attachments/assets/769f6598-1d55-4380-803d-fb7fee281451" alt="DReader Logo" width="400" />
</p>

一个基于Flutter实现的跨平台的Epub格式的轻小说阅读软件，支持多端同步阅读进度。[食用指南](https://qqaazz2.github.io/dreader-docs/)

## 初次登陆账密

账号：1@gmail.com
密码：1234561

## 项目简介

DReader 是一款基于 Flutter 构建的跨平台 EPUB 阅读器，目的是提供一个私有化、可多端同步的云端书库方案。
项目采用客户端/服务端架构，配合自托管的服务端程序[DReader-Server](https://github.com/qqaazz2/DReader-Server)，可以便捷地管理个人书籍，并在不同设备间无缝同步阅读进度。

## 部分预览

### 移动端截图
<img width="150" height="300" alt="mb1" src="https://github.com/user-attachments/assets/19ca2ad2-18eb-400e-85b5-9a42662d1ef1" />
<img width="150" height="300" alt="mb2" src="https://github.com/user-attachments/assets/b6b59ba1-6397-4255-a577-4a2e8baced10" />
<img width="150" height="300" alt="mb3" src="https://github.com/user-attachments/assets/f47af2ac-a68a-4e08-a9c1-a04aa8228cd6" />
<img width="150" height="300" alt="mb4" src="https://github.com/user-attachments/assets/b44c1915-c020-4908-9e6b-d3fd17a21094" />
<img width="150" height="300" alt="mb5" src="https://github.com/user-attachments/assets/8d554fac-36de-436c-ad7a-6925d3800881" />
<img width="150" height="300" alt="mb6" src="https://github.com/user-attachments/assets/b8dc9334-509e-4751-8bdf-57e7d83a7e94" />
<img width="150" height="300" alt="mb7" src="https://github.com/user-attachments/assets/6a825c14-b7cd-4aa5-b609-5ce6c93ff225" />
<img width="150" height="300" alt="mb8" src="https://github.com/user-attachments/assets/be90eded-eb46-408f-a740-22675e3f870e" />

### 桌面端截图
<img width="300" height="200" alt="pc1" src="https://github.com/user-attachments/assets/6cd3132a-e7c7-402d-abde-c080726d7814" />
<img width="300" height="200" alt="pc2" src="https://github.com/user-attachments/assets/914da892-3609-401f-8c51-ec4b039e2198" />
<img width="300" height="200" alt="pc3" src="https://github.com/user-attachments/assets/55fc3c7b-0b03-4687-9b01-cc64c391b1eb" />
<img width="300" height="200" alt="pc4" src="https://github.com/user-attachments/assets/a693d96c-8e78-4c6e-ba37-b28421425351" />
<img width="300" height="200" alt="pc5" src="https://github.com/user-attachments/assets/461feb31-a674-42f9-aeab-8aea1b267e8b" />
<img width="300" height="200" alt="pc6" src="https://github.com/user-attachments/assets/2d1dce7e-7c38-4fad-a6a7-d4dfe4020e54" />
<img width="300" height="200" alt="pc7" src="https://github.com/user-attachments/assets/c0294242-34c2-485a-bc92-6a0cb476d898" />
<img width="300" height="200" alt="pc8" src="https://github.com/user-attachments/assets/2e76ae92-79d3-47ed-a2e9-162172cad01f" />
<img width="300" height="200" alt="pc9" src="https://github.com/user-attachments/assets/7a9e1d33-a008-420a-8f1b-d82227daae79" />




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
- ~~🏷️ 标签管理功能：系列以及书籍标签~~ ✔

## 许可证

GPLv3

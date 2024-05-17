# Interview Guide 面试宝典

使用鸿蒙Ark框的Stage模型开发的轻量级面试APP，满足不同前端程序员的需求。







<!-- PROJECT LOGO -->
<br />

<p align="center">
  <a href="https://gitee.com/chiqingsan/my-harmony-project">
    <img src="./logo_image/logo.png" alt="Logo" width="80" height="80">
  </a>
<h2 align="center">Interview Guide</h2>
  <p align="center">
    点击下方链接，开始探索本项目！
    <br />
    <a href="https://gitee.com/chiqingsan/interview-guide"><strong>探索本项目的文档 »</strong></a>
    <br />
    <br />
    <a href="https://gitee.com/chiqingsan/interview-guide/releases/tag/v0.1.0">查看Demo</a>
    ·
    <a href="https://gitee.com/chiqingsan/interview-guide/issues">报告Bug</a>
    ·
    <a href="./entry/src/main/ets">进入Pages</a>
  </p>

</p>


本篇README.md面向开发者

## 目录

- [上手指南](#上手指南)
    - [开发前的配置要求](#开发前的配置要求)
- [文件目录说明](#文件目录说明)
- [开发的底层框架](#开发的底层框架)
- [业务的核心功能](#业务的核心功能)
- [使用技术](#使用技术)
- [项目亮点](#项目亮点)
- [部署](#部署)
- [贡献者](#贡献者)
    - [如何参与开源项目](#如何参与开源项目)
- [版本控制](#版本控制)

### 上手指南

###### 开发前的配置要求

1. Dev Eco Studio
2. SDK11 以上
3. Nodejs 18.14.1

### 文件目录说明

```
Interview Guide:
├─.hvigor
├─.idea
├─AppScope  // 应用配置信息
│  └─resources
├─dependencies
├─entry
│  └─src
│      ├─main
│      │  ├─ets
│      │  │  ├─common  // 公共组件
│      │  │  ├─entryability  // Ability配置信息
│      │  │  ├─pages  // 主要页面
│      │  │  └─views // 自定义组件
│      │  └─resources // 资源目录
│      │      ├─base
│      │      │  ├─element  // 通用语言配置
│      │      │  ├─media  // 公共媒体资源
│      │      │  └─profile  // 路由配置
│      │      ├─en_US  // 英文环境配置
│      │      ├─rawfile // 公共文件资源
│      │      └─zh_CN  // 中文环境资源
│      ├─mock
│      ├─ohosTest
│      └─test
├─hvigor
├─logo_image
└─oh_modules

```

<br>
<p align="center">
    <img src="./logo_image/Interview.gif" alt="Interview" width="280">
</p>
<br>


### 开发的底层框架

- 单Ability开发：结合应用使用场景，选择使用单UIAbility进行项目开发
- resource分类管理：对本地资源实现分类管理，提高后续可维护性
- 组件和功能模块化封装：对自定义组件以及功能进行模块化封装，提高代码的复用性和可维护性，加快开发效率
- 应用权限申请配置：对应用使用到的权限进行配置申请



### 业务的核心功能

- 登录：判断之前是否持久化保存过token，有则无需登录直接跳转首页
- 首页：题库分类，面试题长列表、点赞、收藏、反馈、富文本展示、面试题详情切换、面试题搜索
- 项目：企业级项目场景面试题展示、业务类问答、技术类问答
- 面经：大厂面试经验、文章阅读、试题阅读数据埋点
- 我的：打卡、打卡记录、学习时间统计、数据可视化、头像上传、编辑昵称、退出登录
- 历史记录：试题阅读记录、面经阅读记录
- 单词语音朗读：播放单词朗读音频，半模态展示用法，高亮其中的关键词
- AI面试：调用后端接口，完成AI面试对话功能



### 使用技术

- 基于 `API11` 使用 `ArtTS` 与 `ArtUI` 实现页面构建和状态管理
- 基于 `http` 封装请求工具类，实现接口响应数据泛型支持和参数处理与响应拦截
- 基于 `hilog` 封装自定义日志类，自定义日志打印的类型，打印的内存位置，打印的标识
- 基于 `window` 完成安全区域类的封装，完成页面的沉浸式显示
- 基于 `preferences` 封装持久化储存类，用于储存用户的基本信息，搜索记录和浏览记录
- 基于 `AppStorage` 实现用户信息缓存和访问权限控制
- 基于组件间传参+ `@watch` 完成页面刷新的逻辑处理
- 基于鸿蒙系统组件，抽象封装通用组件 `HdSearch.ets、CustomDialog、IvSkeleton、HdClockIn、HdRichText... `等
- 基于 `UIAbility` 和 `Page` 生命周期实现阅读实现埋点
- 基于 `RichText` 组件，完成页面的富文本显示，以及解决兼容问题
- 基于 `AVPlay` 模块完成音频文件的播放
- 基于 `fs` 读取和复制到应用沙箱环境实现文件上传，且完成数据回显功能
- 基于 `Web` 组件实现 webview 能力，实现用户协议和隐私协议功能
- 基于 `Web` 组件的runJavaScript方法，调用第三方函数，完成代码用法的关键词高亮展示
- 基于 `router` 都页面栈进行控制，完成页面栈维护和清理
- 基于 `emitter` 实现 `UIAbility` 进程内通信实现上传进度实时更新
- 基于显示动画，实现页面元素转场动画的自定义动画效果
- 使用自定义封装的骨架屏组件，完成页面加载中骨架屏的显示
- 使用鸿蒙第三方组件 `@ohmos/calendar` 完成打卡页面的日历展示
- 封装页面使用的常量，提高项目的可维护性，提高项目的可迭代能力

**整个项目涉及到鸿蒙原生能力应用，文件管理、网络管理、WebView、窗口管理完成项目需求**



### 项目亮点

- 通用类的封装，提高代码复用性，例如：封装了统一日志类、沉浸式模式类、请求处理类，数据持久化类等
- 通用组件(搜素组件、打卡组件、Loading组件，难易程度组件)、业务组件抽取（题目分类组件、题目列表组件、单个题目显示内容组件），方便业务的复用
- 鸿蒙原生应用与网页方法交互显示高亮代码
- 使用AVPlayer完成在线和本地音频的播放



### 部署

暂无

### 贡献者

请阅读**CONTRIBUTING.md** 查阅为该项目做出贡献的开发者。

#### 如何参与开源项目

贡献使开源社区成为一个学习、激励和创造的绝佳场所。你所作的任何贡献都是**非常感谢**的。

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### 版本控制

该项目使用Git进行版本管理。您可以在repository参看当前可用版本。

### 作者

chiqingsan@gmail.com

Discord:chiqingsan

*您也可以在贡献者名单中参看所有参与该项目的开发者。*
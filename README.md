# GoAgentX

GoAgentX 是一个 goagent 在 Mac OS X 下的图形界面控制软件，方便一般用户在 Mac OS X 上部署、配置和使用 goagent。

关于 goagent 的介绍请参见 <http://code.google.com/p/goagent/>。

## 功能

* 部署 goagent 服务端到 App Engine
* 图形化界面设置客户端连接参数
* MenuBar 图标，直接控制连接状态
* 启动时自动连接 goagent

## 要求

* Mac OS X 10.6 及以上版本系统
* 支持 64 位的 Intel CPU

## 如何使用

1. 申请 Google App Engine 并创建 appid
1. 前往 <http://code.google.com/p/goagent/> goagent v1.7.10 
1. 下载 GoAgentX <https://github.com/ohdarling/GoAgentX/downloads>
1. 运行 GoAgentX，根据提示安装 goagent
1. 进入 GoAgentX 服务端部署标签，填写相关信息后，点部署来部署 goagent 到 App Engine
1. 进入 GoAgentX 客户端设置标签，填写之前申请的 App Engine appid 以及服务密码，并根据实际情况选择连接方式和服务器
1. 进入 GoAgentX 状态标签，点击启动，如果显示启动成功则可以开始使用
1. 剩余使用方式步骤请参见 [goagent 简易教程](http://code.google.com/p/goagent/#简易教程)

如果需要 GoAgentX 自动在用户登录时自动运行，可以在

    系统偏好设置》用户与群组》登录项

中添加 GoAgentX 到自动启动程序列表。

## 程序截图

![程序截图](https://github.com/ohdarling/GoAgentX/raw/master/Screenshot.png)

## 如何编译

获取代码：

    git clone https://github.com/ohdarling/GoAgentX

然后打开 Xcode 项目 GoAgentX.xcodeproj 进行编译即可。

## 如何提问题

进入 <https://github.com/ohdarling/GoAgentX/issues/new> 页面填写需求信息或 Bug 即可。

当然，你也可以 fork 这个项目，修改后申请 Pull Request，我会尽快合并。

## 相关链接

* [goagent](http://code.google.com/p/goagent/)
* [Google App Engine](https://appengine.google.com/)

## 关于

你可以在 Twitter 上关注我：[@ohdarling88](http://twitter.com/ohdarling88)

## 许可

GoAgentX 代码使用 BSD-2 许可证，此外不允许将软件以完整二进制的方式进行公开发行（例如上传到 App Store 发布）。

    Copyright (c) 2012, Jiwei Xu
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    * Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.
    
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
    
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


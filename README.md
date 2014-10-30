# 静态资源缓存控制编译工具

前不久在 [知乎](http://zhihu.com) 上回答了一个问题：[大公司里怎样开发和部署前端代码？](http://www.zhihu.com/question/20790576/answer/32602154)。其中讲到了大公司在前端静态资源部署上的一些要求：

1. 配置超长时间的本地缓存 —— 节省带宽，提高性能
1. 采用内容摘要作为缓存更新依据 —— 精确的缓存控制
1. 静态资源CDN部署 —— 优化网络请求
1. 更资源发布路径实现非覆盖式发布 —— 平滑升级

其中比较复杂的部分就是 ``以文件的摘要信息为依据，控制缓存更新与非覆盖式发布`` 这个细节。因此基于 [fis](http://fis.baidu.com) 包装了一个简单的命令行工具，并设立此项目，用于演示这部分功能。

这个工具基于 [fis](http://fis.baidu.com) 的小工具是完全可以用作工程中的，有任何问题可以在 [这里](https://github.com/fouber/blog/issues/5) 留言。

请跟着下面的步骤来使用这个命令行小工具：

## 第一步：安装工具

这个命令行小工具依赖 [nodejs](http://nodejs.org/) 环境，因此，请先确保本地安装了它。

使用 [nodejs](http://nodejs.org/) 随带的 [npm](https://www.npmjs.org/) 包管理工具进行安装：

```bash
npm install -g rsd
```

## 第二步：创建项目

在 ``命令行`` 下clone本仓库，或者自己创建一个新的项目，并进入：

```bash
mkdir rsd-project  # 项目名任意
cd rsd-project
```

在项目根目录下创建一个空的 ``fis-conf.js`` 文件，这是工具配置，什么都不用写，空着就行。

然后开始在项目目录下，随意创建或添加 页面、脚本、样式、图片、字体、音频、视频等等前端资源文件，正常写前端代码吧！

## 第三步：发布代码

在项目根目录下执行：

```bash
rsd release --md5 --dest ../output
```

然后去到 ``../output`` 目录下去查看一下产出结果吧，所有静态资源都以md5摘要形式发布了出来，所有资源链接，我说 **所有链接**，包括html中的图片、样式、脚本以及js中的资源地址、css中的资源地址全部都加上了md5戳。

上述命令中，``--md5`` 就是表示要给所有资源定位标记加上摘要信息的意思，不加这个参数就没有摘要信息处理。``--dest ../output`` 表示把代码发布到当前目录上一级的output目录中。整个这条命令还可以简写成：

```bash
rsd release -m -d ../output
```

或者进一步连写成：

```bash
rsd release -md ../output
```

## 在本地服务器中浏览发布代码

你本地安装了诸如 Apache、Nginx、Lighttpd、IIS等服务器么？如果安装了，假设你的服务器 ``根目录`` 在 d:\\wwwroot，你可以利用rsd工具的release命令，把代码发布过去，比如：

```bash
rsd release -md d:\wwwroot
```

这样就把代码发布到了本地服务器根目录下，然后就可以在浏览器中查看效果了！

如果你本地没有安装任何服务器，你可以使用rsd内置的调试服务器，执行命令：

```bash
rsd server start
```

接下来我们同样要把代码发布到这个内置服务器中，release命令如果省略 ``--dest <path>``参数，就表示把代码发布到内置服务器的根目录下：

```bash
rsd release -m
```

在浏览器中访问： http://localhost:8080 即可

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

## 一些小技巧

1. rsd集成了对很多前端编程语言的支持，包括：
    * 类CSS语言：[less](http://www.lesscss.net/), [sass](http://sass-lang.com/), [scss](http://sass-lang.com/), [stylus](http://learnboost.github.io/stylus/)
    * 类JS语言：[coffee-script](http://coffeescript.org/)
    * 类HTML语言：[markdown](http://zh.wikipedia.org/wiki/Markdown), [jade](http://jade-lang.com/)
    * 前端模板：[handlebars-v1.3.0](http://handlebarsjs.com/), [EJS](http://www.embeddedjs.com/)
1. 内置了压缩器，在release的时候追加 ``-o`` 或者 ``--optimize`` 参数即可开启，压缩器包括：
    * [clean-css](https://github.com/jakubpawlowicz/clean-css): 压缩所有类CSS语言代码
    * [uglify-js](http://lisperator.net/uglifyjs/): 压缩所有类JS语言代码
    * [html-minifier](http://kangax.github.io/html-minifier/): 压缩所有类HTML语言代码
1. 还可以给资源加CDN域名，在release的时候追加 ``-D`` 或者 ``--domains`` 参数即可，域名配置写在fis-conf.js里：
    ```javascript
    // fis-conf.js
    fis.config.set('roadmap.domain', [ 'http://localhost:8080' ]);
    ```
1. 所有常规代码中的资源定位接口都会经过工具处理，包括：
    * 类CSS文件中：
        * 背景图url
        * font-face字体url
        * ie特有的滤镜属性中的src
    * 类JS文件中：
        * 提供了一个叫 ``__uri('path/to/file')`` 的编译函数用于定位资源
    * 类HTML文件中：
        * link标签的href属性
        * script, img, video, audio, object 等标签的src属性
        * script标签中js代码里的资源定位标记
        * style标签中css代码里的资源定位标记
1. 所有资源文件可以任意相互引用，工具会处理资源定位标记，使之服从知乎回答中提到的优化策略。
1. 还提供了资源内嵌的编译接口，用于把一个资源的内容以文本、字符串或者base64的形式嵌入到 ``任意`` 一个文本文件中。
1. 为了不用每次保存代码就执行一下release命令，工具中提供了文件监听和浏览器自动刷新功能，只要在release的时候在追加上 ``-w`` 和 ``-L`` 两个参数即可（注意L的大小写），比如：
    ```bash
    rsd release -omwL  #压缩、加md5戳、文件监听、浏览器自动刷新
    ```

## 关于这个小工具

它的原码在 [这里](https://github.com/fouber/static-resource-digest)。是的，就这么一点点代码，花了大概半小时写完的，因为一切都在 [fis](http://fis.baidu.com) 中集成好了，我只是追加几个语言编译插件而已。

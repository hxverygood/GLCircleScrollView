# GLCircleScrollView
**本项目是GLCircleScrollView的fork项目，对代码和功能进行了一定的增加和修改**
1. 增加了网络图片加载第三方库[Kingfisher](https://github.com/onevcat/Kingfisher)；
2. 代码主要逻辑没有变，重写了部分代码，使用时可指定UIPageControl的位置、颜色等；
3. 使用便利构造方法创建该组件，给`imageUrlArray`传图片的url字符串，即可实现图片网络加载；
4. 增加点击图片获取图片index和url的Block方法
---

*本项目原描述：*
### 无限循环轮播图
GLCircleScrollView 有以下主要功能：
1. 无限循环轮播
2. 图片点击代理
3. 可设置图片Url的数组（如果要赋url数组的话，最好自己改成sd加载图片的方式）

    ![](https://github.com/god-long/GLCircleScrollView/raw/master/Circle.gif) 

使用方法：

> 下载后直接把CirCleView.swift这个文件拉进项目中即可。
   
  *这个基本上是最简单的版本了，后续会添加一些其他的功能*
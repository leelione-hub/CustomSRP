# GrabPass

### 粘一个介绍比较全面的[文章](https://zhuanlan.zhihu.com/p/342351401)

## 使用
- GrapPass { } 是每次Drawcall中的Shader的GrabPass使用时都会中屏幕内容抓取一次绘制的内容，并保存在默认的命为_GrabTexture的纹理中
- GrabPass { “TheGrabTextureName” } 是每一帧Drawcall中的Shader的GrabPass中，
  第一次调用该GrabPass抓取的内容，保存在TheGrabTextureName的纹理中，
  后面Drawcall或是pass调用的GrabPass { "TheGrabTextureName" }只要TheGrabTextureName纹理名字与之前的
  GrabPass { "TheGrabTextureName" }中的TheGrabTextureName相同，
  都不会再执行GrabPass的过程，而直接使用之前Grab好的纹理对象内容。

## 实现 参考这篇[博客](https://blog.csdn.net/linjf520/article/details/104655402)
- gles下使用ReadPixels()函数，从cpu到gpu的逆向传输，这是非常缓慢的过程，并且是阻塞模式;
- 可以参考这篇性能测试的[文章](https://zhuanlan.zhihu.com/p/83507625);

## 关于GrabPass引申出的一些问题
- ***既然GrabPass消耗很高甚至在一些老的手机平台还不支持，有哪些方案可以替代GrabPass?***
  - OnRenderImage OnRenderImage是Camera的一个回调，相机每次渲染后都会调用，
    官方给的后处理方法都是用这个来实现的。这里我们新建一个C#脚本，然后挂在相机上，只做一个单纯的Graphic.Blit操作。
  - TargetTexture 申请一个新的RenderTexture，然后把Camera.targetTexture设置为新的RenderTexture，
    再把这个RenderTexture作为贴图传递给shader进行计算。

## 这里有一个高效实现屏幕扭曲的[方案](https://blog.csdn.net/qq18052887/article/details/50457680)   
我们大多使用GrabPass去实现一个类似扭曲的效果，所以可以参考这里的实现方案

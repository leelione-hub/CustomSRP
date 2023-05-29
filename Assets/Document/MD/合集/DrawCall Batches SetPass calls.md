# DrawCall Batches SetPass calls
### 详细介绍:[1.原理](https://zhuanlan.zhihu.com/p/353856280) \ [2.汇总](https://www.jianshu.com/p/55702c878ce4)

## 一些基础概念
- 所有CPU调用图形API都可以称作一次DrawCall
- 一个Batches可以包含一个或多个DrawCall (个人理解内容:假设一次动态合批处理合并了3个模型，可以视为三个DrawCall一个Batches)
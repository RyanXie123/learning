

卡顿：最主要的是主线程卡顿，比如大文件读写、在渲染周期执行了大量计算

App的启动3个过程

1. main()函数执行前
2. main()函数执行后
3. 首屏渲染后


**在main()函数执行前：**
* 加载可执行文件 .o文件
* 加载动态链接库，进行rebase指针调整和bind符号绑定
* objc运行时的初始化 包括Objc相关类的注册、category注册、selector唯一性检测
* 初始化，包括+load()方法、attribute(constructor)修饰函数的调用、创建C++静态全局变量


优化：
* 减少动态库的数量  进行动态库的合并
* 减少加载启动后不会用的类和方法
* +load() 少放方法，尽量放到首屏渲染后 （交换方法会造成4毫秒消耗）
* 控制c++全局变量


**main()函数执行后：**
从main() 到appDelegate 的 didFinishLaunchi

* 首屏初始化 配置文件 数据 渲染计算

优化
* 梳理哪些是首屏渲染必要的初始化功能
* App启动必要的初始化功能
* 哪些可以懒初始化


**功能级别的优化**

只处理首屏相关业务 
![image](https://static001.geekbang.org/resource/image/f3/19/f30f438d447e81132dd520e657427419.png)


**方法级别的优化**




**耗时监控**

1. 定时抓取主线程上的方法调用堆栈，计算一段方法里各个方法的耗时  Time Profiler 缺点 精度不够，但是够用
2. 对objc_msgSend方法进行hook来掌握所有方法的执行耗时


objc_msgSend是用汇编语言写的


**dyld = the dynamic link editor**
苹果的动态链接器，加载动态库

是苹果系统的重要组成部分，在系统内核做好准备工作后，交由dyld负责余下的工作，开源，

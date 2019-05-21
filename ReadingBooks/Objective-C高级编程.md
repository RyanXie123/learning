
[toc]

#### 2.3.1 blcok的实质
通过 clang -rewrite-objc  变换为C++代码



```objc
int main(){
    void(^blk)(void) = ^ {
        printf("Blcok\n");
    };
    blk();
    return 0;
}
```


```C
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    
    printf("Blcok\n");
}

static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
int main(){
    void(*blk)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));
    ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
    return 0;
}

```


#### 理解Objective-C类和对象的本质

#### 2.3.2截取自动变量


```objc
int main(){
    int dmy = 256;
    int val = 10;
    const char *fmt = "val = %d\n";
    void(^blk)(void) = ^ {
        printf(fmt,val);
    };
    blk();
    return 0;
}
```


```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  const char *fmt;
  int val;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, const char *_fmt, int _val, int flags=0) : fmt(_fmt), val(_val) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};


static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  const char *fmt = __cself->fmt; // bound by copy
  int val = __cself->val; // bound by copy

        printf(fmt,val);
}


int main(){
    int dmy = 256;
    int val = 10;
    const char *fmt = "val = %d\n";
    void(*blk)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, fmt, val));
    ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
    return 0;
}
```


**block自动截获变量只针对block中使用的对象**

**截获自动变量时，将值传递给结构体的构造函数进行保存**


#### 2.3.3__block说明符
如何解决block无法修改外部变量

- 方法1  静态变量、静态全局变量、全局变量
- 方法2 __block


```c
int global_val = 1;
static int static_global_val = 2;


struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  int *static_val;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int *_static_val, int flags=0) : static_val(_static_val) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  int *static_val = __cself->static_val; // bound by copy

        global_val *= 1;
        static_global_val *= 2;
        (*static_val) *= 3;
    }

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
int main() {
    static int static_val = 3;

    void (*blk)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, &static_val));

    return 0;
}
```

**从上面的代码可以看出静态变量static_val是使用指针访问，将静态变量static_val的指针传递给__main_block_impl_0结构体的构造函数并保存。**

**问题**：静态变量的这种方法似乎同样适用于局部变量的访问


```
int main() {
    __block int val = 10;
    void (^blc)(void) = ^{
        val = 1;
    };
    
    blc();
    printf("%d",val);
    return 0;
}

```

```
struct __Block_byref_val_0 {
  void *__isa;
__Block_byref_val_0 *__forwarding;
 int __flags;
 int __size;
 int val;
};

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __Block_byref_val_0 *val; // by ref
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_val_0 *_val, int flags=0) : val(_val->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  __Block_byref_val_0 *val = __cself->val; // bound by ref

        (val->__forwarding->val) = 1;
    }
static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->val, (void*)src->val, 8/*BLOCK_FIELD_IS_BYREF*/);}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->val, 8/*BLOCK_FIELD_IS_BYREF*/);}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};
int main() {
    __attribute__((__blocks__(byref))) __Block_byref_val_0 val = {(void*)0,(__Block_byref_val_0 *)&val, 0, sizeof(__Block_byref_val_0), 10};
    void (*blc)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, (__Block_byref_val_0 *)&val, 570425344));

    ((void (*)(__block_impl *))((__block_impl *)blc)->FuncPtr)((__block_impl *)blc);
    printf("%d",(val.__forwarding->val));
    return 0;
}
```

两个问题
- Blcok超出变量作用域可存在的理由
- __block变量的结构体成员变量 __forwarding 存在的理由
- copy dispose的作用



#### 2.3.4 Blcok存储域




### GCD
#### 3.1 GCD 简介
**多线程的坏处**
- 数据竞争
- 死锁
- 消耗内存

好处：提高程序的响应性能


#### 3.2GCD API


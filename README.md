# BTOperations
NSOperation高级用法
<<<<<<< HEAD

=======
## NSOperation基础

写了篇关于Operationj基础的文章 👋 
[NSOperation 高级用法之NSOperation基础（NSOperation源码分析）（上）](http://www.jianshu.com/p/16dd443f4cf2)
>>>>>>> 66f9247e49400f3e2883caa6805f33132e1e4e88
## BTGroupOperation使用
```
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op1");
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op2");
    }];
    [op2 addDependency:op1];
    
    BTGroupOperation *gop = [[BTGroupOperation alloc] initWithOperations:@[op1,op2]];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op3");
    }];
    [op3 addDependency:op2];
    
    [[NSOperationQueue currentQueue] addOperation:gop];
    [[NSOperationQueue currentQueue] addOperation:op3];

    
    ```



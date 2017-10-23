# BTOperations
NSOperation高级用法

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



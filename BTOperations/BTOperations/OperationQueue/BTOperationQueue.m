//
//  BTOperationQueue.m
//  BTOperations
//
//  Created by BYTE on 2017/10/22.
//

#import "BTOperationQueue.h"
#import "BTOperation.h"
@implementation BTOperationQueue
- (void)addOperation:(NSOperation *)op {
    [super addOperation:op];
    __weak __typeof(&*op)weakOp = op;
    __weak __typeof(&*self)weakSelf = self;
    op.completionBlock = ^{
        if ([weakSelf.delegate respondsToSelector:@selector(operationQueue:operationDidFinish:)]) {
            [weakSelf.delegate operationQueue:weakSelf operationDidFinish:weakOp];
        }
    };
    if ([op isKindOfClass:[BTOperation class]]) {
        [(BTOperation *)op didEnqueue];
    }
}
@end

//
//  TestCondition.m
//  BTOperationsDemo
//
//  Created by BYTE on 2017/12/1.
//

#import "TestCondition.h"

@implementation TestCondition
- (void)evaluateForOperation:(BTOperation *)operation complete:(void (^)(NSInteger))complete {
    NSLog(@"test condition complete %@",operation);
    complete(1);
}
@end

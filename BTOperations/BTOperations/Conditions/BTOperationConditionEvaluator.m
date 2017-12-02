//
//  BTOperationConditionEvaluator.m
//  BTOperations
//
//  Created by BYTE on 2017/12/1.
//

#import "BTOperationConditionEvaluator.h"
#import "BTOperation.h"
#import "BTOperationCondition.h"
@implementation BTOperationConditionEvaluator

- (void)evaluateWithConditions:(NSArray *)conditions operation:(BTOperation *)operation complete:(void(^)(NSArray *failures))completeBlock {
    dispatch_group_t conditionGroup = dispatch_group_create();
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (NSInteger idx = 0;idx < conditions.count;idx++) {
        BTOperationCondition *condition = conditions[idx];
        dispatch_group_enter(conditionGroup);
        [condition evaluateForOperation:operation complete:^(NSInteger result) {
            results[idx] = @(result);
            dispatch_group_leave(conditionGroup);
        }];
    }
    dispatch_group_notify(conditionGroup, dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *failures = [NSMutableArray new];
        for (NSNumber *number in results) {
            if ([number integerValue]) {
                [failures addObject:number];
            }
        }
        completeBlock(failures);
    });
}

@end

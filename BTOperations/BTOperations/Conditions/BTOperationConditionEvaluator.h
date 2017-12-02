//
//  BTOperationConditionEvaluator.h
//  BTOperations
//
//  Created by BYTE on 2017/12/1.
//

#import <Foundation/Foundation.h>
@class BTOperation;
@interface BTOperationConditionEvaluator : NSObject
- (void)evaluateWithConditions:(NSArray *)conditions operation:(BTOperation *)operation complete:(void(^)(NSArray *failures))completeBlock;
@end

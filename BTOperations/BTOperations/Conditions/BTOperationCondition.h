//
//  BTOperationCondition.h
//  BTOperations
//
//  Created by BYTE on 2017/12/1.
//

#import <Foundation/Foundation.h>
@class BTOperation;
@interface BTOperationCondition : NSObject
- (void)evaluateForOperation:(BTOperation *)operation complete:(void(^)(NSInteger result))complete;
@end

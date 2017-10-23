//
//  BTOperation.h
//  BTOperations
//
//  Created by BYTE on 2017/10/22.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,BTOperationState)
{
    BTOperationStateReady,
    BTOperationStateExecuting,
    BTOperationStateFinished,
    //Support for cancellation is voluntary but encouraged and your own code should not have to send KVO notifications for this key path
//    BTOperationStateCancelled,
};
@interface BTOperation : NSOperation

- (void)execute;
- (void)finish;

@end

//
//  BTOperationQueue.h
//  BTOperations
//
//  Created by BYTE on 2017/10/22.
//

#import <Foundation/Foundation.h>
@class BTOperationQueue;
@protocol BTOperationQueueDelegate <NSObject>
- (void)operationQueue:(BTOperationQueue *)operationQueue operationDidFinish:(NSOperation *)operation;
@end

@interface BTOperationQueue : NSOperationQueue
@property (nonatomic, weak, readwrite) id<BTOperationQueueDelegate> delegate;
@end

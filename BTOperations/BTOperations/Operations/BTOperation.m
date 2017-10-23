//
//  BTOperation.m
//  BTOperations
//
//  Created by BYTE on 2017/10/22.
//

#import "BTOperation.h"
static inline BOOL BTStateTransitionIsValid(BTOperationState fromState, BTOperationState toState, BOOL isCancelled) {
    switch (fromState) {
        case BTOperationStateReady:
            switch (toState) {
                case BTOperationStateExecuting:
                    return YES;
                case BTOperationStateFinished:
                    return isCancelled;
                default:
                    return NO;
            }
            break;
        case BTOperationStateExecuting: {
            switch (toState) {
                case BTOperationStateFinished:
                    return YES;
                    break;
                default:
                    return NO;
            }
        }
        default:
            //isFinished的Operation不再改变
            return NO;
    }
    return NO;
}

@interface BTOperation ()
@property (nonatomic, strong, readwrite) NSRecursiveLock *lock;
@property (nonatomic, assign, readwrite) BTOperationState state;
@end

@implementation BTOperation
- (instancetype)init {
    if (self = [super init]) {
        self.lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (void)main {
    self.state = BTOperationStateExecuting;
    [self execute];
}

- (void)execute {
    NSLog(@"must override -execute");
    [self finish];
}

//1
- (void)finish {
    //设置isFinished为YES
    [_lock lock];
    if (!self.isFinished) {
        self.state = BTOperationStateFinished;
    }
    [_lock unlock];
}

//2
- (BOOL)isFinished {
    return self.state == BTOperationStateFinished;
}

#pragma mark - setter/getter
- (void)setState:(BTOperationState)state {
    if (!BTStateTransitionIsValid(_state, state, [self isCancelled])) {
        return;
    }
    [self willChangeValueForKey:@"state"];
    _state = state;
    [self didChangeValueForKey:@"state"];
}

#pragma mark - Registering Dependent Keys

+ (NSSet<NSString *> *)keyPathsForValuesAffectingIsReady {
    return [[NSSet alloc] initWithObjects:@"state", nil];
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingIsExecuting {
    return [[NSSet alloc] initWithObjects:@"state", nil];
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingIsFinished {
    return [[NSSet alloc] initWithObjects:@"state", nil];
}
@end

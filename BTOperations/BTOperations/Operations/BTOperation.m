//
//  BTOperation.m
//  BTOperations
//
//  Created by BYTE on 2017/10/22.
//

#import "BTOperation.h"
#import "BTOperationConditionEvaluator.h"
static inline BOOL BTStateTransitionIsValid(BTOperationState fromState, BTOperationState toState, BOOL isCancelled) {
    switch (fromState) {
        case BTOperationStateInitialized:
            switch (toState) {
                case BTOperationStatePending:
                    return YES;
                    break;
                    
                default:
                    return NO;
                    break;
            }
        case BTOperationStatePending:
            switch (toState) {
                case BTOperationStateReady:
                    return YES;
                    break;
                case BTOperationStateFinished:
                    return isCancelled;
                default:
                    return NO;
                    break;
            }
        case BTOperationStateEvaluatingConditions:
            switch (toState) {
                case BTOperationStateReady:
                    return YES;
                    break;
                    
                default:
                    return NO;
                    break;
            }
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
@property (nonatomic, strong, readwrite) BTOperationConditionEvaluator *evaluator;
@property (nonatomic, strong, readwrite) NSMutableArray *conditions;
@end

@implementation BTOperation
- (instancetype)init {
    if (self = [super init]) {
        self.lock = [[NSRecursiveLock alloc] init];
        [self addObserver:self forKeyPath:@"isReady" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"isReady"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.isReady && self.state == BTOperationStatePending) {
        if (!self.conditions.count) {
            _state = BTOperationStateReady;
            return;
        }
        _state = BTOperationStateEvaluatingConditions;
        [self.evaluator evaluateWithConditions:self.conditions.copy operation:self complete:^(NSArray *failures) {
            if (failures.count) {
                [self cancel];
            } else {
                _state = BTOperationStateReady;
            }
        }];
    }
}

- (void)didEnqueue {
    self.state = BTOperationStatePending;
}

- (void)main {
    self.state = BTOperationStateExecuting;
    [self execute];
}

- (void)execute {
    NSLog(@"must override -execute");
    [self finish];
}

#pragma mark - Finishing
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

//- (BOOL)isReady {
//    return self.state == BTOperationStateReady;
//}

#pragma mark - isReady
- (BOOL)isReady {
    return self.isReady && self.state == BTOperationStateReady;
}

#pragma mark - Condition
- (void)addCondition:(BTOperationCondition *)condition {
    [self.conditions addObject:condition];
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

- (BTOperationConditionEvaluator *)evaluator {
    if (!_evaluator) {
        _evaluator = [[BTOperationConditionEvaluator alloc] init];
    }
    return _evaluator;
}

- (NSMutableArray *)conditions {
    if (!_conditions) {
        _conditions = [[NSMutableArray alloc] init];
    }
    return _conditions;
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

//
//  ViewController.m
//  BTOperationsDemo
//
//  Created by BYTE on 2017/10/23.
//

#import "ViewController.h"
#import "BTGroupOperation.h"
#import "BTOperationQueue.h"
#import "TestCondition.h"
@interface ViewController ()
@property (nonatomic, assign, readwrite) bool isLogin;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op1");
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op2");
    }];
    [op2 addDependency:op1];
    BTGroupOperation *gop = [[BTGroupOperation alloc] initWithOperations:@[op1,op2]];
    TestCondition *testCondition = [[TestCondition alloc] init];
    [gop addCondition:testCondition];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op3");
    }];
    [op3 addDependency:op2];
    BTOperationQueue *queue = [[BTOperationQueue alloc] init];
    [queue addOperation:gop];
    [queue addOperation:op3];
    NSLog(@"1:%@,2:%@,3:%@,gop:%@",op1,op2,op3,gop);
//    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"op1");
//    }];
//
//    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"op2");
//    }];
//    [op1 addDependency:op2];
//    [[NSOperationQueue mainQueue] addOperation:op1];
//    [[NSOperationQueue mainQueue] addOperation:op2];
}
- (IBAction)markClick:(id)sender {
    if (!_isLogin) {
        NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{            
        }];
    }
}

- (void)mark {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"message:@"拨打客服电话"preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

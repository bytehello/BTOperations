//
//  ViewController.m
//  BTOperationsDemo
//
//  Created by BYTE on 2017/10/23.
//

#import "ViewController.h"
#import "BTGroupOperation.h"
@interface ViewController ()

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
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op3");
    }];
    [op3 addDependency:op2];
    [[NSOperationQueue currentQueue] addOperation:gop];
    [[NSOperationQueue currentQueue] addOperation:op3];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

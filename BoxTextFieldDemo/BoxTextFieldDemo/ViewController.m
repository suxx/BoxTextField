//
//  ViewController.m
//  BoxTextFieldDemo
//
//  Created by suxx on 2017/8/2.
//  Copyright © 2017年 suxx. All rights reserved.
//

#import "ViewController.h"
#import "BoxTextField.h"

@interface ViewController ()<BoxTextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BoxTextField * telTextFd = [[BoxTextField alloc]initWithFrame:CGRectMake(0, 0, 300, 33)];
    telTextFd.center = self.view.center;
    telTextFd.delegate = self;
    telTextFd.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:telTextFd];

}

#pragma mark --- BoxTextFieldDelegate
/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(NSString *)passWord{
    
}

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(NSString *)passWord{
    
}

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(NSString *)passWord{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

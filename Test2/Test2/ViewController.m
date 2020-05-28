//
//  ViewController.m
//  Test2
//
//  Created by fish on 2020/5/23.
//  Copyright © 2020 fish. All rights reserved.
//

//  ViewController.m
 
#import "ViewController.h"
#import "QSeekBarView.h"
#import "UIImage+Extension.h"
#import "UIImage+Extrnsion.h"

 
@interface ViewController ()

@property(nonatomic, strong) UIView *viewContent;
 
@end
 
@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
 
    QSeekBarView *viewSeekbar = [[QSeekBarView alloc] initFrame:CGRectMake(0, 200, 50, 100) title:@"声音" minValue:0 maxValue:15 currentValue:7];
    viewSeekbar.backgroundColor = [UIColor grayColor];
    
    viewSeekbar.blockValueChange = ^(NSInteger value) {
        NSLog(@"value:%zd", value);
    };
    
    [self.view addSubview:viewSeekbar];
    
    
       
}
 
@end


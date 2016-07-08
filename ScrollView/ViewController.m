//
//  ViewController.m
//  ScrollView
//
//  Created by chengfj on 16/7/8.
//  Copyright © 2016年 chengfj.com. All rights reserved.
//

#import "ViewController.h"
#import "MRCControllerScrollView.h"
#import "TEST1ViewController.h"
#import "TestViewController.h"

@interface ViewController ()
@property (nonatomic,strong) MRCControllerScrollView * scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setAutomaticallyAdjustsScrollViewInsets:false];
  [self setEdgesForExtendedLayout:UIRectEdgeNone];
  
  TEST1ViewController * TEST1 = [[TEST1ViewController alloc] init];
  TestViewController * test = [[TestViewController alloc] init];
  TEST1ViewController * TEST3 = [[TEST1ViewController alloc] init];
  TestViewController * test4 = [[TestViewController alloc] init];
  TEST1ViewController * TEST5 = [[TEST1ViewController alloc] init];
  TestViewController * test6 = [[TestViewController alloc] init];
  TEST1ViewController * TEST7 = [[TEST1ViewController alloc] init];
  TestViewController * test8 = [[TestViewController alloc] init];

  NSArray * controllers = @[TEST1,test,TEST3,test4,TEST5,test6,TEST7,test8];
  NSArray * titles = @[@"精品视屏精",@"美女如云",@"VIP专区",@"高清电影",@"精品视屏精",@"美女如云",@"VIP专区",@"高清电影"];
  CGRect rect = self.view.bounds;
  rect.origin.y = 20;
  rect.size.height -= 20;
  self.scrollView=[[MRCControllerScrollView alloc] initWithFrame:rect viewControllers:controllers menuTitles:titles];
  self.scrollView.menuHeight = 50;
  [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

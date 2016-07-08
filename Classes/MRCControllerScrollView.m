//
//  MRCControllerScrollView.m
//  ScrollView
//
//  Created by chengfj on 16/7/8.
//  Copyright © 2016年 chengfj.com. All rights reserved.
//

#import "MRCControllerScrollView.h"

@interface MRCControllerScrollView () <UIScrollViewDelegate> {
  NSInteger _idx;
  CGFloat _offsetX;
}

@property (nonatomic,strong,readwrite) NSArray * viewControllers;
@property (nonatomic,strong) UIScrollView * topMenuScrollView;
@property (nonatomic,strong) UIScrollView * contentScrollView;
@property (nonatomic,strong) NSMutableArray * allMenuButtons;

@property (nonatomic,strong) UIView * bottomLine;

@end

@implementation MRCControllerScrollView

- (instancetype)initWithFrame:(CGRect)frame
              viewControllers:(NSArray *)viewControllers
                   menuTitles:(NSArray *)menuTitles {
  if (viewControllers.count != menuTitles.count) return nil;
  self = [super initWithFrame:frame];
  if (self) {
    [self setBackgroundColor:[UIColor lightGrayColor]];
     _idx = 0;
    
    self.selectedTintColor = [UIColor redColor];
    self.normalTintColor = [UIColor whiteColor];
    self.barBackgroundColor = [UIColor lightGrayColor];
    self.titleFont = [UIFont systemFontOfSize:16];
    self.menuHeight = 44;
    
    self.viewControllers = viewControllers;
    self.meuTitles = menuTitles;
    self.allMenuButtons = [NSMutableArray array];
    
    [self initilizeUI];
    [self resetScrollViewFrame];
    [self resetScrollViewLayout];
  }
  return self;
}

- (void)setMenuHeight:(CGFloat)menuHeight {
  _menuHeight = menuHeight;
  [self resetScrollViewFrame];
  [self resetScrollViewLayout];
}

- (void)initilizeUI {
  self.topMenuScrollView = [[UIScrollView alloc] init];
  self.topMenuScrollView.showsVerticalScrollIndicator = false;
  self.topMenuScrollView.showsHorizontalScrollIndicator = false;
  
  self.contentScrollView = [[UIScrollView alloc] init];
  self.contentScrollView.showsHorizontalScrollIndicator = false;
  self.contentScrollView.showsVerticalScrollIndicator = false;
  self.contentScrollView.pagingEnabled = true;
  self.contentScrollView.delegate = self;
  
  self.bottomLine = [[UIView alloc] init];
  
  [self addSubview:self.topMenuScrollView];
  [self addSubview:self.contentScrollView];
  [self.topMenuScrollView addSubview:self.bottomLine];
}

- (void)resetScrollViewFrame {
  self.topMenuScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.menuHeight);
  self.contentScrollView.frame = CGRectMake(0, self.menuHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-self.menuHeight);
}

- (void)resetScrollViewLayout {
  [self.contentScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self.viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    /// 配置Controller的显示
    if ([obj isKindOfClass:[UIViewController class]]) {
      UIViewController * controller = obj;
      
      CGRect contentRect = self.contentScrollView.bounds;
      contentRect.origin.x = idx * contentRect.size.width;
      UIView * controllerContainer = [[UIView alloc] initWithFrame:contentRect];
      [self.contentScrollView addSubview:controllerContainer];
      
      [controllerContainer addSubview:controller.view];

      CGSize contentSize = CGSizeMake((idx+1) * contentRect.size.width, self.contentScrollView.frame.size.height);
      self.contentScrollView.contentSize = contentSize;
    }
  }];
  [self resetButtons];
}

- (void)resetButtons {
  [self.topMenuScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [self.allMenuButtons removeAllObjects];
  CGRect rect = CGRectZero;
  rect.size.height = self.topMenuScrollView.frame.size.height;
  for (NSInteger i = 0; i < self.meuTitles.count; i++) {
    NSString * title = self.meuTitles[i];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:self.normalTintColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectedTintColor forState:UIControlStateSelected];
    [button setTag:1000+i];
    button.selected = i==0;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.topMenuScrollView addSubview:button];
    rect.size.width = 100;
    button.frame = rect;
    rect.origin.x = CGRectGetMaxX(rect);
    [self.allMenuButtons addObject:button];
    self.topMenuScrollView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame), CGRectGetHeight(button.frame));
  }
  
  [self.topMenuScrollView addSubview:self.bottomLine];
  self.bottomLine.frame = CGRectMake(10, self.topMenuScrollView.frame.size.height-3, 80, 3);
  self.bottomLine.backgroundColor = self.selectedTintColor;
}

- (void)clickButton:(UIButton *)sender {
  [self selectedSender:sender];
  NSInteger idx = sender.tag - 1000;
  [self.contentScrollView setContentOffset:CGPointMake(idx*CGRectGetWidth(self.contentScrollView.frame), 0) animated:true];
}

- (void)selectedSender:(UIButton *)sender {
  [self.allMenuButtons enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {obj.selected = false;}];
  sender.selected = true;
  
  CGFloat topMenuWidth = self.topMenuScrollView.frame.size.width;
  CGFloat topButtonOffsetX = CGRectGetMinX(sender.frame)- (topMenuWidth/2-sender.frame.size.width/2);
  if (topButtonOffsetX <= 0) {
    [self.topMenuScrollView setContentOffset:CGPointMake(0, 0) animated:true];
  } else if ((topButtonOffsetX+topMenuWidth)>self.topMenuScrollView.contentSize.width) {
    [self.topMenuScrollView setContentOffset:CGPointMake(self.topMenuScrollView.contentSize.width-topMenuWidth, 0) animated:true];
  }else {
    [self.topMenuScrollView setContentOffset:CGPointMake(topButtonOffsetX, 0) animated:true];
  }
  [UIView animateWithDuration:0.3 animations:^{
    self.bottomLine.frame = CGRectMake(CGRectGetMinX(sender.frame)+10, self.topMenuScrollView.frame.size.height-3, 80, 3);
  } completion:^(BOOL finished) {
  }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat x = scrollView.contentOffset.x / (scrollView.contentSize.width / self.topMenuScrollView.contentSize.width);
  self.bottomLine.frame = CGRectMake(10+x, self.topMenuScrollView.frame.size.height-3, 80, 3);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  NSInteger contentIndex = scrollView.contentOffset.x;
  NSInteger idx = contentIndex / scrollView.frame.size.width;
  if (_idx != idx) {
    UIButton * sender = self.allMenuButtons[idx];
    [self selectedSender:sender];
    _idx = idx;
  }
}

@end

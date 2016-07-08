//
//  MRCControllerScrollView.h
//  ScrollView
//
//  Created by chengfj on 16/7/8.
//  Copyright © 2016年 chengfj.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRCControllerScrollView : UIView

@property (nonatomic,strong,readonly) NSArray * viewControllers;
@property (nonatomic,strong) NSArray * meuTitles;/// 顶部菜单的标题
@property (nonatomic,assign) CGFloat menuHeight;/// 菜单高度

/// 菜单样式
@property (nonatomic,strong) UIColor * selectedTintColor;
@property (nonatomic,strong) UIColor * normalTintColor;
@property (nonatomic,strong) UIColor * barBackgroundColor;
@property (nonatomic,strong) UIFont * titleFont;

/// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
              viewControllers:(NSArray *)viewControllers
                   menuTitles:(NSArray *)menuTitles;

- (instancetype)init NS_UNAVAILABLE; // use initWithFrame:viewControllers

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE; // use initWithFrame:viewControllers

@end

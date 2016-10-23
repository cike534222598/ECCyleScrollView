//
//  ECCycleScrollView.h
//  Confinement
//
//  Created by 菅帅博 on 16/4/23.
//  Copyright © 2016年 Jame. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ECCycleScrollViewDelegate;
@protocol ECCycleScrollViewDataSource;


@interface ECCycleScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger currentPage;


@property (nonatomic,assign,setter = setDataource:) id<ECCycleScrollViewDataSource> dataSource;
@property (nonatomic,assign,setter = setDelegate:) id<ECCycleScrollViewDelegate> delegate;


//初始化方法
- (id)initWithFrame:(CGRect)frame withTimer:(BOOL)flag withInfiniteLoop:(BOOL)infiniteLoop withPageControl:(BOOL)isPageControl;

//加载数据
- (void)reloadData;

@end


#pragma mark  -------ECCycleScrollViewDelegate------
@protocol ECCycleScrollViewDelegate <NSObject>

@optional

//点击触发事件
- (void)didClickPage:(ECCycleScrollView *)csView atIndex:(NSInteger)index;

@end


#pragma mark ------ECCycleScrollViewDataSource------
@protocol ECCycleScrollViewDataSource <NSObject>

@required

//Page数量
- (NSInteger)numberOfPages;

//Page视图
- (UIView *)pageAtIndex:(NSInteger)index;


@end


//
//  ECCycleScrollView.m
//  Confinement
//
//  Created by 菅帅博 on 16/4/23.
//  Copyright © 2016年 Jame. All rights reserved.
//

#import "ECCycleScrollView.h"


@interface ECCycleScrollView ()

@property (nonatomic, assign) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, copy) NSMutableArray *currentViews;
@property (nonatomic, assign) BOOL isTimer;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, assign) BOOL infiniteLoop;

@end

@implementation ECCycleScrollView



- (void)dealloc
{
    _scrollView.delegate = nil;
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (id)initWithFrame:(CGRect)frame withTimer:(BOOL)flag withInfiniteLoop:(BOOL)infiniteLoop withPageControl:(BOOL)isPageControl
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        CGRect rect = CGRectMake(50.0f, self.frame.size.height - 15, [[UIScreen mainScreen]bounds].size.width - 2*50.0f, 15.0f);
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidden = !isPageControl;
        [self addSubview:_pageControl];
        
        _currentPage = 0;
        _flag = flag;
        _infiniteLoop = infiniteLoop;
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        
        CGRect rect = CGRectMake(50.0f, self.frame.size.height - 15, [[UIScreen mainScreen]bounds].size.width - 2*50.0f, 15.0f);
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.userInteractionEnabled = NO;
        [self addSubview:_pageControl];
        _currentPage = 0;
        _flag = YES;
        _infiniteLoop = YES;
    }
    return self;
}



- (void)setDataSource:(id<ECCycleScrollViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}



- (void)reloadData
{
    _totalPage = [_dataSource numberOfPages];
    if (_totalPage == 0)
    {
        return;
    }
    
    _pageControl.numberOfPages = _totalPage;
    [self loadData];
    
    //创建定时器
    if (!_isTimer && _totalPage > 1 && _flag)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
        _isTimer = YES;
    }
}


//定时器
- (void)timerHandle
{
    if (_infiniteLoop) {
        CGPoint offset = CGPointMake(_scrollView.bounds.size.width * 1.9999999, 0);
        [_scrollView setContentOffset:offset animated:YES];
    }
}


- (void)loadData
{
    _pageControl.currentPage = _currentPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    
    if (_infiniteLoop) {
        
        [self getDisplayImagesWithCurrentpage:_currentPage];

        for (int i = 0; i < 3; i++)
        {
            UIView *subView = [_currentViews objectAtIndex:i];
            subView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [subView addGestureRecognizer:singleTap];
            subView.frame = CGRectOffset(subView.frame, subView.frame.size.width * i, 0);
            [_scrollView addSubview:subView];
        }
        
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
        [_scrollView setContentSize:CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height)];

    }else{
        
        [self getAllImages];
        
        for (int i = 0; i < _totalPage; i++)
        {
            UIView *subView = [_currentViews objectAtIndex:i];
            subView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [subView addGestureRecognizer:singleTap];
            subView.frame = CGRectOffset(subView.frame, subView.frame.size.width * i, 0);
            [_scrollView addSubview:subView];
        }
        
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * _currentPage, 0)];
        [_scrollView setContentSize:CGSizeMake(self.bounds.size.width * _totalPage, self.bounds.size.height)];
    }
}



- (void)getDisplayImagesWithCurrentpage:(NSInteger)page {
    
    NSInteger pre = [self validPageValue:_currentPage - 1];
    NSInteger last = [self validPageValue:_currentPage + 1];
    
    if (!_currentViews) {
        _currentViews = [[NSMutableArray alloc] init];
    }
    
    [_currentViews removeAllObjects];
    
    [_currentViews addObject:[_dataSource pageAtIndex:pre]];
    [_currentViews addObject:[_dataSource pageAtIndex:page]];
    [_currentViews addObject:[_dataSource pageAtIndex:last]];
}


- (void)getAllImages
{
    if (!_currentViews) {
        _currentViews = [[NSMutableArray alloc] init];
    }
    
    [_currentViews removeAllObjects];
    
    for (NSInteger i = 0 ; i < _totalPage; i++) {
        
        [_currentViews addObject:[_dataSource pageAtIndex:i]];

    }
}


- (NSInteger)validPageValue:(NSInteger)value
{
    if(value == -1) value = _totalPage - 1;
    if(value == _totalPage) value = 0;
    return value;
}


- (void)handleTap:(UITapGestureRecognizer *)tap
{
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)])
    {
        [_delegate didClickPage:self atIndex:_currentPage];
    }
    
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    int x = aScrollView.contentOffset.x;
    
    if (_infiniteLoop) {
        
        //往下翻一张
        if(x >= (2 * self.frame.size.width)) {
            _currentPage = [self validPageValue:_currentPage + 1];
            [self loadData];
        }
        
        //往上翻
        if(x <= 0) {
            _currentPage = [self validPageValue:_currentPage - 1];
            [self loadData];
        }

    }else{
        
        _currentPage = x / self.bounds.size.width;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    if (_infiniteLoop) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    }else{
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * _currentPage, 0) animated:YES];
    }
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end

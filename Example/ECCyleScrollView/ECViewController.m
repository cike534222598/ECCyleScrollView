//
//  ECViewController.m
//  ECCyleScrollView
//
//  Created by Jame on 10/23/2016.
//  Copyright (c) 2016 Jame. All rights reserved.
//

#import "ECViewController.h"
#import "ECCycleScrollView.h"

@interface ECViewController () <ECCycleScrollViewDelegate, ECCycleScrollViewDataSource>

@property (nonatomic, strong) ECCycleScrollView *cycleView;

@end

@implementation ECViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.cycleView = [[ECCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) withTimer:YES withInfiniteLoop:YES withPageControl:NO];
    self.cycleView.delegate = self;
    self.cycleView.dataSource = self;
    [self.view addSubview:self.cycleView];
    
    [self.cycleView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfPages {
    return 5;
}

- (UIView *)pageAtIndex:(NSInteger)index {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    label.backgroundColor = [UIColor orangeColor];
    label.text = [NSString stringWithFormat:@"这是第%ld张banner", index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    return label;
}


@end

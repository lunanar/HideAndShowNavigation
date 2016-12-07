//
//  HidePageScrollViewController.m
//  SwipNavHide
//
//  Created by Lunar on 16/12/5.
//  Copyright © 2016年 Lunar. All rights reserved.
//

#import "HidePageScrollViewController.h"
#import "BHInfiniteScrollView.h"

#define lunboKindNum 5
#define lunboViewCustomHeight 220.0f

@interface HidePageScrollViewController ()<UITableViewDataSource,UITableViewDelegate,BHInfiniteScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIView *mainScrollView;

@property(nonatomic, strong) UIView *topView;    //导航栏

@property (strong, nonatomic) IBOutlet UIScrollView *lunboScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lunboScrollViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lunboScrollViewTop;


@end

@implementation HidePageScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init lunbo
    self.lunboScrollView.delegate = self;
    self.lunboScrollView.contentSize = CGSizeMake(ScreenWidth * lunboKindNum, lunboViewCustomHeight);
    [self imageScroll];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - ImageScroll
- (void)imageScroll {
    UIImage *img1 = [UIImage imageNamed:@"img1"];
    UIImage *img2 = [UIImage imageNamed:@"img2"];
    UIImage *img3 = [UIImage imageNamed:@"img3"];
    UIImage *img4 = [UIImage imageNamed:@"img4"];
    UIImage *img5 = [UIImage imageNamed:@"img5"];
    NSArray *imageArr = @[img1,img2,img3,img4,img5];
    BHInfiniteScrollView* infinitePageView1 = [BHInfiniteScrollView
                                               infiniteScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, self.lunboScrollViewHeight.constant) Delegate:self ImagesArray:imageArr];
    infinitePageView1.dotSize = 10;
    infinitePageView1.pageControlAlignmentOffset = CGSizeMake(0, 20);
    infinitePageView1.scrollTimeInterval = 2;
    infinitePageView1.autoScrollToNextPage = YES;

    infinitePageView1.delegate = self;
    [self.lunboScrollView addSubview:infinitePageView1];
}

#pragma mark - tableView delegate && datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
//    cell.backgroundColor = [self randomColor];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGFloat offsetY = offset.y;
    
    if ([scrollView isEqual:self.mainTableView]) {
        if (offsetY > 0) {     //往上滑
            if (!self.topView) {
                self.topView =
                [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
                title.text = @"我是一个导航栏";
                title.textColor = [UIColor whiteColor];
                title.textAlignment = NSTextAlignmentCenter;
                [self.topView addSubview:title];
                [self.mainScrollView insertSubview:self.topView aboveSubview:self.lunboScrollView];
            }
            self.topView.hidden = NO;
            CGFloat alpha = offsetY / (lunboViewCustomHeight-64);
            self.topView.backgroundColor = [UIColor colorWithRed:60.f/255.f green:198.f/255.f blue:253.f/255.f alpha:alpha];
            self.lunboScrollViewTop.constant = -offsetY;
            
        } else {
            self.lunboScrollViewHeight.constant = lunboViewCustomHeight-offsetY;
            [self imageScroll];
            if (offsetY <= -60) {
                self.mainTableView.contentOffset = CGPointMake(0, -60);
//                self.mainTableView.contentOffset = CGPointMake(0, 0);
                self.lunboScrollViewTop.constant = 0;
                self.topView.backgroundColor = self.topView.backgroundColor = [UIColor colorWithRed:0.0667 green:0.478 blue:0.804 alpha:0];
                }
            }
        if(offsetY == 0) {
            self.lunboScrollViewTop.constant = 0;
        }

    }
}

#pragma mark - PrivateFun
- (UIColor *)randomColor {
    CGFloat r = arc4random_uniform(255);
    CGFloat g = arc4random_uniform(255);
    CGFloat b = arc4random_uniform(255);
    return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

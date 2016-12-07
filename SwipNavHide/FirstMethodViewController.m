//
//  FirstMethodViewController.m
//  SwipNavHide
//
//  Created by Lunar on 16/12/7.
//  Copyright © 2016年 Lunar. All rights reserved.
//

#import "FirstMethodViewController.h"
#import "BHInfiniteScrollView.h"

#define lunboKindNum 5

@interface FirstMethodViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,BHInfiniteScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *lunboScrollView;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lunboScrollViewTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lunboScrollViewHeight;
@property(nonatomic, strong) UIView *topView;    //导航栏


@end

@implementation FirstMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init lunbo
    self.lunboScrollView.delegate = self;
    self.lunboScrollView.contentSize = CGSizeMake(ScreenWidth * lunboKindNum, 220);
    
    [self imageScroll];
    
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
    NSLog(@"offsetY:%f",offsetY);
    
    if ([scrollView isEqual:self.mainTableView]) {
        if (offsetY > 0) {  //往上滑  轮播图片渐渐消失
            if (!self.topView) {
                self.topView =
                [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
                UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
                title.text = @"我是一个导航栏";
                title.textColor = [UIColor whiteColor];
                title.textAlignment = NSTextAlignmentCenter;
                [self.topView addSubview:title];
                [self.view insertSubview:self.topView aboveSubview:self.lunboScrollView];
            }
            self.topView.hidden = NO;
            CGFloat alpha = offsetY / (220-64);
            self.topView.backgroundColor = [UIColor colorWithRed:60.f/255.f green:198.f/255.f blue:253.f/255.f alpha:alpha];
            self.lunboScrollViewTop.constant = -offsetY;
//            self.mainTableView.contentOffset = CGPointMake(0, -offsetY);
            if (offsetY < 220) {
                self.mainTableView.contentOffset = CGPointMake(0, -220);
            }
        }else {
//            self.lunboScrollViewHeight.constant = 400.f;
            [self imageScroll];
            if (offsetY <= -60) {
                self.mainTableView.contentOffset = CGPointMake(0, -60);
                //                self.mainTableView.contentOffset = CGPointMake(0, 0);
                self.lunboScrollViewTop.constant = 0;
                self.topView.backgroundColor = self.topView.backgroundColor = [UIColor colorWithRed:0.0667 green:0.478 blue:0.804 alpha:0];
            }
        }
        if(offsetY == 0) {
            self.lunboScrollViewTop.constant = -20;
        }
    }
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

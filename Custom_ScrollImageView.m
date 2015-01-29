//
//  Custom_ScrollImageView.m
//  tmpScrollView
//
//  Created by chengtz-iMac on 15/1/29.
//  Copyright (c) 2015年 chengtz-iMac. All rights reserved.
//

#import "Custom_ScrollImageView.h"

typedef enum
{
    enum_UnKnow,
    enum_Left,
    enum_Right
}enum_Direction_ScrollView;

#define POST_TIMER_SCROLLPIC 5.0

@interface Custom_ScrollImageView ()
{
    UIScrollView * scrollview;
    UIPageControl * pageControl;
    CGSize MainScreenSize;

    NSInteger currIndex;
    
    NSMutableArray * picViewArray;
    NSMutableArray * imageViewArray;
    
    enum_Direction_ScrollView direction;
}
@end

@implementation Custom_ScrollImageView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _maxPicCount = 5;
        currIndex = 0;
        direction = enum_UnKnow;
        
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    MainScreenSize = self.bounds.size;//self.cellForScrollView.bounds.size;
    
    //NSLog(@"MainScreenSize width:%f, height:%f", MainScreenSize.width, MainScreenSize.height);
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreenSize.width, MainScreenSize.height)];
    scrollview.backgroundColor = [UIColor grayColor];
    scrollview.delegate = self;
    picViewArray = [[NSMutableArray alloc] initWithCapacity:5];
    imageViewArray = [[NSMutableArray alloc]initWithCapacity:3];
    
    //翻页效果
    scrollview.pagingEnabled = YES;
    
    for (int nIndex = 0; nIndex < _maxPicCount; nIndex++) {
        NSString *str = [NSString stringWithFormat:@"%d.JPG", nIndex + 1];
        UIImage * image = [UIImage imageNamed:str];
        
        [picViewArray addObject:image];
    }
    
    //由于最小都要创建3个ImageView 所以当显示的图片小于3时 还是按3个创建
    NSInteger picCount;
    _maxPicCount == 2 ? picCount = 3 : (picCount = _maxPicCount);
    //要实现scrollview的滚动需要2个条件：1设置每个子view的坐标 2 设置contentsize
    
    scrollview.contentSize =  CGSizeMake(MainScreenSize.width * picCount, MainScreenSize.height);
//[self.cellForScrollView addSubview:scrollview];
    [self addSubview:scrollview];
    
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.bounds = CGRectMake(0, 0, 100, 20);//指定位置大小
    pageControl.center = CGPointMake(MainScreenSize.width / 2.0, MainScreenSize.height - pageControl.bounds.size.height);
    //pageControl.backgroundColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    pageControl.numberOfPages = _maxPicCount;//指定页面个数
    pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
//[self.cellForScrollView addSubview:pageControl];
    [self addSubview:pageControl];
    
    // 实现循环切换图片，创建3个imageview即可。每次翻页的时候清除之前scrollview中的图片，重新加载资源
//[self upDataScrollViewPoint:currIndex];
    
    //创建一个定时器，定时滚动
    //NSTimer* connectionTimer=[NSTimer scheduledTimerWithTimeInterval:POST_TIMER_SCROLLPIC target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    //[connectionTimer fire];
}


-(void)timerFired:(NSTimer *)timer{
    direction = enum_Right;
    NSLog(@"direction:[%d]", direction);
    
    currIndex = [self adjustCurrentIndex:[self upDataCurrent:currIndex]];
    [self upDataScrollViewPoint:currIndex];
    
}

-(void)upDataScrollViewPoint{
    [self upDataScrollViewPoint:currIndex];
}

-(void)upDataScrollViewPoint:(NSInteger)index
{
    [self reLoadItem:index];
    
    CGPoint point = scrollview.contentOffset;
    point.x = MainScreenSize.width;
    scrollview.contentOffset = point;
    
}

-(void)clearPreItem
{
    NSArray * subViews = [scrollview subviews];
    if (subViews.count != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        //NSLog(@"scroll view subviews :%ld", subViews.count);
    }
}

-(void)reLoadItem:(NSInteger)index
{
    // 清除之前的数据
    [self clearPreItem];
    
    NSInteger cur = [self adjustCurrentIndex:index];
    NSInteger pre = [self adjustCurrentIndex:currIndex - 1];
    NSInteger next ;//= pre;//[self adjustCurrentIndex:currIndex + 1];
    
    if (_maxPicCount == 2)
        next = pre;
    else
        next = [self adjustCurrentIndex:currIndex + 1];
    
    NSInteger count[3] = {pre, cur, next};
    
    NSLog(@"reLoadItem pre:%ld, cur:%ld, next:%ld", (long)pre, (long)cur, (long)next);
    
    for (int nIndex = 0; nIndex < 3; nIndex++) {
        UIImage * image = picViewArray[count[nIndex]];
        
        CGRect rect = CGRectMake(MainScreenSize.width * nIndex, 0, MainScreenSize.width, MainScreenSize.height);
        
        //NSLog(@"reLoadItem View%d point.x = %f", nIndex, MainScreenSize.width * nIndex);
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:rect];
        
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor blackColor];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = nIndex;
        [imageViewArray addObject:imageView];
        
        [scrollview addSubview:imageView];
        
        
    }
    
    pageControl.currentPage = cur;
    //NSLog(@"scrollview subview count:%ld",scrollview.subviews.count);
}

-(NSInteger)upDataCurrent:(NSInteger)index{
    NSInteger upDataCurr = index;
    if (enum_Right == direction) {
        upDataCurr++;
    }
    else if(enum_Left == direction){
        upDataCurr--;
    }
    return upDataCurr;
}

-(NSInteger)adjustCurrentIndex:(NSInteger)index
{
    NSInteger adjustIndex = index;
    
    if (index >= _maxPicCount) {
        adjustIndex = 0;
    }
    else if(index < 0)
    {
        adjustIndex = _maxPicCount - 1;
    }
    
    return adjustIndex;
}

//scrollview已经滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger x = scrollview.contentOffset.x;
    
    CGFloat widthPageCondition = MainScreenSize.width * 2;
    
    if (x >= widthPageCondition) {
        direction = enum_Right;
        NSLog(@"direction:[%d]", direction);
        
        currIndex = [self adjustCurrentIndex:[self upDataCurrent:currIndex]];
        [self upDataScrollViewPoint:currIndex];
    }
    else if (x <= 0) {
        direction = enum_Left;
        NSLog(@"direction:[%d]", direction);
        currIndex = [self adjustCurrentIndex:[self upDataCurrent:currIndex]];
        [self upDataScrollViewPoint:currIndex];
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

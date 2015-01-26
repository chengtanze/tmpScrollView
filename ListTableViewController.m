//
//  ListTableViewController.m
//  tmpScrollView
//
//  Created by wangsl-iMac on 15/1/26.
//  Copyright (c) 2015年 chengtz-iMac. All rights reserved.
//

#import "ListTableViewController.h"

typedef enum
{
    enum_UnKnow,
    enum_Left,
    enum_Right
}enum_Direction_ScrollView;

#define POST_TIMER_SCROLLPIC 5.0

@interface ListTableViewController ()
{
    UIScrollView * scrollview;
    UIPageControl * pageControl;
    CGSize MainScreenSize;
    
    NSInteger maxPicCount;
    NSInteger currIndex;
    
    NSMutableArray * picViewArray;
    NSMutableArray * imageViewArray;
    
    enum_Direction_ScrollView direction;
}
@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    maxPicCount = 7;
    currIndex = 0;
    direction = enum_UnKnow;
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    MainScreenSize = self.cellForScrollView.bounds.size;//[UIScreen mainScreen].bounds.size;
    
    //NSLog(@"MainScreenSize width:%f, height:%f", MainScreenSize.width, MainScreenSize.height);
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreenSize.width, MainScreenSize.height)];
    scrollview.backgroundColor = [UIColor grayColor];
    scrollview.delegate = self;
    picViewArray = [[NSMutableArray alloc] initWithCapacity:5];
    imageViewArray = [[NSMutableArray alloc]initWithCapacity:3];
    
    //翻页效果
    scrollview.pagingEnabled = YES;
    
    for (int nIndex = 0; nIndex < maxPicCount; nIndex++) {
        NSString *str = [NSString stringWithFormat:@"%d.JPG", nIndex + 1];
        UIImage * image = [UIImage imageNamed:str];
        
        [picViewArray addObject:image];
    }
    if (maxPicCount == 2) {
        NSString *str = [NSString stringWithFormat:@"%d.JPG", 1];
        UIImage * image = [UIImage imageNamed:str];
        [picViewArray addObject:image];
        maxPicCount++;
    }
    
    //要实现scrollview的滚动需要2个条件：1设置每个子view的坐标 2 设置contentsize
    scrollview.contentSize =  CGSizeMake(MainScreenSize.width * maxPicCount, MainScreenSize.height);
    [self.cellForScrollView addSubview:scrollview];
    
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.bounds = CGRectMake(0, 0, 100, 20);//指定位置大小
    pageControl.center = CGPointMake(MainScreenSize.width / 2.0, MainScreenSize.height - pageControl.bounds.size.height);
    //pageControl.backgroundColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    pageControl.numberOfPages = maxPicCount;//指定页面个数
    pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    [self.cellForScrollView addSubview:pageControl];
    
    
    // 实现循环切换图片，创建3个imageview即可。每次翻页的时候清除之前scrollview中的图片，重新加载资源
    [self upDataScrollViewPoint:currIndex];
    
    //创建一个定时器，定时滚动
    NSTimer* connectionTimer=[NSTimer scheduledTimerWithTimeInterval:POST_TIMER_SCROLLPIC target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [connectionTimer fire];
}

-(void)timerFired:(NSTimer *)timer{
    direction = enum_Right;
    NSLog(@"direction:[%d]", direction);
    
    currIndex = [self adjustCurrentIndex:[self upDataCurrent:currIndex]];
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
    NSInteger next = [self adjustCurrentIndex:currIndex + 1];
    
    NSInteger count[3] = {pre, cur, next};
    
    NSLog(@"reLoadItem pre:%ld, cur:%ld, next:%ld", pre, cur, next);
    
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
    
    if (index >= maxPicCount) {
        adjustIndex = 0;
    }
    else if(index < 0)
    {
        adjustIndex = maxPicCount - 1;
    }

    return adjustIndex;
}

//scrollview已经滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger x = scrollview.contentOffset.x;
    
    CGFloat widthPageCondition = MainScreenSize.width * 2;
//    if (maxPicCount < 3) {
//        widthPageCondition = MainScreenSize.width;
//    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return nil;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

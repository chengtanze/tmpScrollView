//
//  ViewController.m
//  tmpScrollView
//
//  Created by wangsl-iMac on 15/1/26.
//  Copyright (c) 2015年 chengtz-iMac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSInteger maxPicCount;
    NSInteger currIndex;
    
    float MainScreenWidth;
    float MainScreenHeight;
    
    CGSize MainScreenSize;
    UIScrollView * scrollview;
    NSMutableArray * picViewArray;
    
    NSMutableArray * imageViewArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    MainScreenSize = [UIScreen mainScreen].bounds.size;
//    MainScreenWidth = MainScreenSize.width;
//    
//    
//    currIndex = 1;
//    
//    NSLog(@"MainScreenSize width:%f, height:%f", MainScreenSize.width, MainScreenSize.height);
//    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreenSize.width, MainScreenSize.height)];
//    scrollview.backgroundColor = [UIColor grayColor];
//    
//    picViewArray = [[NSMutableArray alloc] initWithCapacity:5];
//    imageViewArray = [[NSMutableArray alloc]initWithCapacity:3];
//    
//    scrollview.delegate = self;
//    //翻页效果
//    scrollview.pagingEnabled = YES;
//    
//    //要实现scrollview的滚动需要2个条件：1设置每个子view的坐标 2 设置contentsize
//    scrollview.contentSize =  CGSizeMake(MainScreenSize.width * 3, MainScreenSize.height);
//    
//    
//    [self.view addSubview:scrollview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

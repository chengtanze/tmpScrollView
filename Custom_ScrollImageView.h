//
//  Custom_ScrollImageView.h
//  tmpScrollView
//
//  Created by wangsl-iMac on 15/1/29.
//  Copyright (c) 2015年 chengtz-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Custom_ScrollImageView : UIView<UIScrollViewDelegate>

@property(nonatomic, assign)NSInteger maxPicCount;




-(id)initWithFrame:(CGRect)frame;
-(void)upDataScrollViewPoint;

@end

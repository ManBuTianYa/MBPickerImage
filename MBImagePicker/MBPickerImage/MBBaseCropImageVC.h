//
//  MBBaseCropImageVC.h
//  MBImagePicker
//
//  Created by iOS on 2020/12/25.
//  Copyright © 2020 www. iOSProject.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KISIphoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
NS_ASSUME_NONNULL_BEGIN

typedef void (^callClock)(UIImage *img);
@class MBImageConfig;

@interface MBBaseCropImageVC : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) MBImageConfig *config;//配置
@property (nonatomic, copy) callClock callBlock;

@end

NS_ASSUME_NONNULL_END

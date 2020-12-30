//
//  MBImagePicker.h
//  MBImagePicker
//
//  Created by iOS on 2020/12/24.
//  Copyright © 2020 www. iOSProject.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMBImagePickerShare [MBImagePicker share]

typedef void(^CallImageBlock)(UIImage * _Nullable image);

typedef enum : NSUInteger {
    MBImageType_rectangle, //矩形
    MBImageType_Round,//圆形
} MBImageType;


NS_ASSUME_NONNULL_BEGIN

@class MBImageConfig;

@interface MBImagePicker : NSObject

@property (nonatomic, strong) MBImageConfig *config;//配置
/// 返回图片
@property (nonatomic, copy) CallImageBlock callImageBlock;

/// 单例  酌情使用
+ (instancetype)share;

/// 选择相册或者相机
- (void)showSheet;

@end

@interface MBImageConfig : NSObject

@property (nonatomic, copy) NSString *title;   //标题
@property (nonatomic, copy) NSString *camera;  //相机
@property (nonatomic, copy) NSString *alubum;  //相册
@property (nonatomic, copy) NSString *cancel;  //取消
@property (nonatomic, copy) NSString *select;  //选取

@property (nonatomic, strong) UIColor *cornerColor; //四角的颜色

@property (nonatomic, assign) MBImageType type;//图片样式 默认:矩形
@property (nonatomic, assign) CGFloat  ratio;  //矩形框的宽高比例 0:(默认)自由
@property (nonatomic, assign) CGSize size;     //大小

@end

NS_ASSUME_NONNULL_END

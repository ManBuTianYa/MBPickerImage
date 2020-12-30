//
//  MBImagePicker.m
//  MBImagePicker
//
//  Created by iOS on 2020/12/24.
//  Copyright © 2020 www. iOSProject.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBImagePicker.h"
#import "MBCropImageVC.h"
#import "MBCropCornerImageVC.h"

#import "UIImage+Crop.h"

#define kRootVC [MBImagePicker getCurrentVC]

@interface MBImagePicker ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation MBImagePicker

+ (instancetype)share {
    static MBImagePicker *manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[self alloc] init];
    });
    return manage;
}


- (void)showSheet {
    
    __weak typeof(self)weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.config.title message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:self.config.camera style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showPickerWithType:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction *alubum = [UIAlertAction actionWithTitle:self.config.alubum style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf showPickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:self.config.cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:camera];
    }
    [alert addAction:alubum];
    [alert addAction:cancel];

    [kRootVC presentViewController:alert animated:YES completion:nil];
    
}

- (void)showPickerWithType:(UIImagePickerControllerSourceType)type {
    
    self.picker.sourceType = type;
    [kRootVC presentViewController:self.picker animated:YES completion:nil];
    
}

//MARK: ---------------- imagePickerDelegate ----------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    MBBaseCropImageVC *vc = nil;
    if (self.config.type == MBImageType_rectangle) {
        vc = [[MBCropImageVC alloc] init];
        vc.image = image;
    }else {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = image.size.height * (width/image.size.width);
        UIImage * orImage = [image resizeImageWithSize:CGSizeMake(width, height)];
        MBCropCornerImageVC *cornerVC = [[MBCropCornerImageVC alloc] init];
        cornerVC.image = orImage;
        vc = cornerVC;
    }
    
    vc.config = self.config;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [kRootVC pushViewController:vc animated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    __weak typeof(self)weakSelf = self;
    vc.callBlock = ^(UIImage * _Nonnull img) {
        
        if (weakSelf.config.size.width > 0 && weakSelf.config.size.height > 0) {
            img = [img resizeImageWithSize:weakSelf.config.size];
        }
        
        if (weakSelf.callImageBlock) {
            weakSelf.callImageBlock(img);
        }
    };
}

//MARK: ---------------- Lazy ----------------

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return _picker;
}

- (MBImageConfig *)config {
    if (!_config) {
        _config = [[MBImageConfig alloc] init];
    }
    return _config;
}

//MARK: ---------------- Other ----------------
+ (UINavigationController *)getCurrentVC {
    
    UIViewController *result = nil;
    
    UIWindow *window = [MBImagePicker getCurWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *temp in windows) {
            if (temp.windowLevel == UIWindowLevelNormal) {
                window = temp;
                break;
            }
        }
    }
    //取当前展示的控制器
    result = window.rootViewController;
    while (result.presentedViewController) {
        if ([result isKindOfClass:[UINavigationController class]]) {
            break;
        }
        result = result.presentedViewController;
    }

    return (UINavigationController *)result;
}

+ (UIWindow *)getCurWindow {
    
    for (id anyObj in [UIApplication sharedApplication].windows) {
        if ([anyObj isKindOfClass:[UIWindow class]]) {
            return anyObj;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

@end


#pragma mark 配置类
@implementation MBImageConfig

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.title = @"选择图片";
        self.camera = @"相机";
        self.alubum = @"相册";
        self.cancel = @"取消";
        self.select = @"选取";
        
        self.cornerColor = [UIColor whiteColor];
        
        self.type = MBImageType_rectangle;
    }
    return self;
}

@end

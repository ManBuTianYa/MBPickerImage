//
//  ViewController.m
//  MBImagePicker
//
//  Created by iOS on 2020/12/22.
//  Copyright © 2020 www. iOSProject.com. All rights reserved.
//

#import "ViewController.h"
#import "MBImagePicker.h"

@interface ViewController ()

@property (nonatomic, strong) MBImagePicker *picker;

@property (nonatomic, strong) UIImageView *imgV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor yellowColor];
    btn.frame = CGRectMake(150, 100, 100, 50);
    [btn addTarget:self action:@selector(onBtn) forControlEvents:UIControlEventTouchUpInside];
    
    __block UIImageView *imgV = [[UIImageView alloc] init];
    [self.view addSubview:imgV];
    self.imgV = imgV;
}

- (void)onBtn {

    __weak typeof(self)weakSelf = self;

    _picker = [[MBImagePicker alloc] init];
    _picker.config.type = MBImageType_rectangle;
    _picker.config.cornerColor = [UIColor redColor];
    _picker.config.ratio = 1.0;
    [_picker showSheet];
    _picker.callImageBlock = ^(UIImage * _Nullable image) {
        weakSelf.imgV.image = image;
        weakSelf.imgV.frame = CGRectMake(20, 200, 374, image.size.height*image.size.width/374);
    };
}

@end

//
//  MBCropImageVC.m
//  MBImagePicker
//
//  Created by iOS on 2020/12/22.
//  Copyright © 2020 www. iOSProject.com. All rights reserved.
//

#import "MBCropImageVC.h"
#import "TKImageView.h"
#import "MBImagePicker.h"

@interface MBCropImageVC ()

@property (nonatomic, strong) TKImageView *tkImageV;

@end

@implementation MBCropImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self setUpTKImageView];
    
    [self setBottomView];
}

- (void)setUpTKImageView {
    
    [self.view addSubview:self.tkImageV];
    self.tkImageV.frame = CGRectMake(0, 0, CGRectGetMaxX(self.view.frame),  CGRectGetMaxY(self.view.frame)- (KISIphoneX?34:0)-100);
    _tkImageV.toCropImage = self.image;
    _tkImageV.showMidLines = NO; //是否显示中间的线
    _tkImageV.needScaleCrop = YES;
    _tkImageV.showCrossLines = NO; //是否显示交叉线
    _tkImageV.cornerBorderInImage = NO;
    _tkImageV.cropAreaCornerWidth = 45; //最小宽度
    _tkImageV.cropAreaCornerHeight = 45; //最小高度
    _tkImageV.minSpace = 30;
    _tkImageV.cropAreaCornerLineColor = self.config.cornerColor; //四角颜色
//    _tkImageV.cropAreaBorderLineColor = [UIColor whiteColor]; //四边颜色
    _tkImageV.cropAreaCornerLineWidth = 2; //四角宽度
    _tkImageV.cropAreaBorderLineWidth = 0; //四边宽度
//    _tkImageV.cropAreaMidLineWidth = 20;
//    _tkImageV.cropAreaMidLineHeight = 0;
//    _tkImageV.cropAreaMidLineColor = [UIColor whiteColor];
//    _tkImageV.cropAreaCrossLineColor = [UIColor whiteColor];
    _tkImageV.cropAreaCrossLineWidth = 0;
    _tkImageV.initialScaleFactor = .8f; //初始选中框占比
    _tkImageV.cropAspectRatio = self.config.ratio; //选中框宽高比
}

- (void)setBottomView {
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:cancel];
    [cancel setTitle:self.config.cancel forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancel.frame = CGRectMake(30, CGRectGetMaxY(self.tkImageV.frame), 60, 50);
    [cancel addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *config = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:config];
    [config setTitle:self.config.select forState:UIControlStateNormal];
    [config setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    config.frame = CGRectMake(CGRectGetMaxX(self.tkImageV.frame)-90, CGRectGetMaxY(self.tkImageV.frame), 60, 50);
    [config addTarget:self action:@selector(onConfig) forControlEvents:UIControlEventTouchUpInside];
}

//MARK: ---------------- Action ----------------
- (void)onCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onConfig {
    
    if (self.callBlock) {
        self.callBlock([_tkImageV currentCroppedImage]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK: ---------------- lazy ----------------

- (TKImageView *)tkImageV {
    if (!_tkImageV) {
        _tkImageV = [[TKImageView alloc] init];
        _tkImageV.contentMode = UIViewContentModeScaleToFill;
    }
    return _tkImageV;
}

//MARK: ---------------- Other ----------------

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
@end

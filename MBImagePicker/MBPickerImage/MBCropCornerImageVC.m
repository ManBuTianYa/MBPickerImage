//
//  MBCropCornerImageVC.m
//  MBImagePicker
//
//  Created by iOS on 2020/12/25.
//  Copyright © 2020 www. iOSProject.com. All rights reserved.
//

#import "MBCropCornerImageVC.h"
#import "MBImagePicker.h"
#import "UIImage+Crop.h"

@interface MBCropCornerImageVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation MBCropCornerImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setSubView];
    
    [self setBottomView];
}

- (void)setSubView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat height = (ScreenHeight - ScreenWidth)/2.0;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height ,ScreenWidth,ScreenWidth)];
    _scrollView.bouncesZoom = YES;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 5;
    _scrollView.zoomScale = 1;
    _scrollView.delegate = self;
    _scrollView.layer.masksToBounds = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.layer.borderWidth = 1.5;
    _scrollView.layer.borderColor = self.config.cornerColor.CGColor;
    _scrollView.layer.cornerRadius = ScreenWidth/2.0;
    
    self.view.layer.masksToBounds = YES;
    if (self.image) {
        _imageView = [[UIImageView alloc] initWithImage:self.image];
        CGFloat img_width = ScreenWidth;
        CGFloat img_height = self.image.size.height * (img_width/self.image.size.width);
        CGFloat img_y= (img_height - self.view.bounds.size.width)/2.0;
        _imageView.frame = CGRectMake(0,0, img_width, img_height);
        _imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:_imageView];
        
        
        _scrollView.contentSize = CGSizeMake(img_width, img_height);
        _scrollView.contentOffset = CGPointMake(0, img_y);
        [self.view addSubview:_scrollView];
    }
    
    CGRect cropframe = _scrollView.frame;
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds cornerRadius:0];
    UIBezierPath * cropPath = [UIBezierPath bezierPathWithOvalInRect:cropframe];
    [path appendPath:cropPath];
    
    CAShapeLayer * layer = [[CAShapeLayer alloc] init];
    layer.fillColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:0.5].CGColor;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.path = path.CGPath;
    [self.view.layer addSublayer:layer];
    
}

- (void)setBottomView {
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:cancel];
    [cancel setTitle:self.config.cancel forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancel.frame = CGRectMake(30, CGRectGetMaxY(self.view.frame)-(KISIphoneX? 34:0)-100, 60, 50);
    [cancel addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *config = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:config];
    [config setTitle:self.config.select forState:UIControlStateNormal];
    [config setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    config.frame = CGRectMake(CGRectGetMaxX(self.scrollView.frame)-90, CGRectGetMaxY(self.view.frame)-(KISIphoneX? 34:0)-100, 60, 50);
    [config addTarget:self action:@selector(onConfig) forControlEvents:UIControlEventTouchUpInside];
}

//MARK: ---------------- Action ----------------
- (void)onCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onConfig {
    
    if (self.callBlock) {
        self.callBlock([self cropImage]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //调整位置
    [self centerContent];
}
- (void)centerContent {
    CGRect imageViewFrame = _imageView.frame;
    
    CGRect scrollBounds = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
    if (imageViewFrame.size.height > scrollBounds.size.height) {
        imageViewFrame.origin.y = 0.0f;
    }else {
        imageViewFrame.origin.y = (scrollBounds.size.height - imageViewFrame.size.height) / 2.0;
    }
    if (imageViewFrame.size.width < scrollBounds.size.width) {
        imageViewFrame.origin.x = (scrollBounds.size.width - imageViewFrame.size.width) /2.0;
    }else {
        imageViewFrame.origin.x = 0.0f;
    }
    _imageView.frame = imageViewFrame;
}

- (UIImage *)cropImage {
    CGPoint offset = _scrollView.contentOffset;
    //图片缩放比例
    CGFloat zoom = _imageView.frame.size.width/self.image.size.width;
    //视网膜屏幕倍数相关
    zoom = zoom / [UIScreen mainScreen].scale;
    
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height;
    if (_imageView.frame.size.height < _scrollView.frame.size.height) {//太胖了,取中间部分
        offset = CGPointMake(offset.x + (width - _imageView.frame.size.height)/2.0, 0);
        width = height = _imageView.frame.size.height;
    }
    
    CGRect rec = CGRectMake(offset.x/zoom, offset.y/zoom,width/zoom,height/zoom);
    CGImageRef imageRef =CGImageCreateWithImageInRect([self.image CGImage],rec);
    UIImage * image = [[UIImage alloc]initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    image = [image ovalClip];
    
    return image;
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

//
//  sampleView.h
//  ImageBlurEffect
//
//  Created by Mahesh Shanbhag on 11/22/13.
//  Copyright (c) 2013 Mahesh Shanbhag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlurView : UIView


@property(nonatomic, strong) UIColor *tintColor;
@property(nonatomic, assign) CGFloat saturationFactor;
@property(nonatomic, assign) CGFloat blurRadius;


- (void)setTranslucentParentView:(UIView *)view translate:(CGPoint)point;
- (void)setTranslucentParentViewTranslating:(UIView *)view translate:(CGPoint)point;

@end

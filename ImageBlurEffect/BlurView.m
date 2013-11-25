//
//  sampleView.m
//  ImageBlurEffect
//
//  Created by Mahesh Shanbhag on 11/22/13.
//  Copyright (c) 2013 Mahesh Shanbhag. All rights reserved.
//

#import "BlurView.h"
#import "UIImage+ImageEffects.h"

@interface BlurView ()

@property(nonatomic, strong)UIImage *bluredImage;
@property(nonatomic, strong)UIImageView *bluredImageView;

@end

@implementation BlurView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tintColor = [UIColor colorWithWhite:0.4f alpha:0.4];
        self.blurRadius = 3.0f;
        self.saturationFactor = 1.8f;
        
        [self initBluredImageView];
        self.layer.masksToBounds = YES;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)initBluredImageView
{
    self.bluredImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.bluredImageView.userInteractionEnabled = YES;
    [self addSubview:self.bluredImageView];
}

- (void)setTranslucentParentView:(UIView *)view translate:(CGPoint)point
{
    // x, y and size variables below are only examples.
    // You will want to calculate this in code based on the view you will be presenting.
    float x = point.x;
    float y = point.y;
    CGSize size = CGSizeMake(self.bounds.size.width,self.bounds.size.height);
    //CGRect snapShotFrame = CGRectMake(x, y, size.width, size.height);
    
    
    
    UIGraphicsBeginImageContext(size);
    CGContextRef c = UIGraphicsGetCurrentContext();
    NSDate *startDate = [NSDate date];
    
    CGContextTranslateCTM(c, -x, -y);
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        [view drawViewHierarchyInRect:view.frame afterScreenUpdates:YES];
    }
    else
    {
        [view.layer renderInContext:c];
    }
    NSLog(@"Time Taken for SnapShot %f",[[NSDate date] timeIntervalSinceDate:startDate]);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *bluredImage =   [image applyBlurWithRadius:self.blurRadius tintColor:self.tintColor saturationDeltaFactor:self.saturationFactor maskImage:nil];
    startDate = [NSDate date];
    [self setBackgroundColor:[UIColor colorWithPatternImage:bluredImage]];
    NSLog(@"Time Taken for Setting Background %f",[[NSDate date] timeIntervalSinceDate:startDate]);
}

- (void)setTranslucentParentViewTranslating:(UIView *)view translate:(CGPoint)point
{
    // x, y and size variables below are only examples.
    // You will want to calculate this in code based on the view you will be presenting.
    float x = point.x;
    float y = point.y;
    CGSize size = CGSizeMake(view.bounds.size.width,view.bounds.size.height);
    //CGRect snapShotFrame = CGRectMake(x, y, size.width, size.height);
    
    
    if(!self.bluredImage)
    {
        UIGraphicsBeginImageContext(size);
        CGContextRef c = UIGraphicsGetCurrentContext();
        NSDate *startDate = [NSDate date];
        
        if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [view drawViewHierarchyInRect:view.frame afterScreenUpdates:YES];
        }
        else
        {
            [view.layer renderInContext:c];
        }
        
        NSLog(@"Time Taken for SnapShot %f",[[NSDate date] timeIntervalSinceDate:startDate]);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.bluredImage =   [image applyBlurWithRadius:self.blurRadius tintColor:self.tintColor saturationDeltaFactor:self.saturationFactor maskImage:nil];
        startDate = [NSDate date];
        [[self bluredImageView] setImage:self.bluredImage];
        self.bluredImageView.frame = CGRectMake(x, -y, CGRectGetWidth(self.bounds), CGRectGetHeight(view.bounds));
        NSLog(@"Time Taken for Setting Background %f",[[NSDate date] timeIntervalSinceDate:startDate]);
        return;
    }
    
    NSDate *startDate = [NSDate date];
    self.bluredImageView.frame = CGRectMake(x, -y, CGRectGetWidth(self.bounds), CGRectGetHeight(view.bounds));
    NSLog(@"Time Taken for Setting ImageView Frame %f",[[NSDate date] timeIntervalSinceDate:startDate]);
}

@end

//
//  ViewController.m
//  ImageBlurEffect
//
//  Created by Mahesh Shanbhag on 11/21/13.
//  Copyright (c) 2013 Mahesh Shanbhag. All rights reserved.
//

#import "ViewController.h"
#import "BlurView.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong) BlurView *blurView;
@property(nonatomic, strong) BlurView *blurPanView;
@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UIView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    self.containerView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.containerView.backgroundColor = [UIColor  redColor];
    [self.view addSubview:self.containerView];
    
    self.imgView = [[UIImageView alloc]initWithFrame:self.containerView.bounds];
    [self.imgView setImage:[UIImage imageNamed:@"brave"]];
    //self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView.userInteractionEnabled = YES;
    [self.containerView addSubview:self.imgView];
    
    self.blurView = [[BlurView alloc]initWithFrame:self.containerView.bounds];
    [self.blurView setBackgroundColor:[UIColor clearColor]];
    self.blurView.blurRadius = 3.0f;
    self.blurView.layer.cornerRadius = 25.0f;
    self.blurView.layer.borderColor = [UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0f].CGColor;
    self.blurView.layer.borderWidth = 2.0f;
    
    UIPanGestureRecognizer *singleTouch = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(singleTouchPan:)];
    [singleTouch setMaximumNumberOfTouches:1];
    [singleTouch setMinimumNumberOfTouches:1];
    singleTouch.delegate = self;
    [self.containerView addGestureRecognizer:singleTouch];
    
    
    self.blurPanView = [[BlurView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.containerView.bounds), CGRectGetMaxY(self.containerView.bounds), CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame))];
    self.blurPanView.blurRadius = 3.0f;
    [self.blurPanView setBackgroundColor:[UIColor clearColor]];

    UIPanGestureRecognizer *doubleTouch = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTouchPan:)];
    [doubleTouch setMaximumNumberOfTouches:2];
    [doubleTouch setMinimumNumberOfTouches:2];
    doubleTouch.delegate = self;
    [self.containerView addGestureRecognizer:doubleTouch];
}

- (void)dealloc
{
    [_blurView removeFromSuperview];
    [_imgView removeFromSuperview];
    [_containerView removeFromSuperview];
    
    _blurView = nil;
    _imgView = nil;
    _containerView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Image Blur Effect" message:[NSString stringWithFormat:@"Single Tap and Pan to get Blur effect on a image dynamically.\n\n Double Tap and Pan to get Blur effect for a pre-rendered image."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [super viewDidAppear:YES];
}


#pragma mark - Double Touch Pan
- (void)singleTouchPan:(UIGestureRecognizer *)gestureRecognizer
{
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gestureRecognizer locationInView:self.view];
        CGRect frame = CGRectMake(point.x - 100.0f, point.y - 100.0f, 100.0f, 100.0f);
        self.blurView.frame = frame;
        [self.view addSubview:self.blurView];
        [self.blurView setTranslucentParentView:self.containerView translate:CGPointMake(point.x - 100.0f, point.y - 100.0f)];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [gestureRecognizer locationInView:self.view];
        CGRect frame = CGRectMake(point.x - 100.0f, point.y - 100.0f, 100.0f, 100.0f);
        self.blurView.frame = frame;
        [self.blurView setTranslucentParentView:self.containerView translate:CGPointMake(point.x - 100.0f, point.y - 100.0f)];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled)
    {
        [self.blurView removeFromSuperview];
    }
    else
    {
        [self.blurView removeFromSuperview];
    }
    
   
}

- (void)doubleTouchPan:(UIGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gestureRecognizer locationInView:self.view];
        CGRect frame = CGRectMake(0.0f, point.y, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - point.y);
        self.blurPanView.frame = frame;
        [self.view addSubview:self.blurPanView];
        [self.blurPanView setTranslucentParentViewTranslating:self.containerView translate:CGPointMake(0.0f, point.y)];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [gestureRecognizer locationInView:self.view];
        CGRect frame = CGRectMake(0.0f, point.y, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - point.y);
        self.blurPanView.frame = frame;
        [self.blurPanView setTranslucentParentViewTranslating:self.containerView translate:CGPointMake(0.0f, point.y)];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled)
    {
        [self.blurPanView removeFromSuperview];
    }
    else
    {
        [self.blurPanView removeFromSuperview];
    }
}

#pragma mark - Gesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

@end

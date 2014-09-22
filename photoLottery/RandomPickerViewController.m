//
//  RandomPickerViewController.m
//  photoLottery
//
//  Created by Hank  on 2014/9/18.
//  Copyright (c) 2014年 eala. All rights reserved.
//

#import "RandomPickerViewController.h"
#import "AudioController.h"
#import "awardView.h"

@interface RandomPickerViewController ()
@property (strong, nonatomic) AudioController *audioController;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) int endSide;
@property (nonatomic) BOOL firstRound;
//@property (nonatomic, strong) NSMutableArray* index2Images;
@end

@implementation RandomPickerViewController

#define TURN_ON_MUSIC 1
#define IMAGE_SIDE_LENGTH 128
#define MAX_IMAGES_COUNT 24

#define TOTAL_SCREEN_SIDES 4
#define PICS_IN_LONG_SIDE 8
#define PICS_IN_SHORT_SIDE 6

-(targetIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[targetIndicatorView alloc] init];
    }
    return _indicatorView;
}

/*
-(NSMutableArray *)index2Images
{
    if (!_index2Images) {
        _index2Images = [[NSMutableArray alloc] init];
    }
    return _index2Images;
}
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Hidden navigation bar in default
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(showHideNavbar:)];
    [self.view addGestureRecognizer:tapGesture];
    
    _firstRound = YES;
    
    #if TURN_ON_MUSIC
    self.audioController = [[AudioController alloc] init];
    [self.audioController playBackgroundMusic];
    #endif
    
    CGRect imageCoord[MAX_IMAGES_COUNT];
    int i=0, offsetLongSide=0, offsetShortSide=0;
    while (i<PICS_IN_LONG_SIDE-1) {
        imageCoord[i++] = CGRectMake(offsetLongSide, 0, IMAGE_SIDE_LENGTH, IMAGE_SIDE_LENGTH);
        offsetLongSide += IMAGE_SIDE_LENGTH;
    }
    while (i<PICS_IN_LONG_SIDE+PICS_IN_SHORT_SIDE-2){
        imageCoord[i++] = CGRectMake(offsetLongSide, offsetShortSide, IMAGE_SIDE_LENGTH, IMAGE_SIDE_LENGTH);
        offsetShortSide += IMAGE_SIDE_LENGTH;
    }
    while (i< 2*PICS_IN_LONG_SIDE+PICS_IN_SHORT_SIDE-3) {
        imageCoord[i++] = CGRectMake(offsetLongSide, offsetShortSide, IMAGE_SIDE_LENGTH, IMAGE_SIDE_LENGTH);
        offsetLongSide -= IMAGE_SIDE_LENGTH;
    }
    while (i< 2*PICS_IN_LONG_SIDE+2*PICS_IN_SHORT_SIDE-4) {
        imageCoord[i++] = CGRectMake(offsetLongSide, offsetShortSide, IMAGE_SIDE_LENGTH, IMAGE_SIDE_LENGTH);
        offsetShortSide -= IMAGE_SIDE_LENGTH;
    }
    
    /*
    for(int i=0; i<self.selectedImages.count; ++i){
        [self.index2Images addObject: [NSNumber init]];
    }
     */
    
    if( self.selectedImages.count > MAX_IMAGES_COUNT){
        // first select head MAX_IMAGES_COUNT index
    }else if (self.selectedImages.count == MAX_IMAGES_COUNT){
        // no need to do anything
    }else if (self.selectedImages.count < MAX_IMAGES_COUNT && self.selectedImages.count > 0){
        int originalSize = self.selectedImages.count;
        for (int i=0; i< MAX_IMAGES_COUNT - originalSize; ++i) {
            int idx = arc4random() % self.selectedImages.count;
            [self.selectedImages addObject: self.selectedImages[idx]];
        }
    }
    
    if (self.selectedImages.count > 0) {
        for (int i=0; i<MAX_IMAGES_COUNT; ++i){
            UIImageView *imageview = [[UIImageView alloc] initWithImage:self.selectedImages[i]];
            //[imageview setContentMode:UIViewContentModeScaleAspectFit];
            //[imageview setContentMode:UIViewContentModeScaleAspectFill];
            [imageview setContentMode:UIViewContentModeScaleToFill];
            imageview.frame = imageCoord[i];
            [self.view addSubview:imageview];
        }
    }
    
    [self.view addSubview:self.indicatorView];
	self.indicatorView.frame = CGRectMake(0, 0, IMAGE_SIDE_LENGTH, IMAGE_SIDE_LENGTH);
    self.indicatorView.alpha = 0.2f;
}

-(void) showHideNavbar:(id) sender
{
    // write code to show/hide nav bar here
    // check if the Navigation Bar is shown
    if (self.navigationController.navigationBar.hidden == NO)
    {
        // hide the Navigation Bar
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    // if Navigation Bar is already hidden
    else if (self.navigationController.navigationBar.hidden == YES)
    {
        // Show the Navigation Bar
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    // enlarge the selected image or navigate to the new page
    
    /*
    UIView *popView = [[UIView alloc] init];
    popView.frame = self.view.frame;
    popView.backgroundColor = [UIColor greenColor];
    popView.opaque = NO;
    [self.view addSubview:popView];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:self.selectedImages[2]];
    //[imageview setContentMode:UIViewContentModeScaleAspectFit];
    //[imageview setContentMode:UIViewContentModeScaleAspectFill];
    [imageview setContentMode:UIViewContentModeScaleToFill];
    imageview.frame = CGRectMake(0, 20, 100, 100);
    [popView addSubview:imageview];
    
    [self.view setNeedsDisplay];
     */
    
    awardView *_awardView = [[awardView alloc]init];
    _awardView.frame = self.view.frame;
    [self.view addSubview: _awardView];
    [self.view setNeedsDisplay];
}

-(void)dismissParentView
{
    
//    [self removeFromSuperview];
}

- (IBAction)startRandom:(id)sender
{
    #if TURN_ON_MUSIC
    [self.audioController playEffectSound];
    #endif
    
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    CALayer *targetIndicatorLayer = self.indicatorView.layer;
	
	// Create a keyframe animation to follow a path back to the center.
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	//bounceAnimation.removedOnCompletion = NO;
	bounceAnimation.removedOnCompletion = YES;
    
	CGFloat animationDuration = 8.0f;
	
	// Create the path for the bounces.
	UIBezierPath *bouncePath = [[UIBezierPath alloc] init];
	
    // use Button click to adjust stopBouncing value
    int offset = (int)(IMAGE_SIDE_LENGTH/2.0);
    CGPoint leftTopPt = CGPointMake(self.view.frame.origin.x + offset, self.view.frame.origin.y + offset);
    CGPoint rightTopPt = CGPointMake(self.view.frame.origin.x + self.view.frame.size.width - offset, self.view.frame.origin.y + offset);
    CGPoint rightButtomPt = CGPointMake(self.view.frame.origin.x + self.view.frame.size.width - offset, self.view.frame.origin.y + self.view.frame.size.height - offset);
    CGPoint leftButtomPt = CGPointMake(self.view.frame.origin.x + offset, self.view.frame.origin.y + self.view.frame.size.height - offset);
    
    if (self.firstRound) {
        [bouncePath moveToPoint:leftTopPt];
        self.firstRound = NO;
    }else{
        [bouncePath moveToPoint:self.endPoint];
        if (self.endSide < 1) [bouncePath addLineToPoint:rightTopPt];
        if (self.endSide < 2) [bouncePath addLineToPoint:rightButtomPt];
        if (self.endSide < 3) [bouncePath addLineToPoint:leftButtomPt];
        [bouncePath addLineToPoint:leftTopPt];
    }
    
    const int minCircles = 4;
    const int maxCircles = 10;
    int numCircles =  (arc4random() % (maxCircles-minCircles+1)) + minCircles;
    
    for (int i=0; i<numCircles; ++i) {
        [bouncePath addLineToPoint:rightTopPt];
        [bouncePath addLineToPoint:rightButtomPt];
        [bouncePath addLineToPoint:leftButtomPt];
        [bouncePath addLineToPoint:leftTopPt];
    }
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    self.endSide = arc4random() % TOTAL_SCREEN_SIDES;
    int picsPerSide = 0;
    
    if (UIInterfaceOrientationPortrait == interfaceOrientation || UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation) {
        picsPerSide = ( 0 == (self.endSide % 2) )? PICS_IN_SHORT_SIDE : PICS_IN_LONG_SIDE;
    }else if(UIInterfaceOrientationLandscapeLeft == interfaceOrientation || UIInterfaceOrientationLandscapeRight == interfaceOrientation){
        picsPerSide = ( 1 == (self.endSide % 2) )? PICS_IN_SHORT_SIDE : PICS_IN_LONG_SIDE;
    }
    
    int sideOffset = arc4random() % picsPerSide;
    if (self.endSide > 0) [bouncePath addLineToPoint:rightTopPt];
    if (self.endSide > 1) [bouncePath addLineToPoint:rightButtomPt];
    if (self.endSide > 2) [bouncePath addLineToPoint:leftButtomPt];
    
    int xMultiplier=1, yMultiplier=1;
    switch (self.endSide) {
        case 0:
            xMultiplier=1;
            yMultiplier=0;
            break;
        case 1:
            xMultiplier=0;
            yMultiplier=1;
            break;
        case 2:
            xMultiplier=-1;
            yMultiplier=0;
            break;
        case 3:
            xMultiplier=0;
            yMultiplier=-1;
            break;
    }

    self.endPoint = CGPointMake(bouncePath.currentPoint.x + (sideOffset * xMultiplier * IMAGE_SIDE_LENGTH), bouncePath.currentPoint.y + (sideOffset * yMultiplier * IMAGE_SIDE_LENGTH));
    [bouncePath addLineToPoint: self.endPoint];

	bounceAnimation.path = [bouncePath CGPath];
	bounceAnimation.duration = animationDuration;
	
	// Create an animation group to combine the keyframe and basic animations.
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	
	// Set self as the delegate to allow for a callback to reenable user interaction.
	theGroup.delegate = self;
	theGroup.duration = animationDuration;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	theGroup.animations = [NSArray arrayWithObject:bounceAnimation];
    theGroup.removedOnCompletion = NO;
	
	// Add the animation group to the layer.
	[targetIndicatorLayer addAnimation:theGroup forKey:@"animatePosition"];
    
    targetIndicatorLayer.position = self.endPoint;

}

@end

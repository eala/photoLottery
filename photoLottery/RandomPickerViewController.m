//
//  RandomPickerViewController.m
//  photoLottery
//
//  Created by Hank  on 2014/9/18.
//  Copyright (c) 2014年 eala. All rights reserved.
//

#import "RandomPickerViewController.h"
#import "AudioController.h"

@interface RandomPickerViewController ()
@property (strong, nonatomic) AudioController *audioController;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) int endSide;
@property (nonatomic) BOOL firstRound;
@end

@implementation RandomPickerViewController

#define TURN_ON_MUSIC 1

-(targetIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[targetIndicatorView alloc] init];
    }
    return _indicatorView;
}

-(AudioController *)audioController
{
    if (!_audioController) {
        _audioController = [[AudioController alloc] init];
    }
    return _audioController;
}

// fixme later, check the height & width of iPad mini, and set unitSide as large as targetIndicatorView
const int unitSide = 128;

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
    
    _firstRound = YES;
    
    #if TURN_ON_MUSIC
    [self.audioController playBackgroundMusic];
    #endif
    
    // display images
    int offset = 0;
    for (UIImage *image in self.selectedImages){
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        //[imageview setContentMode:UIViewContentModeScaleAspectFit];
        //[imageview setContentMode:UIViewContentModeScaleAspectFill];
        [imageview setContentMode:UIViewContentModeScaleToFill];
        imageview.frame = CGRectMake(0, offset, 128, 128);
        offset+=128;
        
        [self.view addSubview:imageview];
    }
    
    [self.view addSubview:self.indicatorView];
	self.indicatorView.frame = CGRectMake(0, 0, unitSide, unitSide);
    self.indicatorView.alpha = 0.2f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    // enlarge the selected image or navigate to the new page
}

- (IBAction)startRandom:(id)sender 
{
    #if TURN_ON_MUSIC
    [self.audioController playEffectSound];
    #endif
    CALayer *targetIndicatorLayer = self.indicatorView.layer;
	
	// Create a keyframe animation to follow a path back to the center.
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	//bounceAnimation.removedOnCompletion = NO;
	bounceAnimation.removedOnCompletion = YES;
    
	CGFloat animationDuration = 8.0f;
	
	// Create the path for the bounces.
	UIBezierPath *bouncePath = [[UIBezierPath alloc] init];
	
    // use Button click to adjust stopBouncing value
    int offset = (int)(unitSide/2.0);
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
    
    const int totalSides = 4;
    const int picsInLongSide = 8;
    const int picsInShortSide = 6;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    self.endSide = arc4random() % totalSides;
    int picsPerSide = 0;
    
    if (UIInterfaceOrientationPortrait == interfaceOrientation || UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation) {
        picsPerSide = ( 0 == (self.endSide % 2) )? picsInShortSide :picsInLongSide;
    }else if(UIInterfaceOrientationLandscapeLeft == interfaceOrientation || UIInterfaceOrientationLandscapeRight == interfaceOrientation){
        picsPerSide = ( 1 == (self.endSide % 2) )? picsInShortSide :picsInLongSide;
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

    self.endPoint = CGPointMake(bouncePath.currentPoint.x + (sideOffset * xMultiplier * unitSide), bouncePath.currentPoint.y + (sideOffset * yMultiplier * unitSide));
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

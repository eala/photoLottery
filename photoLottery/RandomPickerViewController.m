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
@property (strong, nonatomic) targetIndicatorView *indicatorView;

@property (nonatomic) CGPoint endPoint;
@property (nonatomic) int endSide;
@property (nonatomic) BOOL firstRound;
@property (nonatomic) float nImageSideLength;
@property (nonatomic) int nLongSidePicCount;

@property (nonatomic, strong) NSMutableArray* selectedImagesIdx;
@property (nonatomic, strong) NSMutableArray* coordIndicator;

@property (nonatomic) int index2Image;
@end

@implementation RandomPickerViewController

#define TURN_ON_MUSIC 1

#define TOTAL_SCREEN_SIDES 4.0
#define PICS_IN_SHORT_SIDE 4
#define MAX_IMAGES_COUNT (2*(self.nLongSidePicCount + PICS_IN_SHORT_SIDE) - 4)

-(float)nImageSideLength{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return MIN(screenRect.size.width, screenRect.size.height)/PICS_IN_SHORT_SIDE;
}

-(int)nLongSidePicCount{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.width/self.nImageSideLength;
}

-(targetIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[targetIndicatorView alloc] init];
    }
    return _indicatorView;
}

-(NSMutableArray *)selectedImagesIdx
{
    if (!_selectedImagesIdx) {
        _selectedImagesIdx = [[NSMutableArray alloc]init];
    }
    return _selectedImagesIdx;
}

-(NSMutableArray *)coordIndicator
{
    if (!_coordIndicator) {
        _coordIndicator = [[NSMutableArray alloc]init];
    }
    return _coordIndicator;
}

- (NSMutableArray *)selectedImages
{
    if (!_selectedImages){
        _selectedImages = [[NSMutableArray alloc] init];
    }
    return _selectedImages;
}

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
    [self.view setBackgroundColor: [UIColor colorWithRed:246.0/255.0 green:107.0/255.0 blue:133.0/255.0 alpha:1] ];

    
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
    
    int i=0, offsetLongSide=0, offsetShortSide=0;
    
    while (i< self.nLongSidePicCount-1) {
        [self.coordIndicator addObject: [NSValue valueWithCGRect:CGRectMake(offsetLongSide, 0, self.nImageSideLength, self.nImageSideLength)]];
        i++;
        offsetLongSide += self.nImageSideLength;
    }
    while (i<self.nLongSidePicCount+PICS_IN_SHORT_SIDE-2){
        [self.coordIndicator addObject: [NSValue valueWithCGRect:CGRectMake(offsetLongSide, offsetShortSide, self.nImageSideLength, self.nImageSideLength)]];
        i++;
        offsetShortSide += self.nImageSideLength;
    }
    while (i< 2*self.nLongSidePicCount+PICS_IN_SHORT_SIDE-3) {
        [self.coordIndicator addObject: [NSValue valueWithCGRect:CGRectMake(offsetLongSide, offsetShortSide, self.nImageSideLength, self.nImageSideLength)]];
        i++;
        offsetLongSide -= self.nImageSideLength;
    }
    while (i< 2*self.nLongSidePicCount+2*PICS_IN_SHORT_SIDE-4) {
        [self.coordIndicator addObject: [NSValue valueWithCGRect:CGRectMake(offsetLongSide, offsetShortSide, self.nImageSideLength, self.nImageSideLength)]];
        i++;
        offsetShortSide -= self.nImageSideLength;
    }
    for (int i=0; i< self.selectedImages.count; ++i) {
        [self.selectedImagesIdx addObject:[NSNumber numberWithInt:i]];
    }
    
    int sourceImgCount = self.selectedImages.count;
    
    if( self.selectedImages.count > MAX_IMAGES_COUNT){
        // first select head MAX_IMAGES_COUNT index
    }else if (self.selectedImages.count == MAX_IMAGES_COUNT){
        // no need to do anything
    }else if (self.selectedImages.count < MAX_IMAGES_COUNT && self.selectedImages.count > 0){
        for (int i=sourceImgCount ; i< MAX_IMAGES_COUNT; ++i) {
            int idx = arc4random() % sourceImgCount;
            [self.selectedImagesIdx addObject: [NSNumber numberWithInt:idx]];
            //[self.selectedImages addObject: self.selectedImages[idx]];
        }
    }
    
    if (self.selectedImages.count > 0) {
        for (int i=0; i<MAX_IMAGES_COUNT; ++i){
            //UIImageView *imageview = [[UIImageView alloc] initWithImage:self.selectedImages[i]];
            UIImageView *imageview = [[UIImageView alloc] initWithImage:self.selectedImages[[self.selectedImagesIdx[i] intValue]]];
            //[imageview setContentMode:UIViewContentModeScaleAspectFit];
            //[imageview setContentMode:UIViewContentModeScaleAspectFill];
            [imageview setContentMode:UIViewContentModeScaleToFill];
            //imageview.frame = imageCoord[i];
            imageview.frame = [self.coordIndicator[i] CGRectValue];
            imageview.layer.masksToBounds = YES;
            imageview.layer.cornerRadius = 10.f;
            imageview.layer.borderWidth = 2.f;
            [self.view addSubview:imageview];
        }
    }
    
    // 2. red indicator rectangle
    [self.view addSubview:self.indicatorView];
	self.indicatorView.frame = CGRectMake(0, 0, self.nImageSideLength, self.nImageSideLength);
    self.indicatorView.backgroundColor = [UIColor clearColor];
    self.indicatorView.alpha = 1.0f;
    
    // 3. start button
    UIButton *startButton = [[UIButton alloc] init];
    
    CGRect mainWin = [[UIScreen mainScreen] bounds];
    float buttonW = mainWin.size.height - self.nImageSideLength * 2;
    float buttonH = buttonW;
    startButton.frame = CGRectMake( (mainWin.size.width - buttonW)/2.0, self.nImageSideLength, buttonW, buttonH);

    [startButton setBackgroundImage:[UIImage imageNamed:@"start_circle_button"] forState:UIControlStateNormal];
    [startButton addTarget:self
                      action:@selector(startRandom:)
            forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:startButton];
}

// hidden time & battery etc. status
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
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
    
    awardView *awardview = [[awardView alloc]init];
    awardview.frame = CGRectMake(self.nImageSideLength, self.nImageSideLength, self.nImageSideLength*(self.nLongSidePicCount-2), self.nImageSideLength*(PICS_IN_SHORT_SIDE-2));
    awardview.controller = self;
    
    /*
    UIButton *nextRoundButton = [[UIButton alloc] init];
    float offset = 16;
    float buttonW = 256;
    float buttonH = 128;
    nextRoundButton.frame = CGRectMake(awardview.bounds.size.width - buttonW - offset, awardview.bounds.size.height, buttonW, buttonH);
    [nextRoundButton setBackgroundImage:[UIImage imageNamed:@"start_button.png"] forState:UIControlStateNormal];
    [nextRoundButton setTitle:@"GO" forState:UIControlStateNormal];
    [nextRoundButton addTarget:self
                        action:@selector(startRandom:)
              forControlEvents:UIControlEventTouchUpInside];
    [awardview addSubview:nextRoundButton];
     */
    
    if (self.selectedImages.count > 0) {
        [awardview setShowImage:self.selectedImages[[self.selectedImagesIdx[self.index2Image] intValue]]];
        
        [self.view addSubview: awardview];
        [self.view setNeedsDisplay];
    }
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
    int offset = (int)(self.nImageSideLength/2.0);
    CGPoint leftTopPt = CGPointMake(self.view.frame.origin.x + offset, self.view.frame.origin.y + offset);
    CGPoint rightTopPt = CGPointMake(self.view.frame.origin.x + self.view.frame.size.width - offset, self.view.frame.origin.y + offset);
    CGPoint rightButtomPt = CGPointMake(self.view.frame.origin.x + self.view.frame.size.width - offset, self.view.frame.origin.y + self.view.frame.size.height - offset);
    CGPoint leftButtomPt = CGPointMake(self.view.frame.origin.x + offset, self.view.frame.origin.y + self.view.frame.size.height - offset);
    
    const int TOP_ROW_COUNT = 8;
    const int RIGHT_AND_BOTTOM_COUNT = 13;
    const int LEFT_AND_BOTTOM_COUNT = 20;
    
    if (self.firstRound) {
        [bouncePath moveToPoint:leftTopPt];
        self.firstRound = NO;
    }else{
        [bouncePath moveToPoint:self.endPoint];
        if (self.index2Image < TOP_ROW_COUNT) [bouncePath addLineToPoint:rightTopPt];
        if (self.index2Image < RIGHT_AND_BOTTOM_COUNT) [bouncePath addLineToPoint:rightButtomPt];
        if (self.index2Image < LEFT_AND_BOTTOM_COUNT) [bouncePath addLineToPoint:leftButtomPt];
        [bouncePath addLineToPoint:leftTopPt];
    }
    
    //const int minCircles = 4;
    //const int maxCircles = 10;
    //int numCircles =  (arc4random() % (maxCircles-minCircles+1)) + minCircles;
    int numCircles = 10;
    
    for (int i=0; i<numCircles; ++i) {
        [bouncePath addLineToPoint:rightTopPt];
        [bouncePath addLineToPoint:rightButtomPt];
        [bouncePath addLineToPoint:leftButtomPt];
        [bouncePath addLineToPoint:leftTopPt];
    }
    
    //UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    //self.endSide = arc4random() % TOTAL_SCREEN_SIDES;
    //int picsPerSide = 0;
    
    //if (UIInterfaceOrientationPortrait == interfaceOrientation || UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation) {
    //    picsPerSide = ( 0 == (self.endSide % 2) )? PICS_IN_SHORT_SIDE : PICS_IN_LONG_SIDE;
    //}else if(UIInterfaceOrientationLandscapeLeft == interfaceOrientation || UIInterfaceOrientationLandscapeRight == interfaceOrientation){
    //    picsPerSide = ( 1 == (self.endSide % 2) )? PICS_IN_SHORT_SIDE : PICS_IN_LONG_SIDE;
    //}
    
    self.index2Image = arc4random() % MAX_IMAGES_COUNT;


    if (self.index2Image < TOP_ROW_COUNT) {
        self.endPoint = CGPointMake(bouncePath.currentPoint.x + self.index2Image * self.nImageSideLength, bouncePath.currentPoint.y);
    }else if(self.index2Image < RIGHT_AND_BOTTOM_COUNT){
        [bouncePath addLineToPoint:rightTopPt];
        self.endPoint = CGPointMake(bouncePath.currentPoint.x , bouncePath.currentPoint.y + (self.index2Image-TOP_ROW_COUNT+1) * self.nImageSideLength);
    }else if (self.index2Image < LEFT_AND_BOTTOM_COUNT){
        [bouncePath addLineToPoint:rightTopPt];
        [bouncePath addLineToPoint:rightButtomPt];
        self.endPoint = CGPointMake(bouncePath.currentPoint.x - (self.index2Image-RIGHT_AND_BOTTOM_COUNT+1) * self.nImageSideLength, bouncePath.currentPoint.y);
    }else{
        [bouncePath addLineToPoint:rightTopPt];
        [bouncePath addLineToPoint:rightButtomPt];
        [bouncePath addLineToPoint:leftButtomPt];
        self.endPoint = CGPointMake(bouncePath.currentPoint.x, bouncePath.currentPoint.y - (self.index2Image-LEFT_AND_BOTTOM_COUNT+1) * self.nImageSideLength);
    }
    [bouncePath addLineToPoint:self.endPoint];
    
    /*
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

    self.endPoint = CGPointMake(bouncePath.currentPoint.x + (sideOffset * xMultiplier * self.nImageSideLength), bouncePath.currentPoint.y + (sideOffset * yMultiplier * self.nImageSideLength));
    [bouncePath addLineToPoint: self.endPoint];
    
    // calculate index to pic
    self.index2Image = 1;
    if (self.endSide > 0) self.index2Image += PICS_IN_LONG_SIDE-1;
    if (self.endSide > 1) self.index2Image += PICS_IN_SHORT_SIDE-1;
    if (self.endSide > 2) self.index2Image += PICS_IN_LONG_SIDE-1;
    self.index2Image += sideOffset + 1; // offset start from 0, but our index starts from first element, e.g. image[8] => side 1, offset 0
    if ( MAX_IMAGES_COUNT == self.index2Image) {
        self.index2Image = 0;
    }
     */

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

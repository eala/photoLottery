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
@end

@implementation RandomPickerViewController

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
    self.audioController = [[AudioController alloc] init];
    [self.audioController playBackgroundMusic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startRandom:(id)sender 
{
    [self.audioController playEffectSound];
    
    CALayer *targetIndicatorLayer = self.targetIndicatorOutlet.layer;
	
	// Create a keyframe animation to follow a path back to the center.
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	bounceAnimation.removedOnCompletion = NO;
	
	CGFloat animationDuration = 8.0f;
	
	// Create the path for the bounces.
	UIBezierPath *bouncePath = [[UIBezierPath alloc] init];
	
    // use Button click to adjust stopBouncing value
    int offset = 5;
    CGPoint leftTopPt = CGPointMake(self.view.frame.origin.x + offset, self.view.frame.origin.y + offset);
    CGPoint rightTopPt = CGPointMake(self.view.frame.origin.x + self.view.frame.size.width - 2 * offset, self.view.frame.origin.y + offset);
    CGPoint rightButtomPt = CGPointMake(self.view.frame.origin.x + self.view.frame.size.width - 2 * offset, self.view.frame.origin.y + self.view.frame.origin.y + self.view.frame.size.height - 2 * offset);
    CGPoint leftButtomPt = CGPointMake(self.view.frame.origin.x + offset, self.view.frame.origin.y + self.view.frame.origin.y + self.view.frame.size.height - 2 * offset);
    
    [bouncePath moveToPoint:leftTopPt];
    [bouncePath addLineToPoint:rightTopPt];
    [bouncePath addLineToPoint:rightButtomPt];
    [bouncePath addLineToPoint:leftButtomPt];
    [bouncePath addLineToPoint:leftTopPt];
	
	bounceAnimation.path = [bouncePath CGPath];
	bounceAnimation.duration = animationDuration;
	
	// Create an animation group to combine the keyframe and basic animations.
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	
	// Set self as the delegate to allow for a callback to reenable user interaction.
	theGroup.delegate = self;
	theGroup.duration = animationDuration;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	//theGroup.animations = @[bounceAnimation, transformAnimation];
	theGroup.animations = [NSArray arrayWithObject:bounceAnimation];
	
	// Add the animation group to the layer.
	[targetIndicatorLayer addAnimation:theGroup forKey:@"animatePosition"];
    
    bounceAnimation.path = [bouncePath CGPath];
    bounceAnimation.duration = animationDuration;
    
    [targetIndicatorLayer addAnimation:bounceAnimation forKey:@"targetIndicatorCircleFrame"];
}

@end

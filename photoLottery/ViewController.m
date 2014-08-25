//
//  ViewController.m
//  photoLottery
//
//  Created by eala on 2014/6/24.
//  Copyright (c) 2014年 eala. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) NSMutableArray *selectedImages;
@end

@implementation ViewController

+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize) newSize{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)stopButtonMethod
{
    //NSLog(@"Stop It!");
    UIImageView *view = (UIImageView*)[self.view viewWithTag:1];
    [view stopAnimating];
    //UIView *viewBeginaAnimated = view;
    //viewBeginaAnimated.frame = [[viewBeginaAnimated.layer presentationLayer] frame];
    //[viewBeginaAnimated.layer removeAllAnimations];
    //[view stopAnimating];
    //view.hidden = NO;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect imageSize = CGRectMake(0, self.view.frame.size.height*0.1, self.view.frame.size.width, self.view.frame.size.height*0.8);
    
    NSArray *imageNames = @[@"DSC00731.jpg", @"DSC00732.jpg", @"DSC00733.jpg", @"DSC00736.jpg",
                             @"DSC00737.jpg", @"DSC00739.jpg", @"DSC00740.jpg", @"DSC00741.jpg",
                             @"DSC00742.jpg", @"DSC00743.jpg"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for(size_t i=0; i<imageNames.count; ++i){
        UIImage *originalImg = [UIImage imageNamed:[imageNames objectAtIndex:i]];
        UIGraphicsBeginImageContextWithOptions(imageSize.size, NO, 0.0);
        [originalImg drawInRect:CGRectMake(0, 0, imageSize.size.width, imageSize.size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:newImage];
        
    }
    
    // Normal animation
    UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:imageSize];
    animationImageView.animationImages = images;
    //animationImageView.highlightedAnimationImages = images;
    animationImageView.animationDuration = 3;
    animationImageView.tag = 1;
    
    animationImageView.image = [images lastObject];
    
	[animationImageView startAnimating];


    [self.view addSubview:animationImageView];
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [stopButton addTarget:self
               action:@selector(stopButtonMethod)
     forControlEvents:UIControlEventTouchUpInside];
    [stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    int buttonWidth = 50;
    stopButton.frame = CGRectMake(0, imageSize.size.height, buttonWidth, buttonWidth);
    [self.view addSubview:stopButton];
    
    // re-start button
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

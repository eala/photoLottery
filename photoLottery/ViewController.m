//
//  ViewController.m
//  photoLottery
//
//  Created by eala on 2014/6/24.
//  Copyright (c) 2014年 eala. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSArray *imageNames = @[@"win_1.png", @"win_2.png", @"win_3.png", @"win_4.png",
                             @"win_5.png", @"win_6.png", @"win_7.png", @"win_8.png",
                             @"win_9.png", @"win_10.png", @"win_11.png", @"win_12.png",
                             @"win_13.png", @"win_14.png", @"win_15.png", @"win_16.png"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for(size_t i=0; i<imageNames.count; ++i){
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex: i]]];
    }
    
    // Normal animation
    UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 95, 86, 193)];
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 0.5;
	[animationImageView startAnimating];
    
    [self.view addSubview:animationImageView];
    
    UIImageView *slowAnimationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 95, 86, 193)];
    slowAnimationImageView.animationImages = images;
    slowAnimationImageView.animationDuration = 5;
    
    [self.view addSubview:slowAnimationImageView];
    [slowAnimationImageView startAnimating];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

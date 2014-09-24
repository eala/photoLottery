//
//  awardView.m
//  photoLottery
//
//  Created by Hank  on 2014/9/22.
//  Copyright (c) 2014年 eala. All rights reserved.
//

#import "awardView.h"
@interface awardView ()

@end

@implementation awardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImageView *imageView = [[UIImageView alloc]initWithImage:self.showImage];
    //[imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
    
    UIImageView *imageBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlayHeartShape.png"]];
    [imageBg setContentMode:UIViewContentModeScaleToFill];
    imageBg.frame = self.bounds;
    [self addSubview:imageBg];
    
    [UIView animateWithDuration:0.2f delay:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.f;
        //self.alpha = 0.5f;
        //self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
    
    
    UIButton *dismissButton = [[UIButton alloc] init];
    float offset = 16;
    float buttonW = 128;
    float buttonH = 64;
    dismissButton.frame = CGRectMake(offset, self.bounds.size.height -buttonH , buttonW, buttonH);
    [dismissButton setBackgroundImage:[UIImage imageNamed:@"start_button.png"] forState:UIControlStateNormal];
    [dismissButton setTitle:@"Start" forState:UIControlStateNormal];
    
    [dismissButton addTarget:self
                      action:@selector(dismiss:)
            forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setTitle:@"返回" forState:UIControlStateNormal];
    [self addSubview:dismissButton];
    

}

-(void)dismiss:(UIButton *)button
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.1f;
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

@end

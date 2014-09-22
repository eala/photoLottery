//
//  awardView.m
//  photoLottery
//
//  Created by Hank  on 2014/9/22.
//  Copyright (c) 2014年 eala. All rights reserved.
//

#import "awardView.h"

@implementation awardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor greenColor];
        self.alpha = 0.5f;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIButton *dismissButton = [[UIButton alloc] init];
    dismissButton.frame = CGRectMake(0, 50, 100, 100);
    
    [dismissButton addTarget:self
                      action:@selector(dismiss:)
            forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setTitle:@"Back to Roll" forState:UIControlStateNormal];
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

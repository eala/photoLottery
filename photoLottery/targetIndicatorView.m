//
//  targetIndicatorView.m
//  photoLottery
//
//  Created by Hank  on 2014/9/18.
//  Copyright (c) 2014年 eala. All rights reserved.
//

#import "targetIndicatorView.h"

@implementation targetIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self.layer setBorderColor:[[UIColor redColor] CGColor]];
    [self.layer setBorderWidth:10.0];
    [self.layer setCornerRadius:10.0f];
    [self.layer setMasksToBounds:YES];
    [self.layer setBackgroundColor: (__bridge CGColorRef)([UIColor clearColor])];
}

@end

//
//  RandomPickerViewController.h
//  photoLottery
//
//  Created by Hank  on 2014/9/18.
//  Copyright (c) 2014年 eala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "targetIndicatorView.h"

@interface RandomPickerViewController : UIViewController
@property (strong, nonatomic) targetIndicatorView *indicatorView;
@property (nonatomic) NSMutableArray *selectedImages;
- (IBAction)startRandom:(id)sender;
@end

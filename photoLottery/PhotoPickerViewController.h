//
//  PhotoPickerViewController.h
//  photoLottery
//
//  Created by Hank  on 2014/8/16.
//  Copyright (c) 2014年 eala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"

@interface PhotoPickerViewController : UIViewController <UINavigationControllerDelegate, ELCImagePickerControllerDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@end

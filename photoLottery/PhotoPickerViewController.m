//
//  PhotoPickerViewController.m
//  photoLottery
//
//  Created by Hank  on 2014/8/16.
//  Copyright (c) 2014年 eala. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

#import "RandomPickerViewController.h"

@interface PhotoPickerViewController ()

@property (nonatomic) NSMutableArray *selectedImages;
@property (nonatomic) ELCImagePickerController *imagePickerController;
@end

@implementation PhotoPickerViewController

- (NSMutableArray *)selectedImages
{
    if (!_selectedImages) {
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
}

- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{

    if (self.selectedImages.count > 0)
    {
        [self.selectedImages removeAllObjects];
    }
    
    ELCImagePickerController *imagePickerController = [[ELCImagePickerController alloc] initImagePicker];
    //imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    //imagePickerController.sourceType = sourceType;
    //imagePickerController.delegate = self;
    //imagePickerController.showsCameraControls = YES;
    imagePickerController.maximumImagesCount = 12;
    imagePickerController.returnsOriginalImage = NO;
    imagePickerController.returnsImage = YES;
    imagePickerController.onOrder = YES;
    imagePickerController.imagePickerDelegate = self;
    
    // present modally
    [self presentViewController:imagePickerController animated:YES completion:nil];

#if 0
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
    }
#endif
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
	
    for (UIView *v in [_scrollView subviews]) {
        [v removeFromSuperview];
    }
    
    _scrollView.frame = CGRectMake(20, 20, 128, 128);
	CGRect workingFrame = _scrollView.frame;
	workingFrame.origin.x = 0;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
	for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                EYLargePhoto *photo = [[EYLargePhoto alloc] init];
                photo.thumb = [dict objectForKey:UIImagePickerControllerOriginalImage];
                UIImage* image=photo.thumb;
                [images addObject:image];
                
                UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                [imageview setContentMode:UIViewContentModeScaleAspectFit];
                imageview.frame = workingFrame;
                
                [_scrollView addSubview:imageview];
                
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                EYLargePhoto *photo = [[EYLargePhoto alloc] init];
                photo.thumb = [dict objectForKey:UIImagePickerControllerOriginalImage];
                UIImage* image=photo.thumb;
                [images addObject:image];
                
                UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                [imageview setContentMode:UIViewContentModeScaleAspectFit];
                imageview.frame = workingFrame;
                
                [_scrollView addSubview:imageview];
                
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    
    self.selectedImages = images;
	
	[_scrollView setPagingEnabled:YES];
	[_scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"SEGUE_TO_GAME_SCREEN"])
    {
        // Get reference to the destination view controller
        RandomPickerViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setSelectedImages:self.selectedImages];
    }
}


@end

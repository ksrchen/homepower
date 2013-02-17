//
//  DetailViewController.h
//  homepwner
//
//  Created by Kevin Chen on 1/6/13.
//  Copyright (c) 2013 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;
@interface DetailViewController : UIViewController<UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
{
    
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    
    
    __weak IBOutlet UITextField *valueField;

    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
    
    __weak IBOutlet UIButton *assetTypeButton;
    UIPopoverController * imagePickerPopover;
}

@property  (nonatomic, strong) BNRItem* item;
- (IBAction)backgroupTapped:(id)sender;

- (IBAction)takePicture:(id)sender;
-(id)initForNewItem:(BOOL)isNew;
- (IBAction)showAssetTypePicker:(id)sender;

@property (nonatomic, copy) void (^dismissBlock)(void);

@end

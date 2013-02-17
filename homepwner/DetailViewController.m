//
//  DetailViewController.m
//  homepwner
//
//  Created by Kevin Chen on 1/6/13.
//  Copyright (c) 2013 Kevin Chen. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "AssetTypePickerViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize item;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor * clr = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        clr = [UIColor colorWithRed:0.875 green:0.888 blue:0.91 alpha:1];
    }
    else
    {
        clr = [UIColor groupTableViewBackgroundColor];
    }
    [self.view setBackgroundColor:clr];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate * date = [NSDate dateWithTimeIntervalSinceReferenceDate:item.dateCreated];

    [dateLabel setText:[dateFormatter stringFromDate:date]];
    
    NSString* imageKey = item.imageKey;
    if (imageKey)
    {
        UIImage* image = [[BNRImageStore sharedStore] imageForKey:imageKey];
        [imageView setImage:image];
    }
    else
    {
        [imageView setImage:nil];
    }
    
    NSString * assetTypeLabel = [[item assetType] valueForKey:@"label"];
    if (!assetTypeLabel)
    {
        assetTypeLabel = @"None";
    }
[assetTypeButton setTitle:assetTypeLabel forState:UIControlStateNormal];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];
    
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text] intValue]];
}

-(void) setItem:(BNRItem *)i
{
    item = i;
    self.navigationItem.title = self.item.itemName;
}

- (IBAction)backgroupTapped:(id)sender {
    [[self view] endEditing:YES];
    
}

- (IBAction)takePicture:(id)sender
{
    if ([imagePickerPopover isPopoverVisible]) {
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    // If our device has a camera, we want to take a picture, otherwise, we
    // just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [imagePickerPopover setDelegate:self];
        [imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }else
    {
        // Place image picker on the screen
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString* oldKey = [item imageKey];
    if (oldKey)
    {
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [item setThumbnailDataForImage:image];
    
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    NSString * key = (__bridge NSString*)newUniqueIDString;
    [item setImageKey:key];
    
    [[BNRImageStore sharedStore]setImage:image forKey:[item imageKey]];
    
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    [imageView setImage:image];
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (io == UIInterfaceOrientationPortrait);
    }
}
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    imagePickerPopover = nil;
}
-(id)initForNewItem:(BOOL)isNew{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if (self){
        if (isNew){
            UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem * cancellItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            
            [[self navigationItem] setLeftBarButtonItem:cancellItem ];
        
        }
    }
    return self;
}

- (IBAction)showAssetTypePicker:(id)sender
{
    [[self view] endEditing:YES];
    AssetTypePickerViewController *asseTypePicker = [[AssetTypePickerViewController alloc] init];
    [asseTypePicker setItem:item];
    [[self navigationController] pushViewController:asseTypePicker animated:YES];
    
    
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    @throw [[NSException alloc] initWithName:@"wrong initializer" reason:@"Use initForNewItem instaed" userInfo:nil];
    return nil;
}
-(void)save:(id) sender{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:[self dismissBlock]];
    
}
-(void)cancel:(id) sender {
    [[BNRItemStore sharedStore] removeItem: item];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];    
}
@end

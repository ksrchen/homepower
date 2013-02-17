//
//  AssetTypePickerViewController.h
//  homepwner
//
//  Created by Kevin Chen on 2/10/13.
//  Copyright (c) 2013 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface AssetTypePickerViewController : UITableViewController

@property (nonatomic, strong) BNRItem * item;
@end

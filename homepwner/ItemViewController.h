//
//  ItemViewController.h
//  homepwner
//
//  Created by Kevin Chen on 12/30/12.
//  Copyright (c) 2012 Kevin Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageViewController.h"

@interface ItemViewController : UITableViewController<UIPopoverControllerDelegate>   {
    IBOutlet UIView * headerView;
    UIPopoverController * imagePopover;
}
-(IBAction)addNewItem:(id)sender;

@end

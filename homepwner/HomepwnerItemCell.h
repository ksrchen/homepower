//
//  HomepwnerItemCell.h
//  homepwner
//
//  Created by Kevin Chen on 1/21/13.
//  Copyright (c) 2013 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomepwnerItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;

@property (weak, nonatomic) id controller;
@property (weak, nonatomic) UITableView *tableView2;

- (IBAction)showImage:(id)sender;

@end

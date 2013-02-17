//
//  HomepwnerItemCell.m
//  homepwner
//
//  Created by Kevin Chen on 1/21/13.
//  Copyright (c) 2013 Kevin Chen. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showImage:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView2 indexPathForCell:self];
    
    NSString * selector = NSStringFromSelector(_cmd);
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    SEL newSelector = NSSelectorFromString(selector);
    if (indexPath) {
        if ([[self controller] respondsToSelector:newSelector]) {
                [[self controller] performSelector:newSelector withObject:sender withObject:indexPath];
        }
    }
    
}
@end

//
//  ItemViewController.m
//  homepwner
//
//  Created by Kevin Chen on 12/30/12.
//  Copyright (c) 2012 Kevin Chen. All rights reserved.
//

#import "ItemViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "DetailViewController.h"
#import "HomepwnerItemCell.h"
#import "BNRImageStore.h"

@implementation ItemViewController

-(id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self){
        //for (int i=0; i<5; i++) {
          //  [[BNRItemStore sharedStore] createItem];
        //}
        [[self navigationItem] setTitle:@"Homepwner"];
        
        UIBarButtonItem * bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

-(id)initWithStyle:(UITableViewStyle)style{
    return [self init];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UINib * nib = [UINib nibWithNibName:@"HomepwnerItem" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"HomepwnerItem"];
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[BNRItemStore sharedStore] allItems] count];
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomepwnerItemCell  *cell =
    [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItem"];
    
    
    BNRItem * item = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    
    cell.serialNumberLabel.text = item.serialNumber;
    cell.nameLabel.text = item.itemName;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars ];
    cell.imageView.image = item.thumbnail;
    cell.tableView2 = [self tableView];
    cell.controller = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath      {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BNRItem  * item = [[[BNRItemStore sharedStore] allItems] objectAtIndex:indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath     {
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

-(void)addNewItem:(id)sender{
    BNRItem * item = [[BNRItemStore sharedStore] createItem];
    
    /*int index = [[[BNRItemStore sharedStore] allItems] indexOfObject:item];
    
    NSIndexPath * ip = [NSIndexPath indexPathForRow:index inSection:0];
    
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
    */
    
    DetailViewController * detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    [detailViewController setItem:item ];
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    [navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navigationController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:navigationController animated:YES completion:nil];
        
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController * detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    BNRItem * selectedItem = [[[BNRItemStore sharedStore] allItems] objectAtIndex:indexPath.row];
    
    [detailViewController setItem:selectedItem];
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (io == UIInterfaceOrientationPortrait);
    }
}

- (void)showImage:(id)sender atIndexPath:(NSIndexPath *)ip
{
    NSLog(@"Going to show the image for %@", ip);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Get the item for the index path
        BNRItem *i = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[ip row]];
        NSString *imageKey = [i imageKey];
        // If there is no image, we don't need to display anything
        UIImage *img = [[BNRImageStore sharedStore] imageForKey:imageKey];
        if (!img)
            return;
        // Make a rectangle that the frame of the button relative to
        // our table view
        CGRect rect = [[self view] convertRect:[sender bounds] fromView:sender];
        // Create a new ImageViewController and set its image
        ImageViewController *ivc = [[ImageViewController alloc] init];
        [ivc setImage:img];
        // Present a 600x600 popover from the rect
        imagePopover = [[UIPopoverController alloc]
                        initWithContentViewController:ivc];
        [imagePopover setDelegate:self];
        [imagePopover setPopoverContentSize:CGSizeMake(600, 600)];
        [imagePopover presentPopoverFromRect:rect
                                      inView:[self view]
                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                    animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [imagePopover dismissPopoverAnimated:YES];
    imagePopover = nil;
}
@end

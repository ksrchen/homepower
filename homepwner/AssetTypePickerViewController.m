//
//  AssetTypePickerViewController.m
//  homepwner
//
//  Created by Kevin Chen on 2/10/13.
//  Copyright (c) 2013 Kevin Chen. All rights reserved.
//

#import "AssetTypePickerViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@interface AssetTypePickerViewController ()

@end

@implementation AssetTypePickerViewController
-(id) init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}
-(id) initWithStyle:(UITableViewStyle)style
{
    return [self init];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allAssetTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] init];
    }
    
    NSArray * allAssetTypes = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject * assetType = [allAssetTypes objectAtIndex:[indexPath row]];
    
    [cell.textLabel setText:[assetType valueForKey:@"label"]];
     
    if (assetType == [[self item] assetType])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    NSArray *allAssetTypes = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assertType = [allAssetTypes objectAtIndex:[indexPath row]];
    [[self item] setAssetType:assertType];
    
    [[self navigationController] popViewControllerAnimated:YES];
    
}

@end

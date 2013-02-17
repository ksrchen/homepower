//
//  ImageViewController.m
//  homepwner
//
//  Created by Kevin Chen on 1/21/13.
//  Copyright (c) 2013 Kevin Chen. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGSize sz = [[self image] size];
    [_scrollView setContentSize:sz];
    [_imageView setFrame:CGRectMake(0, 0, sz.width, sz.height)];
    [_imageView setImage:[self image]];
    
}

@end

//
//  ImageViewController.h
//  homepwner
//
//  Created by Kevin Chen on 1/21/13.
//  Copyright (c) 2013 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage * image;
@end

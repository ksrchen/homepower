//
//  BNRItem.m
//  homepwner
//
//  Created by Kevin Chen on 2/3/13.
//  Copyright (c) 2013 Kevin Chen. All rights reserved.
//

#import "BNRItem.h"


@implementation BNRItem

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic imageKey;
@dynamic thumbnailData;
@dynamic thumbnail;
@dynamic orderingValue;
@dynamic assetType;

-(UIImage*)thumbnail
{
    if (!self.thumbnailData){
        return nil;
    }else
    {
        if (!_thumbnail) {
            _thumbnail = [UIImage imageWithData:self.thumbnailData];
        }
    }
    return _thumbnail;
}
-(void)setThumbnailDataForImage:(UIImage *)image
{
    CGSize orginalImageSize = [image size];
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    float ratio = MAX(newRect.size.width/orginalImageSize.width, newRect.size.height/orginalImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * orginalImageSize.width;
    projectRect.size.height = ratio * orginalImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    UIImage * smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    NSData *data = UIImagePNGRepresentation(smallImage);
    
    UIImage *test = [UIImage imageWithData:data];
    CGSize size = [test size];
    
    [self setThumbnailData:data ];
    UIGraphicsEndImageContext();
    
}

-(void)awakeFromFetch
{
    [super awakeFromFetch];
    
    UIImage *tn = [UIImage imageWithData:self.thumbnailData  scale:1];
    
   
    
    [self setPrimitiveValue:tn forKey:@"thumbnail"];
}
-(void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setDateCreated:[[NSDate date] timeIntervalSinceReferenceDate]];
}

@end

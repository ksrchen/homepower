//
//  BNRImageStore.h
//  homepwner
//
//  Created by Kevin Chen on 1/6/13.
//  Copyright (c) 2013 Kevin Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject
{
    NSMutableDictionary * dictionary;
}
    
    + (BNRImageStore*) sharedStore;
    
    -(void)setImage:(UIImage*)i forKey:(NSString*)s;
    -(UIImage*)imageForKey:(NSString*)s;
    -(void)deleteImageForKey:(NSString*)s;

-(NSString*)imagePathForKey:(NSString*)key;

@end

//
//  BNRItemStore.h
//  homepwner
//
//  Created by Kevin Chen on 12/30/12.
//  Copyright (c) 2012 Kevin Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNRItem;

@interface BNRItemStore : NSObject{
    NSMutableArray * allItems;
    NSMutableArray *allAssetTypes;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

+ (BNRItemStore*) sharedStore;

-(NSArray*) allItems;
-(BNRItem*) createItem;
-(void) removeItem:(BNRItem*) item;
-(void) moveItemAtIndex:(int)from toIndex:(int)to;

-(NSString*) itemArchivePath;
-(BOOL) saveChanges;
-(NSArray*) allAssetTypes;
@end

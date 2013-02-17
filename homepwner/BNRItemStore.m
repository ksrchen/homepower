//
//  BNRItemStore.m
//  homepwner
//
//  Created by Kevin Chen on 12/30/12.
//  Copyright (c) 2012 Kevin Chen. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@implementation BNRItemStore

+(BNRItemStore*) sharedStore{
    static BNRItemStore * sharedStore = nil;
    if (!sharedStore){
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}
+(id)allocWithZone:(NSZone *)zone{
    return [self sharedStore];
}

-(id)init{
    self = [super init];
    if (self){
        //allItems = [[NSMutableArray alloc] init];
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSString *path = [self itemArchivePath];
        NSURL * storeUrl = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
            configuration:nil
            URL:storeUrl
            options:nil
            error:&error])
        {
            [NSException raise:@"open failed" format:@"Reason %@", [error localizedDescription] ];
        }
        
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        
        [context setUndoManager:nil];
        [self loadAllItems];
    }
    return self;
}

-(NSArray*) allItems{
    return allItems;
}

-(BNRItem*)createItem{
    double order;
    if ([allItems count] ==0)
    {
        order = 1;
    }
    else
    {
        order = [[allItems lastObject] orderingValue]+1;
    }
    BNRItem *p = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:context];
    [p setOrderingValue:order];
    
    [allItems addObject:p];
    return p;
}
-(void) removeItem:(BNRItem *)item{
    NSString*key = [item imageKey];
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    [context deleteObject:item];
    [allItems removeObjectIdenticalTo:item];
}
- (void)moveItemAtIndex:(int)from
                toIndex:(int)to
{
    if (from == to) {
        return; }
    // Get pointer to object being moved so we can re-insert it
    BNRItem *p = [allItems objectAtIndex:from];
    // Remove p from array
    [allItems removeObjectAtIndex:from];
    // Insert p in array at new location
    [allItems insertObject:p atIndex:to];
    
    // Computing a new orderValue for the object that was moved
    double lowerBound = 0.0;
    // Is there an object before it in the array?
    if (to > 0) {
        lowerBound = [[allItems objectAtIndex:to - 1] orderingValue];
    } else {
        lowerBound = [[allItems objectAtIndex:1] orderingValue] - 2.0;
    }
    double upperBound = 0.0;
    // Is there an object after it in the array?
    if (to < [allItems count] - 1) {
        upperBound = [[allItems objectAtIndex:to + 1] orderingValue];
    } else {
        upperBound = [[allItems objectAtIndex:to - 1] orderingValue] + 2.0;
    }
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    NSLog(@"moving to order %f", newOrderValue);
    [p setOrderingValue:newOrderValue];
    
}
-(NSString*) itemArchivePath
{
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"itemstore.data"];
}

-(BOOL)saveChanges
{
    NSError *err = nil;
    BOOL sucessful = [context save:&err];
    if (!sucessful)
    {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return sucessful;
}
-(void)loadAllItems
{
    if (!allItems)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        NSEntityDescription * e = [[model entitiesByName] objectForKey:@"BNRItem"];
        [request setEntity:e];
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result)
        {
            [NSException raise:@"Fetch failed" format:@"%@", error.localizedDescription];
        }
        allItems = [[NSMutableArray alloc] initWithArray:result];
    }
}
- (void)addAssetType: (NSString*) assetType
{
    NSManagedObject *type;
    type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:context];
    [type setValue:assetType forKey:@"label"];
    [allAssetTypes addObject:type];
}

-(NSArray*)allAssetTypes
{
    if (!allAssetTypes)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"BNRAssetType"];
        [request setEntity:e];
        
        NSError *error;
        NSArray* result = [context executeFetchRequest:request error:&error];
        if (!result)
        {
            [NSException raise:@"NSFetch failed" format:@"reason %@", [error localizedDescription]];
        }
        
        allAssetTypes = [result mutableCopy];
        
        if ([allAssetTypes count] <= 0)
        {
            [self addAssetType:@"Furniture"];
            [self addAssetType:@"Jewelry"];
            [self addAssetType:@"Electronic"];
            
        }
    }
    return allAssetTypes;
}
@end

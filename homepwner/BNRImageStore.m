//
//  BNRImageStore.m
//  homepwner
//
//  Created by Kevin Chen on 1/6/13.
//  Copyright (c) 2013 Kevin Chen. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore 

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}
+ (BNRImageStore *)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    if (!sharedStore) {
        // Create the singleton
        sharedStore = [[super allocWithZone:NULL] init];
    }
    return sharedStore;
}
- (id)init {
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:NULL];
        
    }
    return self;
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    NSString* imagePath = [self imagePathForKey:s];
    
    NSData* d = UIImageJPEGRepresentation(i, 0.5);
    [d writeToFile:imagePath atomically:YES];
    
}
- (UIImage *)imageForKey:(NSString *)s
{
    UIImage * result =  [dictionary objectForKey:s];
    if (!result)
    {
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        if (result)
        {
            [dictionary setObject:result forKey:s];
        }
        else
        {
            NSLog(@"unable to find %@", [self imagePathForKey:s]);
        }
    }
    return result;
}
- (void)deleteImageForKey:(NSString *)s
{
    if (!s)
        return;
    [dictionary removeObjectForKey:s];
    
    NSString * path = [self imagePathForKey:s];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

-(NSString*)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:key];
}

-(void)clearCache
{
    NSLog(@"flusing %lud images out of the cache",(unsigned long) [dictionary count]);
    [dictionary removeAllObjects];
}
@end

//
//  listController.m
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/30/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import "ListController.h"

@implementation ListController

+ (ListController*)sharedInstance {
    static ListController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ListController new];
    });
    
    return sharedInstance;
}

- (void)addListWithTitle:(NSString *)title {
    
    List *list = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    
    list.title = title;
    
    [self synchronize];
}

-(NSArray *)lists {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"List"];
    NSArray *lists = [[Stack sharedInstance].managedObjectContext executeFetchRequest:request error:NULL];
    return lists;
}

- (void)removeList:(List *)list {
    
    [list.managedObjectContext deleteObject:list];
    [self synchronize];
}

- (void)synchronize {
    [[Stack sharedInstance].managedObjectContext save:NULL];
    
}

@end

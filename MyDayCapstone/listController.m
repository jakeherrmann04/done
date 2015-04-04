//
//  listController.m
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/30/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import "listController.h"

@implementation listController

@synthesize list = _list;

+ (listController*)sharedInstance {
    static listController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [listController new];
    });
    
    return sharedInstance;
}

-(NSArray *)days{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"List"];
    NSArray *objects = [[Stack sharedInstance].managedObjectContext executeFetchRequest:request error:NULL];
    return objects;
}

- (void)addDayWithTitle:(NSString *)title {

    List *list = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    
    list.title = title;
    
    [self synchronize];
}

- (void)removeList:(List *)list {
    
    [list.managedObjectContext deleteObject:list];
    [self synchronize];
}

- (void)synchronize {
    [[Stack sharedInstance].managedObjectContext save:NULL];
    
}

-(void)updateWithList:(List *)list{
    _list = list;
}


//
//Sections
//

-(NSArray *)sections{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Segment"];
    NSArray *objects = [[Stack sharedInstance].managedObjectContext executeFetchRequest:request error:NULL];
    return objects;
}

-(void)addSegmentToList:(List *)list{
    
    NSArray *arrayOfSegments = [NSArray arrayWithArray:[list.segments array]];
    
    Segment *segment = [NSEntityDescription insertNewObjectForEntityForName:@"Segment" inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    
    arrayOfSegments = [arrayOfSegments arrayByAddingObject:segment];
    
    list.segments = [[NSOrderedSet alloc]initWithArray:arrayOfSegments];
    
    [self synchronize];
}

-(void)addEntryToSegment:(Segment *)segment{
    
    NSArray *arrayOfEntries = [NSArray arrayWithArray:[segment.entries array]];
    
    Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    
    arrayOfEntries = [arrayOfEntries arrayByAddingObject:entry];
    segment.entries = [[NSOrderedSet alloc]initWithArray:arrayOfEntries];
    
    [self synchronize];

}


@end

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



//WE DON'T WANT THIS HERE (below)

////
////Sections
////
//
//-(NSArray *)sections{
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Segment"];
//    NSArray *objects = [[Stack sharedInstance].managedObjectContext executeFetchRequest:request error:NULL];
//    return objects;
//}
//
//-(void)addSegmentToList:(List *)list withTitle:(NSString *)string{
//    
////    NSArray *arrayOfSegments = [NSArray arrayWithArray:[list.segments array]];
//    
//    Segment *segment = [NSEntityDescription insertNewObjectForEntityForName:@"Segment" inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
//    segment.title = string;
//    segment.list = list;
//    
////    arrayOfSegments = [arrayOfSegments arrayByAddingObject:segment];
////    list.segments = [[NSOrderedSet alloc]initWithArray:arrayOfSegments];
//    
//    [self synchronize];
//}
//
//- (void)removeSegment:(Segment *)segment {
//    
//    [segment.managedObjectContext deleteObject:segment];
//    [self synchronize];
//}
//
//-(void)addEntryToSegment:(Segment *)segment{
//    
////    NSArray *arrayOfEntries = [NSArray arrayWithArray:[segment.entries array]];
//    
//    Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
//
//    entry.segment = segment;
////    arrayOfEntries = [arrayOfEntries arrayByAddingObject:entry];
////    segment.entries = [[NSOrderedSet alloc]initWithArray:arrayOfEntries];
//    
//    [self synchronize];
//
//}
//-(void)addTitleToEntry:(Entry *)entry withTitle:(NSString *)title{
//    entry.title = title;
//    [self synchronize];
//}
//
//-(NSArray *)entries{
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
//    NSArray *objects = [[Stack sharedInstance].managedObjectContext executeFetchRequest:request error:NULL];
//    return objects;
//}

@end

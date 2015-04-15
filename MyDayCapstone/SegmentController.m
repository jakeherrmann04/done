//
//  SegmentController.m
//  MyDayCapstone
//
//  Created by Jake Herrmann on 4/10/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import "SegmentController.h"

@implementation SegmentController

+ (SegmentController *)sharedInstance {
    static SegmentController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [SegmentController new];
    });
    
    return sharedInstance;
}


-(void)addSegmentToList:(List *)list withTitle:(NSString *)string{

    Segment *segment = [NSEntityDescription insertNewObjectForEntityForName:@"Segment" inManagedObjectContext:[Stack sharedInstance].managedObjectContext];
    segment.title = string;
    segment.list = list;

    [self synchronize];
}


-(NSArray *)segments{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Segment"];
        NSArray *segments = [[Stack sharedInstance].managedObjectContext executeFetchRequest:request error:NULL];
        return segments;
    }

- (void)removeSegment:(Segment *)segment {

    [segment.managedObjectContext deleteObject:segment];
    [self synchronize];
}


-(void)addEntryToSegment:(Segment *)segment{

    Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:[Stack sharedInstance].managedObjectContext];

    entry.segment = segment;

    [self synchronize];

}

-(NSArray *)entries{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    NSArray *objects = [[Stack sharedInstance].managedObjectContext executeFetchRequest:request error:NULL];
    return objects;
}

-(void)removeEntry:(Entry *)entry{
    [entry.managedObjectContext deleteObject:entry];
    [self synchronize];
}


-(NSNumber *)findPercentageOfEntriesCompleted:(Segment *)segment{
  
    NSArray *entries = [NSArray arrayWithArray:segment.entries.array];
    NSNumber *checkSum = [entries valueForKeyPath:@"@sum.Check"];
    double percentage = checkSum.doubleValue/(double)entries.count;
    NSNumber *finalPercentage = [NSNumber numberWithDouble:percentage];
    return finalPercentage;
}

- (void)synchronize {
    [[Stack sharedInstance].managedObjectContext save:NULL];
    
}


@end

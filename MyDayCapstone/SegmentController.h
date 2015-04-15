//
//  SegmentController.h
//  MyDayCapstone
//
//  Created by Jake Herrmann on 4/10/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stack.h"
#import "Segment.h"
#import "List.h"
#import "Entry.h"

@interface SegmentController : NSObject

+ (SegmentController *)sharedInstance;

- (void)addSegmentToList:(List *)list withTitle:(NSString *)string;
- (NSArray *)segments;
- (void)removeSegment:(Segment *)segment;

- (void)addEntryToSegment:(Segment *)segment;
-(void)removeEntry:(Entry *)entry;
- (NSArray *)entries;
- (void)synchronize;

-(NSNumber *)findPercentageOfEntriesCompleted:(Segment *)segment;

@end

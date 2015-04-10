//
//  listController.h
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/30/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"
#import "Entry.h"
#import "Segment.h"

@interface ListController : NSObject

@property (nonatomic, strong) List *list;

+ (ListController*)sharedInstance;

- (NSArray *)days;
- (void)addDayWithTitle:(NSString *)title;
- (void)removeList:(List *)list;

- (void)updateWithList:(List *)list;
- (NSArray *)sections;
- (void)addSegmentToList:(List *)list withTitle:(NSString *)string;
- (void)addEntryToSegment:(Segment *)segment;
- (void)removeSegment:(Segment *)segment;

- (void)addTitleToEntry:(Entry *)entry withTitle:(NSString *)title;
- (NSArray *)entries;



@end

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

@interface listController : NSObject

@property (nonatomic, strong)List *list;

+ (listController*)sharedInstance;

- (NSArray *)days;
- (void)addDayWithTitle:(NSString *)title;
- (void)removeList:(List *)list;

- (void)updateWithList:(List *)list;
- (NSArray *)sections;
- (void)addSegmentToList:(List *)list;
- (void)addEntryToSegment:(Segment *)segment;

@end

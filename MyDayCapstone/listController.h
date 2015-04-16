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
#import "Stack.h"

@interface ListController : NSObject

+ (ListController*)sharedInstance;

- (void)addListWithTitle:(NSString *)title; //C
- (NSArray *)lists;                         //R
//NOT NEEDED                                //U
- (void)removeList:(List *)list;            //D
- (void)synchronize;

//// OLD

//- (NSArray *)sections;
//- (void)addSegmentToList:(List *)list withTitle:(NSString *)string;
//- (void)addEntryToSegment:(Segment *)segment;
//- (void)removeSegment:(Segment *)segment;
//
//- (void)addTitleToEntry:(Entry *)entry withTitle:(NSString *)title;
//- (NSArray *)entries;



@end

//
//  Entry.h
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/30/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Segment;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, assign) Boolean check;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) Segment *segment;

@end

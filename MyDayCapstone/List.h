//
//  List.h
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/30/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Stack.h"


@interface List : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * percentage;
@property (nonatomic, retain) NSOrderedSet *segments;
@end

@interface List (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inSegmentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSegmentsAtIndex:(NSUInteger)idx;
- (void)insertSegments:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSegmentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSegmentsAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceSegmentsAtIndexes:(NSIndexSet *)indexes withSegments:(NSArray *)values;
- (void)addSegmentsObject:(NSManagedObject *)value;
- (void)removeSegmentsObject:(NSManagedObject *)value;
- (void)addSegments:(NSOrderedSet *)values;
- (void)removeSegments:(NSOrderedSet *)values;
@end

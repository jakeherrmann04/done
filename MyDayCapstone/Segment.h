//
//  Segment.h
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/30/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class List;

@interface Segment : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * percentage;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSOrderedSet *entries;
@property (nonatomic, retain) List *list;
@end

@interface Segment (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inEntriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromEntriesAtIndex:(NSUInteger)idx;
- (void)insertEntries:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeEntriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInEntriesAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceEntriesAtIndexes:(NSIndexSet *)indexes withEntries:(NSArray *)values;
- (void)addEntriesObject:(NSManagedObject *)value;
- (void)removeEntriesObject:(NSManagedObject *)value;
- (void)addEntries:(NSOrderedSet *)values;
- (void)removeEntries:(NSOrderedSet *)values;
@end

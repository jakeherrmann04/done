//
//  List.h
//  
//
//  Created by Jake Herrmann on 4/15/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Segment;

@interface List : NSManagedObject

@property (nonatomic, retain) NSNumber * percentage;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *segments;
@end

@interface List (CoreDataGeneratedAccessors)

- (void)insertObject:(Segment *)value inSegmentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSegmentsAtIndex:(NSUInteger)idx;
- (void)insertSegments:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSegmentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSegmentsAtIndex:(NSUInteger)idx withObject:(Segment *)value;
- (void)replaceSegmentsAtIndexes:(NSIndexSet *)indexes withSegments:(NSArray *)values;
- (void)addSegmentsObject:(Segment *)value;
- (void)removeSegmentsObject:(Segment *)value;
- (void)addSegments:(NSOrderedSet *)values;
- (void)removeSegments:(NSOrderedSet *)values;
@end

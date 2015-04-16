//
//  Entry.h
//  
//
//  Created by Jake Herrmann on 4/15/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Segment;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSNumber * check;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Segment *segment;

@end

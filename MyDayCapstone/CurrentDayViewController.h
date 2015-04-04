//
//  CurrentDayViewController.h
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/24/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"
#import "Segment.h"
#import "Entry.h"


@interface CurrentDayViewController : UIViewController <UITableViewDataSource>


@property (nonatomic, strong)NSMutableIndexSet *expandedSections;
@property (nonatomic, strong)List* list;

@end

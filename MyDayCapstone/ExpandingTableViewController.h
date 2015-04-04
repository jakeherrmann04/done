//
//  ExpandingTableViewController.h
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/31/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVTableView.h"

@interface ExpandingTableViewController : UIViewController <HVTableViewDelegate, HVTableViewDataSource>

@property NSArray *cellTitles;


@end

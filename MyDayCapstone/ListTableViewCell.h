//
//  ListTableViewCell.h
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/27/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeCustomCell.h"

@interface ListTableViewCell : SWTableViewCell <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;

@end

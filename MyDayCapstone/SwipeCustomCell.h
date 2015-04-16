//
//  SwipeCustomCell.h
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/25/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import "SWTableViewCell.h"

@interface SwipeCustomCell : SWTableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

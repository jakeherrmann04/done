//
//  DetailTaskTableViewCell.h
//  MyDayCapstone
//
//  Created by Jake Herrmann on 4/7/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListController.h"
#import <Foundation/Foundation.h>


@protocol TableViewCellTextFieldDelegate

- (void)textFieldFinishedEditing:(id)sender;
- (void)checkBoxWasChecked:(id)sender;

@end

@interface DetailTaskTableViewCell : UITableViewCell <UITextFieldDelegate>

@property(nonatomic, weak) id <TableViewCellTextFieldDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UITextField *taskTextField;
@property (nonatomic, assign) int section;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) NSInteger *checkNumber;
@property (nonatomic, assign) UIImage *buttonImage;




@end

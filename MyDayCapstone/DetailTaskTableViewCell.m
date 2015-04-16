//
//  DetailTaskTableViewCell.m
//  MyDayCapstone
//
//  Created by Jake Herrmann on 4/7/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import "DetailTaskTableViewCell.h"
#import "Segment.h"
#import "Entry.h"


@interface DetailTaskTableViewCell ()

@end

@implementation DetailTaskTableViewCell
- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    
    self.taskTextField.delegate = self;

    return self;
}

- (void)awakeFromNib
{

    self.checkButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.checkButton.layer.borderWidth = 1;
    self.checkButton.layer.cornerRadius = self.checkButton.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    
//}

- (IBAction)weFinishedEditing:(UITextField *)sender {
    [self.delegate textFieldFinishedEditing:self];
}

- (IBAction)checkButtonTapped:(id)sender {
    [self.delegate checkBoxWasChecked:self];
    
}

@end

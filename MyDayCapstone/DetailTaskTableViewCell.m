//
//  DetailTaskTableViewCell.m
//  MyDayCapstone
//
//  Created by Jake Herrmann on 4/7/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import "DetailTaskTableViewCell.h"

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
    
    [self.checkButton setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [self.checkButton setImage:[UIImage imageNamed:@"circleCheck"] forState:UIControlStateSelected];
    
    self.checkButton.selected = !self.checkButton.selected;
    NSInteger *checkedNumber = 0;

    if (self.checkButton.selected) {
        NSLog(@"Checked");
        checkedNumber = 1;
    }else if (!self.checkButton.selected){
        NSLog(@"Unchecked");
        checkedNumber = 0;
    }
    
}

@end

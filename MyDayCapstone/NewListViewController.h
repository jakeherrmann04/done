//
//  NewListViewController.h
//  MyDayCapstone
//
//  Created by Jake Herrmann on 4/20/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"

@interface NewListViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (nonatomic, strong) List *list;

@property (nonatomic, assign) BOOL isList;

-(void)animateNewListViewOn;


@end

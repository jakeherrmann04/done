//
//  AddFIneViewController.m
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/31/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import "AddFIneViewController.h"
#import "listController.h"

@interface AddFIneViewController ()

@end

@implementation AddFIneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addTitleButtonTapped:(id)sender {
    [[listController sharedInstance]addDayWithTitle:self.textField.text];
    [self performSegueWithIdentifier:@"titleAdded" sender:nil];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

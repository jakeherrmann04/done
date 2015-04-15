//
//  ListViewController.m
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/27/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "CurrentDayViewController.h"
#import "List.h"
#import "ListController.h"

static NSString *listCell = @"listCell";

@interface ListViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Register the TableView with Cell Identifier
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:listCell];
    
    //Create a UIBarButtonITem and add to Nav Bar
    UIBarButtonItem *addListButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addList)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationItem setRightBarButtonItem:addListButton];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Bar Button Method
//When the plus button is tapped create have an alert appear with message
-(void)addList {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Title" message:@"Please enter title below." preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Title";
    }];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add Title" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = [[alertController textFields]firstObject];
        [[ListController sharedInstance] addListWithTitle:textField.text];
        [self.tableView reloadData];
        //[self performSegueWithIdentifier:@"listTappedSegue" sender:nil];
        
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - TableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ListController sharedInstance].lists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell forIndexPath:indexPath];
    List *list = [ListController sharedInstance].lists[indexPath.row];
    cell.textLabel.text = list.title;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:0.000 green:0.424 blue:0.475 alpha:1];
    [cell.textLabel setFont: [UIFont fontWithName:@"Arial" size:20]];

    return cell;
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"listTappedSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        [[ListController sharedInstance]removeList:[ListController sharedInstance].lists[indexPath.row]];
        [tableView reloadData]; // tell table to refresh now
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"listTappedSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        CurrentDayViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.list = [ListController sharedInstance].lists[indexPath.row];
    }
}


@end

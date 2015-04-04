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
#import "listController.h"


@interface ListViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCell"];
    UIBarButtonItem *addDay = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDay)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationItem setRightBarButtonItem:addDay];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    List *list = [listController sharedInstance].days[indexPath.row];
    cell.textLabel.text = list.title;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:0.000 green:0.424 blue:0.475 alpha:1];
    [cell.textLabel setFont: [UIFont fontWithName:@"Arial" size:20]];

    return cell;
    
}

-(void)addDay{
    [self performSegueWithIdentifier:@"addDay" sender:nil];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listController sharedInstance].days.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[listController sharedInstance]updateWithList:[listController sharedInstance].days[indexPath.row]];
    [self performSegueWithIdentifier:@"daySegue" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        [[listController sharedInstance]removeList:[listController sharedInstance].days[indexPath.row]];
        [tableView reloadData]; // tell table to refresh now
    }
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    ListTableViewCell *cell = sender;
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    CurrentDayViewController *viewController = segue.destinationViewController;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

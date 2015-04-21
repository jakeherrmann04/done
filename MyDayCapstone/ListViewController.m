//
//  ListViewController.m
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/27/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import <SWTableViewCell.h>
#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "CurrentDayViewController.h"
#import "List.h"
#import "ListController.h"
#import "NewListViewController.h"
#import <pop/POP.h>

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
    UIBarButtonItem *addListButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addList:)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationItem setRightBarButtonItem:addListButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newListReload) name:@"listReload" object:nil];
  
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

-(void)newListReload{
    [self.tableView reloadData];
}

#pragma mark - Bar Button Method
//When the plus button is tapped create have an alert appear with message
-(void)addList:(id)sender {

    NewListViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"addList"];
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    viewController.view.alpha = 0.0;
    viewController.isList = YES;

    [viewController animateNewListViewOn];
       
}
#pragma mark - TableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ListController sharedInstance].lists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainList"];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;

    List *list = [ListController sharedInstance].lists[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.cellTitle.text = list.title;
    [cell.textLabel setFont: [UIFont fontWithName:@"Arial" size:20]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"listTappedSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    NSLog(@"Delete");
    [[ListController sharedInstance]removeList:[ListController sharedInstance].lists[path.row]];
    [self.tableView reloadData];
    
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"listTappedSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        CurrentDayViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.list = [ListController sharedInstance].lists[indexPath.row];
    }
    if ([[segue identifier]isEqualToString:@"addListSegue"]) {

    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:0.0f]
                                                 icon:[UIImage imageNamed:@"delete"]];
    
    return rightUtilityButtons;
}



@end

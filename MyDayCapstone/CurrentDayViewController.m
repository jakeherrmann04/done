//
//  CurrentDayViewController.m
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/24/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//
#import <SWTableViewCell.h>
#import "CurrentDayViewController.h"
#import "SwipeCustomCell.h"
#import "listController.h"

@interface CurrentDayViewController () <SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CurrentDayViewController
-(void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [listController sharedInstance].list.title;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCell"];
    UIBarButtonItem *addDay = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSection)];
    [self.navigationItem setRightBarButtonItem:addDay];

    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    if (!self.expandedSections)
    {
        self.expandedSections = [[NSMutableIndexSet alloc] init];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

-(void)addSection{
    [[listController sharedInstance]addSegmentToList:[listController sharedInstance].list];
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
//    if (section>0) return YES;
    
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [listController sharedInstance].list.segments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([self.expandedSections containsIndex:section])
        {
            Segment *seg = [listController sharedInstance].list.segments[section];
            return seg.entries.count + 1;
        }
        
        return 1; // only top row showing
    }
    
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"customCell";
    
    SwipeCustomCell *cell = (SwipeCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.leftUtilityButtons = [self leftButtons];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            if ([self.expandedSections containsIndex:indexPath.section])
            {
                cell.textLabel.text = @"School";
                cell.textLabel.textColor = [UIColor colorWithRed:0.976 green:0.922 blue:0.855 alpha:1];
                cell.backgroundColor = [UIColor colorWithRed:0.745 green:0.388 blue:0.329 alpha:1];
                         }
            else
            {
                cell.textLabel.text = @"School";
                cell.textLabel.textColor = [UIColor colorWithRed:0.976 green:0.922 blue:0.855 alpha:1];
                
                cell.backgroundColor = [UIColor colorWithRed:0.745 green:0.388 blue:0.329 alpha:1];
            }
        }
        else
        {
            cell.textLabel.text = @"quiz 14";
            cell.accessoryView = nil;
            cell.backgroundColor = [UIColor colorWithRed:0.800 green:0.588 blue:0.306 alpha:1];

        }
    }
    else
    {
        [cell setHidden:NO];
        cell.accessoryView = nil;
      //  cell.textLabel.text = @"MyDay";
        
    }
    
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"add.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
//    [leftUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
//                                                icon:[UIImage imageNamed:@"time.png"]];
//    [leftUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
//                                                icon:[UIImage imageNamed:@"edit.png"]];
    
    return leftUtilityButtons;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [self.expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [self.expandedSections removeIndex:section];
                
            }
            else
            {
                [self.expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded)
            {
                
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                cell.backgroundColor = [UIColor colorWithRed:0.745 green:0.388 blue:0.329 alpha:1];

            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                cell.backgroundColor = [UIColor colorWithRed:0.745 green:0.388 blue:0.329 alpha:1];
                
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  //  NSInteger section = indexPath.section;
    if([self.expandedSections containsIndex:indexPath.section])
    {
        return 50;
    }
    else
    {
        return 100;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    Segment *seg = [listController sharedInstance].list.segments[path.section];

    switch (index) {
        case 0:
            [[listController sharedInstance] addEntryToSegment:seg];
            NSLog(@"check button was pressed");
            break;
        case 1:
            NSLog(@"clock button was pressed");
            break;
        case 2:
            NSLog(@"cross button was pressed");
            
            break;
        case 3:
            NSLog(@"list button was pressed");
        default:
            break;
    }
}

-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state{
    return YES;
}


@end
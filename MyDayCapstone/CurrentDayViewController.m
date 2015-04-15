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
#import "ListController.h"
#import "DetailTaskTableViewCell.h"
#import "SegmentController.h"

static NSString *listCellID = @"listCellID";

static NSString *cellIdentifier = @"customCell";
static NSString *detailCellIdentifier = @"detailCell";

@interface CurrentDayViewController () <SWTableViewCellDelegate, UITextFieldDelegate, TableViewCellTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL checkEntry;
@end

@implementation CurrentDayViewController
-(void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.list.title;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:listCellID];
    UIBarButtonItem *addSectionButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSection)];
    [self.navigationItem setRightBarButtonItem:addSectionButton];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Loading"];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(handleLongPress:)];
    
    longPress.minimumPressDuration = 1.5; //seconds
    [self.tableView addGestureRecognizer:longPress];
    
    if (!self.expandedSections)
    {
        self.expandedSections = [[NSMutableIndexSet alloc] init];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];

    DetailTaskTableViewCell *currentCell  = (DetailTaskTableViewCell*)indexPath;
    Segment *segment = self.list.segments[currentCell.section];
    Entry *entry = segment.entries[currentCell.row -1];
    
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", (long)indexPath.row);
        [[SegmentController sharedInstance]removeEntry:entry];
        [self.tableView reloadData];
    } else {
        NSLog(@"gestureRecognizer.state = %ld", (long)gestureRecognizer.state);
    }
}


#pragma mark - Custom Cell delagate methods

-(void)textFieldFinishedEditing:(id)sender{
    
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    DetailTaskTableViewCell *currentCell = (DetailTaskTableViewCell*)sender;
    
    //We need to get the entry/segments
    Segment *segment = self.list.segments[currentCell.section];

    Entry *entry = segment.entries[currentCell.row - 1];
    entry.title = [sender taskTextField].text;
    bool checkEntry = [entry.check boolValue];
    
    [[ListController sharedInstance] synchronize];
}

- (void)checkBoxWasChecked:(id)sender{
    
    DetailTaskTableViewCell *currentCell = (DetailTaskTableViewCell*)sender;
    [currentCell.checkButton setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [currentCell.checkButton setImage:[UIImage imageNamed:@"circleCheck"] forState:UIControlStateSelected];
    
    currentCell.checkButton.selected = !currentCell.checkButton.selected;
    Segment *segment = self.list.segments[currentCell.section];
    Entry *entry = segment.entries[currentCell.row -1];
    entry.check = [self.checkEntry];
    if (currentCell.checkButton.isSelected) {
        NSNumber *checkNumber = [NSNumber numberWithInt:1];
        entry.check = checkNumber;
        NSLog(@"Checked");
        [self.tableView reloadData];
    }else if (!currentCell.checkButton.isSelected){
        NSNumber *checkNumber = [NSNumber numberWithInt:0];
        entry.check = checkNumber;
        NSLog(@"Unchecked");
        [self.tableView reloadData];
    }
    [[ListController sharedInstance] synchronize];

}

- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

#pragma mark - adding segment methods

-(void)addSection{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Section title" message:@"Please enter title below." preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Section";
    }];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Add Section" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = [[alertController textFields]firstObject];
        
        [[SegmentController sharedInstance] addSegmentToList:self.list withTitle:textField.text];
        
        [self.tableView reloadData];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];

    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.list.segments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([self.expandedSections containsIndex:section])
        {
            Segment *seg = self.list.segments[section];
            return seg.entries.count + 1;
        }
        
        return 1; // only top row showing
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell * cell;
    DetailTaskTableViewCell *detailCell;
    SwipeCustomCell *swipeCell;
    
    swipeCell.delegate = self;
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            if ([self.expandedSections containsIndex:indexPath.section])
            {
                swipeCell = [[SwipeCustomCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
                //swipeCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                swipeCell.leftUtilityButtons = [self leftButtons];
                swipeCell.rightUtilityButtons = [self rightButtons];
                swipeCell.delegate = self;

                Segment *segment = self.list.segments[indexPath.section];
                NSString* title = segment.title;
                NSNumber *percentage = [[SegmentController sharedInstance]findPercentageOfEntriesCompleted:segment];
                NSString *percentageString = percentage.stringValue;
                swipeCell.detailTextLabel.text = percentageString;
//                UILabel *percentageLabel = [UILabel new];
//                percentageLabel.text = percentageString;
//                swipeCell.editingAccessoryView = percentageLabel;
                swipeCell.textLabel.text = title;
                swipeCell.textLabel.textColor = [UIColor colorWithRed:0.976 green:0.922 blue:0.855 alpha:1];
                swipeCell.backgroundColor = [UIColor colorWithRed:0.745 green:0.388 blue:0.329 alpha:percentage.floatValue];
                
                cell = swipeCell;
                
            }
            else
            {
                swipeCell = [[SwipeCustomCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
             //   swipeCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                swipeCell.leftUtilityButtons = [self leftButtons];
                swipeCell.rightUtilityButtons = [self rightButtons];
                swipeCell.delegate = self;

                Segment *segment = self.list.segments[indexPath.section];
                NSString* title = segment.title;
                NSNumber *percentage = [[SegmentController sharedInstance]findPercentageOfEntriesCompleted:segment];
                NSString *percentageString = percentage.stringValue;
                swipeCell.detailTextLabel.text = percentageString;
//                UILabel *percentageLabel = [UILabel new];
//                percentageLabel.text = percentageString;
//                swipeCell.editingAccessoryView = percentageLabel;
                swipeCell.textLabel.text = title;
                swipeCell.textLabel.textColor = [UIColor colorWithRed:0.976 green:0.922 blue:0.855 alpha:1];
                swipeCell.backgroundColor = [UIColor colorWithRed:0.745 green:0.388 blue:0.329 alpha:percentage.floatValue];
                cell = swipeCell;
            }
        }
        else
        {
            
            detailCell = [tableView dequeueReusableCellWithIdentifier:detailCellIdentifier forIndexPath:indexPath];
            detailCell.delegate = self;
            detailCell.section = (int)indexPath.section;
            detailCell.row = (int)indexPath.row;
            detailCell.accessoryView = nil;
            detailCell.backgroundColor = [UIColor colorWithRed:0.800 green:0.588 blue:0.306 alpha:1];
            Segment *segment = self.list.segments[indexPath.section];
            Entry *entry = segment.entries[indexPath.row - 1];
            detailCell.taskTextField.text = entry.title;
            

            cell = detailCell;

        }
    }
 
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.980 green:0.537 blue:0.502 alpha:1]
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
    [UIColor colorWithRed:1.000 green:0.208 blue:0.263 alpha:1]
                                                icon:[UIImage imageNamed:@"add.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.725 green:0.129 blue:0.310 alpha:1]
                                                icon:[UIImage imageNamed:@"check.png"]];
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
                
                //cell.backgroundColor = [UIColor colorWithRed:0.745 green:0.388 blue:0.329 alpha:1];

            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                //cell.backgroundColor = [UIColor colorWithRed:0.745 green:0.388 blue:0.329 alpha:1];
                
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.expandedSections containsIndex:indexPath.section])
    {
        return 43;
    }
    else
    {
        return 100;
    }
}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];

    switch (index) {
        case 0:
            NSLog(@"More");
            break;
        default:
            case 1:
            NSLog(@"Delete");
            [[SegmentController sharedInstance] removeSegment:self.list.segments[path.section]];
            [self.tableView reloadData];
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    Segment *segment = self.list.segments[path.section];

    switch (index) {
        case 0:
            [[SegmentController sharedInstance] addEntryToSegment:segment];
            
            NSLog(@"check button was pressed");
            break;
        case 1:
            NSLog(@"clock button was pressed");
            break;
    }
}

-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];

    if([self.expandedSections containsIndex:path.section]){
        return NO;
    }
    else{
        return YES;
    }

}

@end
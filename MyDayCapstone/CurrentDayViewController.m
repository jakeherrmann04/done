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
#import "NewSegmentViewController.h"
#import "SegmentController.h"
#import "NewListViewController.h"

static NSString *listCellID = @"listCellID";

static NSString *cellIdentifier = @"customCell";
static NSString *detailCellIdentifier = @"detailCell";

@interface CurrentDayViewController () <SWTableViewCellDelegate, UITextFieldDelegate, TableViewCellTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL checkEntry;
@property (nonatomic) CGPoint originalCenter;
@property (nonatomic, assign) BOOL deleteOnDragRelease;

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
//    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(handleLongPress:)];
    
    longPress.minimumPressDuration = 1.5; //seconds
    [self.tableView addGestureRecognizer:longPress];
    
    if (!self.expandedSections)
    {
        self.expandedSections = [[NSMutableIndexSet alloc] init];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newListReload) name:@"segmentListReload" object:nil];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
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
    
    [[ListController sharedInstance] synchronize];
}

- (void)checkBoxWasChecked:(id)sender{
    
    DetailTaskTableViewCell *currentCell = (DetailTaskTableViewCell*)sender;
    
    currentCell.checkButton.selected = !currentCell.checkButton.selected;
    
    Segment *segment = self.list.segments[currentCell.section];
    Entry *entry = segment.entries[currentCell.row -1];
    if (currentCell.checkButton.isSelected) {
        NSNumber *checkNumber = [NSNumber numberWithInt:1];
        entry.check = checkNumber;
        currentCell.checkButton.backgroundColor = [UIColor whiteColor];
        [self.tableView reloadData];
    }else if (!currentCell.checkButton.isSelected){
        NSNumber *checkNumber = [NSNumber numberWithInt:0];
        entry.check = checkNumber;
        currentCell.checkButton.backgroundColor = [UIColor clearColor];
        [self.tableView reloadData];
    }
    [[ListController sharedInstance] synchronize];

}

#pragma mark - adding segment methods

-(void)addSection{
    
    NewListViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"addList"];
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    viewController.view.alpha = 0.0;
    viewController.list = self.list;
    viewController.isList = NO;
    [viewController animateNewListViewOn];
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Section title" message:@"Please enter title below." preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"Section";
//    }];
//    
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Add Section" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        UITextField *textField = [[alertController textFields]firstObject];
//        
//        [[SegmentController sharedInstance] addSegmentToList:self.list withTitle:textField.text];
//        
//        [self.tableView reloadData];
//    }]];
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
//    [self presentViewController:alertController animated:YES completion:nil];
//
//    [self.tableView reloadData];
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
                cell = [self setUpCellWithTableView:tableView andCell:swipeCell withIndexPath:indexPath];
            }
            else
            {
                cell = [self setUpCellWithTableView:tableView andCell:swipeCell withIndexPath:indexPath];
            }
        }
        else
        {
            
           
            detailCell = [tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
            
            UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
            
            [detailCell addGestureRecognizer:recognizer];

            
            detailCell.delegate = self;
            detailCell.section = (int)indexPath.section;
            detailCell.row = (int)indexPath.row;
            detailCell.accessoryView = nil;
            Segment *segment = self.list.segments[indexPath.section];
            Entry *entry = segment.entries[indexPath.row - 1];
            detailCell.taskTextField.text = entry.title;
            if([entry.check isEqualToNumber:@1]){
                detailCell.checkButton.backgroundColor = [UIColor whiteColor];
            }else{
                detailCell.checkButton.backgroundColor = [UIColor clearColor];
            }

            cell = detailCell;

        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    return cell;
}

- (void)swipeLeft:(UIPanGestureRecognizer *)recognizer {
    DetailTaskTableViewCell *cell = (DetailTaskTableViewCell *)recognizer.view;
    Segment *segment = self.list.segments[cell.section];
    Entry *entry = segment.entries[cell.row -1];

    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // if the gesture has just started, record the current centre location

        self.originalCenter = cell.center;
    }
    
    // 2
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        // translate the center
        CGPoint translation = [recognizer translationInView:cell];
         cell.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        // determine whether the item has been dragged far enough to initiate a delete / complete
        self.deleteOnDragRelease = cell.frame.origin.x < -cell.frame.size.width / 2;
        
    }
    
    // 3
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // the frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, cell.frame.origin.y,
                                          cell.bounds.size.width, cell.bounds.size.height);
        if (!self.deleteOnDragRelease) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 cell.frame = originalFrame;
                                 NSLog(@"HERE");
                                 [[SegmentController sharedInstance]removeEntry:entry];
                                 [self.tableView reloadData];
                             }
             ];
        }
    }
}

- (SwipeCustomCell*) setUpCellWithTableView:(UITableView*)tableView andCell:(SwipeCustomCell*)swipeCell withIndexPath:(NSIndexPath*)indexPath {

    swipeCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    swipeCell.leftUtilityButtons = [self leftButtons];
    swipeCell.rightUtilityButtons = [self rightButtons];
    swipeCell.delegate = self;
    
    Segment *segment = self.list.segments[indexPath.section];
    
    swipeCell.percentageWidthConstraint.constant = (swipeCell.innerView.bounds.size.width * [[SegmentController sharedInstance]findPercentageOfEntriesCompleted:segment].floatValue);
    
       [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    
        [self.view layoutIfNeeded];
    
       } completion:^(BOOL finished) {
        
    
       }];
    
//    swipeCell.percentageLabel.text = [NSString stringWithFormat:@"%%%.0f", [[SegmentController sharedInstance]findPercentageOfEntriesCompleted:segment].floatValue];

    swipeCell.titleLabel.text = segment.title;

    return swipeCell;

}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
   
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:0.0f]
                                                icon:[UIImage imageNamed:@"delete"]];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
    [UIColor colorWithRed:1.000 green:0.208 blue:0.263 alpha:0]
                                                icon:[UIImage imageNamed:@"plus"]];
    
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
            
            if (currentlyExpanded)
            {
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                [tableView endUpdates];

            }
            else
            {
                [tableView beginUpdates];
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                [tableView endUpdates];

            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.expandedSections containsIndex:indexPath.section])
    {
        return 65;
    }
    else
    {
        return 80;
    }
}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];

    NSLog(@"Delete");
    [[SegmentController sharedInstance] removeSegment:self.list.segments[path.section]];
    [self.tableView reloadData];
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    Segment *segment = self.list.segments[path.section];
    
    [[SegmentController sharedInstance] addEntryToSegment:segment];
    
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

-(void)newListReload {
    [self.tableView reloadData];
}

@end
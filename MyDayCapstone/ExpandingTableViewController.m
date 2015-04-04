//
//  ExpandingTableViewController.m
//  MyDayCapstone
//
//  Created by Jake Herrmann on 3/31/15.
//  Copyright (c) 2015 Jake Herrmann. All rights reserved.
//

#import "ExpandingTableViewController.h"
#import "HVTableView.h"


@interface ExpandingTableViewController ()

@property (weak, nonatomic) IBOutlet HVTableView *hvtableview;
@property (nonatomic, strong) NSString *cellIdentifier;


@end

@implementation ExpandingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hvtableview.HVTableViewDelegate = self;
    self.hvtableview.HVTableViewDataSource = self;
    
    self.cellTitles = @[@"Twitowie", @"Bill Greyskull", @"Moonglampers", @"Psit", @"Duncan WJ Palmer", @"Sajuma", @"Victor_lee", @"Jugger-naut", @"Javiersanagustin", @"Velouria!"];

}
-(void)tableView:(UITableView *)tableView expandCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
   cell.textLabel.text = @"Jake";
    
}

//perform your collapse stuff (may include animation) for cell here. It will be called when the user touches an expanded cell so it gets collapsed or the table is in the expandOnlyOneCell satate and the user touches another item, So the last expanded item has to collapse
-(void)tableView:(UITableView *)tableView collapseCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = @"Chase";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isexpanded
{
    //you can define different heights for each cell. (then you probably have to calculate the height or e.g. read pre-calculated heights from an array
    if (isexpanded)
        return 200;
    
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded
{
    self.cellIdentifier = @"expandCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    //alternative background colors for better division ;)
    if (indexPath.row %2 ==1){
        cell.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    }
    else{
        cell.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1];
    }
    cell.textLabel.text = [self.cellTitles objectAtIndex:indexPath.row % 10];
   // NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
  //  NSString* imageFileName = [NSString stringWithFormat:@"%ld.jpg", indexPath.row % 10 + 1];
//imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", bundlePath, imageFileName]];
    
    if (!isExpanded) //prepare the cell as if it was collapsed! (without any animation!)
    {
       cell.detailTextLabel.text = @"Lorem ipsum dolor sit amet";
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(0);
    }
    else ///prepare the cell as if it was expanded! (without any animation!)
    {
        cell.detailTextLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(3.14);
    }
    return cell;
}

@end
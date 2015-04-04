
#import "HVTableView.h"

@implementation HVTableView
@synthesize HVTableViewDelegate, HVTableViewDataSource;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.delegate = self;
        self.dataSource = self;
        expandedIndexPaths = [NSMutableArray new];
    }
    return self;
}


//////// IMPORTANT!!!!!!!!!!!!!!!!!!!!!
//////// UITableViewDataSource Protocol Forwarding
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [HVTableViewDataSource tableView:tableView numberOfRowsInSection:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [HVTableViewDataSource numberOfSectionsInTableView:tableView];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([HVTableViewDataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)])
        return [HVTableViewDataSource tableView:tableView titleForHeaderInSection:section];
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{	if ([HVTableViewDataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)])
    return [HVTableViewDataSource tableView:tableView titleForFooterInSection:section];
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{	if ([HVTableViewDataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
    return [HVTableViewDataSource tableView:tableView canEditRowAtIndexPath:indexPath];
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([HVTableViewDataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)])
        return [HVTableViewDataSource tableView:tableView canMoveRowAtIndexPath:indexPath];
    return NO;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([HVTableViewDataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)])
        return [HVTableViewDataSource sectionIndexTitlesForTableView:tableView];
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([HVTableViewDataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)])
        return [HVTableViewDataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([HVTableViewDataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
        return [HVTableViewDataSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if ([HVTableViewDataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)])
        return [HVTableViewDataSource tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"expandCell"];
    
    if (self.expandOnlyOneCell)
    {
        if (actionToTake == 0) // e.g. the first time or an expanded cell from before gets in to view
        {
            if (selectedIndexPath)
                if (selectedIndexPath.row == indexPath.row && selectedIndexPath.section == indexPath.section)
                {
                    cell = [HVTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:YES];//i want it expanded
                    return cell;
                }
            
            cell = [HVTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:NO];
            
            return cell; //it's already collapsed!
        }
        
        cell = [HVTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:NO];
        
        if(actionToTake == -1)
        {
            [HVTableViewDataSource tableView:tableView collapseCell:cell withIndexPath:indexPath];
            actionToTake = 0;
        }
        else
        {
            [HVTableViewDataSource tableView:tableView expandCell:cell withIndexPath:indexPath];
            actionToTake = 0;
        }
    }
    else
    {
        if (actionToTake == 0) // e.g. the first time or an expanded cell from before gets in to view
        {
            BOOL alreadyExpanded = NO;
            NSIndexPath* correspondingIndexPath;
            for (NSIndexPath* anIndexPath in expandedIndexPaths) {
                if (anIndexPath.row == indexPath.row && anIndexPath.section == indexPath.section)
                {alreadyExpanded = YES; correspondingIndexPath = anIndexPath;}
            }
            
            if (alreadyExpanded)
                cell = [HVTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:YES];
            else
                cell = [HVTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:NO];
            
            return cell; //it's already collapsed!
            
        }
        
        cell = [HVTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath isExpanded:NO];
        
        if(actionToTake == -1)
        {
            [HVTableViewDataSource tableView:tableView collapseCell:cell withIndexPath:indexPath];
            actionToTake = 0;
        }
        else
        {
            [HVTableViewDataSource tableView:tableView expandCell:cell withIndexPath:indexPath];
            actionToTake = 0;
        }
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.expandOnlyOneCell)
    {
        if (selectedIndexPath)
            if(selectedIndexPath.row == indexPath.row && selectedIndexPath.section == indexPath.section)
                return [HVTableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath isExpanded:YES];
        
        return [HVTableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath isExpanded:NO];
    }
    else
    {
        BOOL alreadyExpanded = NO;
        NSIndexPath* correspondingIndexPath;
        for (NSIndexPath* anIndexPath in expandedIndexPaths) {
            if (anIndexPath.row == indexPath.row && anIndexPath.section == indexPath.section)
            {alreadyExpanded = YES; correspondingIndexPath = anIndexPath;}
        }
        if (alreadyExpanded)
            return [HVTableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath isExpanded:YES];
        else
            return [HVTableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath isExpanded:NO];
    }
}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.expandOnlyOneCell)
    {
        if (selectedIndexPath)
            if (selectedIndexPath.row != -1 && selectedIndexPath.row != -2) //collapse the last expanded item (if any)
            {
                BOOL dontExpandNewCell = NO;
                if (selectedIndexPath.row == indexPath.row && selectedIndexPath.section == indexPath.section)
                    dontExpandNewCell = YES;
                
                NSIndexPath* tmp = [NSIndexPath indexPathForRow:selectedIndexPath.row inSection:selectedIndexPath.section];//tmp now holds the last expanded item
                selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
                
                actionToTake = -1;
                
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tmp] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
                
                if (dontExpandNewCell) return; //the same expanded cell was touched and now I collapsed it. No new cell is touched
            }
        
        actionToTake = 1;
        ///expand the new touched item
        
        selectedIndexPath = indexPath;
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        if (self.enableAutoScroll)
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    }
    else
    {
        BOOL alreadyExpanded = NO;
        NSIndexPath* correspondingIndexPath;
        for (NSIndexPath* anIndexPath in expandedIndexPaths) {
            if (anIndexPath.row == indexPath.row && anIndexPath.section == indexPath.section)
            {alreadyExpanded = YES; correspondingIndexPath = anIndexPath;}
        }
        
        if (alreadyExpanded)////collapse it!
        {
            actionToTake = -1;
            [expandedIndexPaths removeObject:correspondingIndexPath];
            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
        }
        else ///expand it!
        {
            actionToTake = 1;
            [expandedIndexPaths addObject:indexPath];
            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
            if (self.enableAutoScroll)
                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
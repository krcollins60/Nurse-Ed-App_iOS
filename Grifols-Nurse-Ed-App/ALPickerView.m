//
//  ALPickerView.m
//
//  Created by Alex Leutgöb on 11.11.11.
//  Copyright 2011 alexleutgoeb.com. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ALPickerView.h"
#import "ALPickerViewCell.h"
#import "GNAppDelegate.h"

@implementation ALPickerView

@synthesize pickerViewDelegate = _pickerViewDelegate;


#pragma mark - NSObject stuff

- (id)init
{
    return [GNAppDelegate isIpad] ? [self initWithFrame:CGRectMake(0, 0, 320, 216)] : [self initWithFrame:CGRectMake(0, 0, 768, 216)];
}

- (id)initWithFrame:(CGRect)frame
{
    float width = [GNAppDelegate isIpad] ? 768 : 320;
        
	if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, width, 216)]))
    {
        [self setBackgroundColor:[UIColor blackColor]];
        [self setClipsToBounds:YES];
    
        internalTableView_ = [[UITableView alloc] initWithFrame:CGRectMake(10, -2, (width-20), 218) style:UITableViewStylePlain];
        [internalTableView_ setDelegate:self];
        [internalTableView_ setDataSource:self];
        [internalTableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [internalTableView_ setShowsVerticalScrollIndicator:NO];
        [internalTableView_ setScrollsToTop:NO];
        UIImage *backgroundImage = [[UIImage imageNamed:@"wheel_bg"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    
        [internalTableView_ setBackgroundView:[[UIImageView alloc] initWithImage:backgroundImage]];
        [self addSubview:internalTableView_];
    
        UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wheel_shadow"]];
        [shadow setFrame:[internalTableView_ frame]];
        [self addSubview:shadow];
    
        UIImageView *leftBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_left"]];
        [leftBorder setFrame:CGRectMake(0, 0, 15, 216)];
        [self addSubview:leftBorder];
        UIImageView *rightBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_right"]];
        [rightBorder setFrame:CGRectMake(self.frame.size.width - 15, 0, 15, 216)];
        [self addSubview:rightBorder];
        UIImageView *middleBorder = [[UIImageView alloc] initWithImage:
                                        [[UIImage imageNamed:@"frame_middle"]
                                        stretchableImageWithLeftCapWidth:0 topCapHeight:10]];
        [middleBorder setFrame:CGRectMake(15, 0, self.frame.size.width - 30, 216)];
        [self addSubview:middleBorder];
    }
    return self;
}


#pragma mark - Custom methods

- (void)reloadAllComponents {
    [internalTableView_ reloadData];
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_pickerViewDelegate numberOfRowsForPickerView:self] ? [_pickerViewDelegate numberOfRowsForPickerView:self] + 4 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ALPVCell";
    
    ALPickerViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ALPickerViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    if ([indexPath row] < 2 || [indexPath row] >= ([_pickerViewDelegate numberOfRowsForPickerView:self] + 2))
    {
        [[cell textLabel] setText:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else {
        int actualRow = [indexPath row] - 2;
        [[cell textLabel] setText:[_pickerViewDelegate pickerView:self textForRow:actualRow]];
        [cell setSelectionState:[_pickerViewDelegate pickerView:self selectionStateForRow:actualRow]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 1 && indexPath.row < ([_pickerViewDelegate numberOfRowsForPickerView:self] + 2))
    {
        ALPickerViewCell *cell = (ALPickerViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selectionState = !cell.selectionState;
        int actualRow = [indexPath row] - 2;
        
        if ([cell selectionState] != NO && [_pickerViewDelegate respondsToSelector:@selector(pickerView:didCheckRow:)])
        {
            [_pickerViewDelegate pickerView:self didCheckRow:actualRow];
        }
        else if ([_pickerViewDelegate respondsToSelector:@selector(pickerView:didUncheckRow:)])
        {
            [_pickerViewDelegate pickerView:self didUncheckRow:actualRow];
        }
        
        for (ALPickerViewCell *aCell in tableView.visibleCells)
        {
            int iterateRow = [tableView indexPathForCell:aCell].row - 2;
            if (iterateRow >= 0 && iterateRow < [_pickerViewDelegate numberOfRowsForPickerView:self])
            {
                if (iterateRow == actualRow) {
                    continue;
                }
                [aCell setSelectionState:[_pickerViewDelegate pickerView:self selectionStateForRow:iterateRow]];
            }
        }
        
        [tableView setContentOffset:CGPointMake(0, [tableView rowHeight] * ([indexPath row] - 2)) animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ScrollView

- (void)scrollViewDidEndDecelerating:(UITableView *)tableView
{
    int co = ((int)[tableView contentOffset].y % (int)[tableView rowHeight]);
    if (co < tableView.rowHeight / 2) {
        [tableView setContentOffset:CGPointMake(0, [tableView contentOffset].y - co) animated:YES];
    } else {
        [tableView setContentOffset:CGPointMake(0, [tableView contentOffset].y + ([tableView rowHeight] - co)) animated:YES];
    }
}


- (void)scrollViewDidEndDragging:(UITableView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

@end

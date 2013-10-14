//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Jessica Tai on 10/13/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "HistoryViewController.h"
#import "CardGameViewController.h"
#import "CardGameHistoryEntry.h"

@interface HistoryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation HistoryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void) updateUI
{
    NSMutableAttributedString *newHistoryText = [[NSMutableAttributedString alloc] initWithAttributedString:self.historyTextView.attributedText];
    // print each attributed string of (mis)match descriptions to the UI text field
    for (NSMutableAttributedString *entry in self.historyEntries) {
        [newHistoryText appendAttributedString:entry];
        [newHistoryText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
    }
    self.historyTextView.attributedText = newHistoryText;
}

@end

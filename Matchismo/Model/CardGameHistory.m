//
//  CardGameHistory.m
//  Matchismo
//
//  Created by Jessica Tai on 10/13/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameHistory.h"

@implementation CardGameHistory


- (NSMutableArray *) entries {
    if (!_entries) _entries = [[NSMutableArray alloc] init];
    return _entries;
}

-(void) addEntry: (CardGameHistoryEntry *) entry
{
    [self.entries addObject:entry];
}

-(void) addEntryWithCard:(NSMutableArray *) cards withPoints:(int) points
{
    CardGameHistoryEntry *entry = [[CardGameHistoryEntry alloc] initWithCards:cards usingPoints:points];
    [self.entries addObject:entry];
    NSLog(@"adding new entry, count %d", [self.entries count]);
}

@end

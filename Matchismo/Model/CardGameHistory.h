//
//  CardGameHistory.h
//  Matchismo
//
//  Created by Jessica Tai on 10/13/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardGameHistoryEntry.h"

@interface CardGameHistory : NSObject

@property (nonatomic, strong) NSMutableArray *entries;


-(void) addEntry: (CardGameHistoryEntry *) entry;

-(void) addEntryWithCard:(NSMutableArray *) cards withPoints:(int) points;

@end

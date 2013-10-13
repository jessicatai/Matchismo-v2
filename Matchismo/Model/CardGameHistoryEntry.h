//
//  CardGameHistoryEntry.h
//  Matchismo
//
//  Created by Jessica Tai on 10/13/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardGameHistoryEntry : NSObject

@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic) NSInteger points;

- (instancetype)initWithCards:(NSMutableArray *)cards usingPoints:(int)points;

@end

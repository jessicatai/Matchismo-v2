//
//  PlayingCard.h
//  Matchismo
//
//  Created by Jessica Tai on 9/26/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic, getter=isFaceUp) BOOL faceUp;
@property (nonatomic, getter=isUnplayable) BOOL unplayable;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;
@end

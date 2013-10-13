//
//  SetViewController.m
//  Matchismo
//
//  Created by Jessica Tai on 10/12/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetViewController.h"
#import "SetCard.h"
#import "SetCardDeck.h"

@interface SetViewController ()

@end

@implementation SetViewController

@synthesize game = _game;

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    // set is always played with 3 cards
    _game.numCardsInMatch = 3;
    return _game;
}

- (Deck *)createDeck
{
    NSLog(@"set - in deck");
    return [[SetCardDeck alloc] init];
}

- (NSAttributedString *)titleForCard:(SetCard *) card
{
    UIColor *color = [self getStrokeColor: card.color];
    UIColor *shadingColor = [self getShadingColor:color withShading:card.shading];
    NSString *shapeText = [self getCardTextWithShape:card.shape];
    NSDictionary *attrsDictionary =@{NSForegroundColorAttributeName: shadingColor,
                                     NSStrokeWidthAttributeName : @-5,
                                     NSStrokeColorAttributeName : color};
    NSAttributedString *attrString = [[NSAttributedString alloc]
                                      initWithString: [self getCardText:shapeText withCount:card.count]
                                      attributes:attrsDictionary];
    return attrString;
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed: card.isChosen && !card.isMatched? @"cardoutline" : @"cardfront"];
}


- (UIColor *) getStrokeColor:(NSString *) color {
    NSDictionary *colors = @{ @"green" : [UIColor greenColor],
                                @"blue" : [UIColor blueColor],
                                @"red" : [UIColor redColor] };
    return colors[color];}

- (UIColor *) getShadingColor:(UIColor *) color withShading:(NSString *)shading{
    NSDictionary *colors = @{ @"solid" : @1,
                              @"striped" : @0.25,
                              @"blank" : @0};
    return [color colorWithAlphaComponent:[colors[shading] floatValue]];
}

- (NSMutableString *) getCardText:(NSString *)shapeText
                   withCount:(NSUInteger) count {
    NSMutableString *text = [NSMutableString string];
    for (NSUInteger i = 0; i < count; i++){
        [text appendString:shapeText];
    }
    return text;
}

- (NSString *) getCardTextWithShape:(NSString *)shape
{
    NSDictionary *shapes = @{ @"triangle" : @"▲",
                              @"circle" : @"●",
                              @"square" : @"■" };
    return shapes[shape];
}

@end

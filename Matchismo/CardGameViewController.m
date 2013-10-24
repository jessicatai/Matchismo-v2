//
//  CardGameViewController.m
//  Matchismo
//  abstract class
//
//  Created by Jessica Tai on 9/26/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameViewController.h"
#import "HistoryViewController.h"

@interface CardGameViewController ()
@property (nonatomic, strong) NSMutableAttributedString *attributedDescription;
@end

@implementation CardGameViewController

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.startingCardCount;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

-(void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card {
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    // initialize game without waiting for user input
    [self updateUI];
}

- (CardMatchingGame *)game
{
    return nil;
}

// abstract method
-(CardMatchingGame *) createGame
{
    return nil;
}

// abstract method
- (Deck *)createDeck
{
    return nil;
}

- (NSMutableAttributedString *) attributedDescription
{
    if (!_attributedDescription) _attributedDescription = [[NSMutableAttributedString alloc] init];
    return _attributedDescription;
}
- (IBAction)touchCard:(UITapGestureRecognizer *)sender {
    CGPoint tapLocation = [sender locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    if (indexPath) {
        [self.game chooseCardAtIndex:indexPath.item];
        [self updateUI];
    }
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    // Users may switch difficulty in the middle of the game
    // index 0 = match 2 cards, index 1 = match 3 cards
    self.game.numCardsInMatch = [self.game getPointsForKey:@"difficulty" withDefaultValue:0] + 2;
    
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)touchRestartButton:(UIButton *)sender
{
    // reset game deck
    self.game = nil;
    [self.game.chosenCards removeAllObjects];
    
    // reset the score label to 0
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    [self updateUI];
}



- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }    
  
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

// NSNotFound implies not a (mis)match action
- (NSString *) setDescriptionTextForPoints:(int) points {
    return points == NSNotFound ? @"" : [NSString stringWithFormat:@"%1$@ for %2$d points.", points > 0 ? @"Match" : @"Penalty, mismatched",points];
}

// abstract
- (NSAttributedString *)titleForCard:(Card *) card
{
    return nil;
}

// abstract
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return nil;
}

// abstract
- (NSAttributedString *)getTextForCard:(Card *) card
{
    return nil;
}

@end

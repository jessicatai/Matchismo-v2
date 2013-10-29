//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by Jessica Tai on 10/19/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@interface PlayingCardViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@property (strong, nonatomic) Deck *deck;
@end

@implementation PlayingCardViewController

- (NSUInteger) startingCardCount
{
    return 30;
}

- (NSUInteger) numCardsInMatch
{
    return 2;
}


- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)drawRandomPlayingCard
{
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        self.playingCardView.rank = playingCard.rank;
        self.playingCardView.suit = playingCard.suit;
    }
}

- (UIView *)createCardViewWithFrame:(CGRect)frame usingCard:(Card*) card{
    return[[PlayingCardView alloc] initWithFrame:frame];
}

- (void) updateCardWithView:(UIView *)view usingCard:(Card*)card {
    if ([view isKindOfClass:[PlayingCardView class]] && [card isKindOfClass:[PlayingCard class]]) {
        PlayingCardView *playingCardView = (PlayingCardView *)view;
        PlayingCard *playingCard = (PlayingCard *)card;
        playingCardView.rank = playingCard.rank;
        playingCardView.suit = playingCard.suit;
        playingCardView.faceUp = playingCard.isChosen;
        playingCardView.alpha = playingCard.isMatched ? 0.3 : 1.0;
        // TODO: allow clicking on already matched cards?
    }
}

- (void) animateTouchCardAction:(UIView *)view {
    if ([view isKindOfClass:[PlayingCardView class]]) {
        PlayingCardView *pvc = (PlayingCardView *) view;
        [UIView transitionWithView:pvc
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            pvc.faceUp= !pvc.faceUp;
                        }completion: NULL];

    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

@end

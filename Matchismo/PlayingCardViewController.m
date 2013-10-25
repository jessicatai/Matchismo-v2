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

@synthesize game = _game;

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
        _game.points = NSNotFound;
        _game.numCardsInMatch = 2;
    }
    
    return _game;
}

- (NSUInteger) startingCardCount
{
    return 30;
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
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    NSLog(@"in swipe");
    [UIView transitionWithView:self.playingCardView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.playingCardView.faceUp = !self.playingCardView.faceUp;
                    }completion: NULL];
}

// flip the playing card over upon tap gesture
- (void) animateTouchCardAction:(UICollectionViewCell *)cell {
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]){
        PlayingCardCollectionViewCell *playingCardCell = (PlayingCardCollectionViewCell *) cell;
    
        [UIView transitionWithView:playingCardCell.playingCardView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            playingCardCell.playingCardView.faceUp= !playingCardCell.playingCardView.faceUp;
                        }completion: NULL];
        }
    }


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.playingCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.playingCardView action:@selector(pinch:)]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}


-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card {
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isChosen;
            playingCardView.alpha = playingCard.isMatched ? 0.3 : 1.0;
        }
    }
}


@end

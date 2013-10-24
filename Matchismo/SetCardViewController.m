//
//  SetCardViewController.m
//  Matchismo
//
//  Created by Jessica Tai on 10/22/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetCardViewController.h"
#import "SetCardView.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"

@interface SetCardViewController ()
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;
@property (strong, nonatomic) Deck *deck;
@end

@implementation SetCardViewController

@synthesize game = _game;

- (CardMatchingGame *)game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
        _game.points = NSNotFound;
        // set is always played with 3 cards
        _game.numCardsInMatch = 3;
    }
    return _game;
}

- (NSUInteger) startingCardCount
{
    return 12;
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)drawRandomSetCard
{
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[SetCard class]]) {
         SetCard *setCard = (SetCard *)card;
        self.setCardView.color = setCard.color;
        self.setCardView.shape = setCard.shape;
        self.setCardView.shading = setCard.shading;
        self.setCardView.count = setCard.count;
    }
}
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    NSLog(@"set swipe gestured recognized");
    [self drawRandomSetCard];
}
- (IBAction)touchAddCardsButton:(UIButton *)sender {
    [self.game addCards:self.game.numCardsInMatch];
    [self.cardCollectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self drawRandomSetCard];
    [self.setCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.setCardView action:@selector(pinch:)]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SetCard" forIndexPath:indexPath];
    
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}


-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card {
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            setCardView.color = setCard.color;
            setCardView.shape = setCard.shape;
            setCardView.shading = setCard.shading;
            setCardView.count = setCard.count;
            setCardView.chosen = setCard.chosen;
            if (setCard.isMatched) {
                NSUInteger index = [self.cardCollectionView indexPathForCell:cell].item;
                [self.game removeCardAtIndex:index];
                [self.cardCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
            }
        }
    }
}


@end

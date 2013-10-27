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
#import "Grid.h"


@interface CardGameViewController ()
@property (nonatomic, strong) NSMutableAttributedString *attributedDescription;
// UI
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardsLabel;

@property (nonatomic) Grid *grid;
@property (nonatomic) NSUInteger difficulty;
@property (nonatomic) NSUInteger startingCardCount;

@property (nonatomic) CGFloat pinchScale;

@property (strong, nonatomic) NSMutableArray *attachments;
@property (nonatomic) bool isInPinchedState;

@end

@implementation CardGameViewController

#pragma mark Properties

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return _animator;
}

- (Grid *) grid {
    if (!_grid) {
        _grid = [[Grid alloc] init];
        _grid.size = self.gameView.bounds.size; //self.gameView.frame.size;
        _grid.cellAspectRatio = 2.0/3.0;
        _grid.minimumNumberOfCells = self.currentCardCount;
    }
    return _grid;
}

- (NSMutableArray *) attachments {
    if (!_attachments) {_attachments = [[NSMutableArray alloc] init]; }
    return _attachments;
}

#define DEFAULT_PINCH_SCALE 0.9
- (CGFloat) pinchScale {
    if (!_pinchScale) { _pinchScale = DEFAULT_PINCH_SCALE; }
    return _pinchScale;
}

// abstract method
- (CardMatchingGame *)game
{
    return nil;
}

// abstract method
- (Deck *)createDeck
{
    return nil;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load");
    self.currentCardCount = self.startingCardCount;
  
    // initialize game without waiting for user input
    [self updateGridWithAnimation:NO];
    [self updateUI];
}

#pragma mark - Gestures
#define MIN_PINCH_SCALE 0.01
- (IBAction)pinchCards:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged) {
        self.isInPinchedState = YES;
        
        CGPoint midPoint = [sender locationInView:self.view];
        //CGPoint midPoint = self.view.center;
        self.pinchScale *= sender.scale;
        if (self.pinchScale < MIN_PINCH_SCALE)
            self.pinchScale = MIN_PINCH_SCALE;
        
        // move the card centers in the direction of the pinch
        int row = 0;
        int col = 0;
        for (NSUInteger i = 0; i < [[self.gameView subviews]count]; i++) {
            UIView *view = [[self.gameView subviews] objectAtIndex:i];
            CGPoint cardCenter = [self.grid centerOfCellAtRow:row inColumn:col];
            
            // get magnitude and directions for vector scaling
            CGFloat magnitude = distanceBetweenTwoPoints(midPoint, cardCenter);
            CGFloat dx = cardCenter.x - midPoint.x;
            CGFloat dy = cardCenter.y - midPoint.y;
            
            // update card center
            CGFloat centerX = midPoint.x + (dx * self.pinchScale);
            CGFloat centerY = midPoint.y + (dy * self.pinchScale);
            
            view.center = CGPointMake(centerX, centerY);
            
            // update row and col values to get next item in grid
            if ((col + 1) % self.grid.columnCount == 0) {
                row++;
                col = 0;
            } else {
                col++;
            }
        }
        sender.scale = 1.0;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ended.. ");
        self.pinchScale = 1.0;
        
        
    }
    
}

CGFloat distanceBetweenTwoPoints(CGPoint point1, CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};

- (void) pan:(UIPanGestureRecognizer *)sender {
    NSLog(@"recognized pan gesture");
    if (self.isInPinchedState) {
        CGPoint gesturePoint = [sender locationInView:sender.view];
        for (NSUInteger i = 0; i < [[self.gameView subviews] count]; i++) {
           
            UIView *view = [[self.gameView subviews] objectAtIndex:i];
            if (sender.state == UIGestureRecognizerStateBegan) {
                [self attachView:view toPoint:gesturePoint];
            } else if (sender.state == UIGestureRecognizerStateChanged) {
                UIAttachmentBehavior *a = [self.attachments objectAtIndex:i];
                a.anchorPoint = gesturePoint;
                a.length = (CGFloat) i; // stagger the cards so it looks like a stacked deck
                 NSLog(@"i: %d", i);
            } else if (sender.state == UIGestureRecognizerStateEnded) {
                 UIAttachmentBehavior *a = [self.attachments objectAtIndex:i];
                [self.animator removeBehavior:a];
            }
        }
        if (sender.state == UIGestureRecognizerStateEnded) {
            [self.attachments removeAllObjects];
        }
        
    }
}

- (void)attachView:(UIView *)view toPoint:(CGPoint)anchorPoint
{
    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:view attachedToAnchor:anchorPoint];
    [self.attachments addObject:attachment];
    [self.animator addBehavior:attachment];
}

- (void)tapCard:(UITapGestureRecognizer *)sender {
    NSLog(@"game controller programmed tap gesture recognized");
    if (!self.isInPinchedState) {
        [self animateTouchCardAction:sender.view];
        NSUInteger index = [[self.gameView subviews] indexOfObject:sender.view];
        [self.game chooseCardAtIndex:index];
    } else {
        self.isInPinchedState = NO;
        [self updateGridWithAnimation:YES];
    }
    [self updateUI];
}

- (void) placeCardInGrid:(Card*)card atRow:(NSUInteger)row inColumn:(NSUInteger)column {
    CGRect frame = [self.grid frameOfCellAtRow:row inColumn:column];
    UIView *cardView = [self createCardViewWithFrame:frame usingCard:card];
    [self.gameView addSubview:cardView];
    [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];
    // attach pan animator
    [cardView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
}

- (void) placeAllCardsInGridWithAnimation:(bool)isAnimated {
    // remove all views from the frame
    int row = 0;
    int col = 0;
    for (NSUInteger i = 0; i < self.currentCardCount; i++) {
        Card *card = [self.game cardAtIndex:i];
        if (!isAnimated){
            [self placeCardInGrid:card atRow:row inColumn:col];
        } else {
            [self placeCardInGrid:card atRow:0 inColumn:0];
            UIView *view = [[self.gameView subviews] objectAtIndex:i];
            [UIView transitionWithView:view
                              duration:0.5
                               options:UIViewAnimationOptionCurveEaseIn
                            animations:^{
                                CGRect frame = [self.grid frameOfCellAtRow:row inColumn:col];
                                view.frame = frame;
                            }completion: NULL];
        }
        
        if ((col + 1) % self.grid.columnCount == 0) {
            row++;
            col = 0;
        } else {
            col++;
        }
    }
}

- (void) viewDidLayoutSubviews
{
    // reset grid size
    self.grid = nil;
    [self updateGridWithAnimation:NO];
    [self updateUI];
    
}

- (UIView *)createCardViewWithFrame:(CGRect)frame usingCard:(Card*) card{
    return nil;
}

- (NSMutableAttributedString *) attributedDescription
{
    if (!_attributedDescription) _attributedDescription = [[NSMutableAttributedString alloc] init];
    return _attributedDescription;
}

- (IBAction)touchRestartButton:(UIButton *)sender
{
    // reset game deck
    self.game = nil;
    [self.game.chosenCards removeAllObjects];
    
    // reset the score label to 0
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    // reset the current card count to the default start values
    self.currentCardCount = self.startingCardCount;
    
    
    [self resetUIElements];
        [UIView transitionWithView:self.gameView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCurlDown
                        animations:^{
                            [self removeAllSubviewsFromView:self.gameView];
                        }completion:^(BOOL finished) {
                            if (finished) {
                                [self updateGridWithAnimation:YES];
                                [self updateUI];
                            }
                        }];
    
    
    
    
}

- (void) animateTouchCardAction:(UIView *)view {
}

#pragma mark UI updates

// abstract
- (void) resetUIElements {
}

// abstract
- (void) updateCardWithView:(UIView *)view usingCard:(Card*)card {
}

- (void) removeAllSubviewsFromView:(UIView *)view {
    for (UIView *subview in [view subviews])  {
        [subview removeFromSuperview];
    }
}

- (void)updateGridWithAnimation:(bool)isAnimated
{
    NSLog(isAnimated? @"update grid with animation" : @"update grid");
    self.grid = nil;
    [self removeAllSubviewsFromView:self.gameView];
    [self placeAllCardsInGridWithAnimation:isAnimated];
}

- (void)updateUI
{
    // update cards' status, remove matched cards
    for (NSUInteger i = 0; i < [[self.gameView subviews] count]; i++) {
        UIView *view = [[self.gameView subviews] objectAtIndex:i];
        Card *card = [self.game cardAtIndex:i];
        [self updateCardWithView:view usingCard:card];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

// NSNotFound implies not a (mis)match action
- (NSString *) setDescriptionTextForPoints:(int) points {
    return points == NSNotFound ? @"" : [NSString stringWithFormat:@"%1$@ for %2$d points.", points > 0 ? @"Match" : @"Penalty, mismatched",points];
}

// abstract
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return nil;
}


@end

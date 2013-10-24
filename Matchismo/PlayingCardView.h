//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Jessica Tai on 10/19/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic,getter=isFaceUp) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end

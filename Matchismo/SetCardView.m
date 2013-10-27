//
//  SetCardView.m
//  Matchismo
//
//  Created by Jessica Tai on 10/21/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark - Properties
- (void) setColor:(int)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void) setShape:(int)shape {
    _shape = shape;
    [self setNeedsDisplay];
}

- (void) setShading:(int)shading {
    _shading = shading;
    [self setNeedsDisplay];
}

- (void) setCount:(int)count {
    _count = count;
    [self setNeedsDisplay];
}

- (void) setChosen:(BOOL)chosen {
    _chosen = chosen;
    [self setNeedsDisplay];
}

#pragma mark - Gestures

- (void)tapCard:(UITapGestureRecognizer *)sender {
    NSLog(@"programmed tap gesture recognized");
    self.chosen= !self.chosen;
}

#pragma mark - Drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect:(CGRect) rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];

    [self drawPips]; // pips = non-face cards' display
    
    if ([self isChosen]) {
        [self.layer setBorderWidth:3.0];
        [self.layer setBorderColor:[[UIColor blueColor] CGColor] ];
    } else {
        [self.layer setBorderWidth:0.0]; // remove border when not chosen
    }
    
}

#pragma mark - Drawing card content

#define PIP_HEIGHT_SCALE_FACTOR 1.0
#define PIP_FONT_SCALE_FACTOR 0.012

#define SHAPE_OFFSET 0.2;
#define SHAPE_LINE_WIDTH 0.02;

- (void)drawPips {
    CGFloat hoffset = self.bounds.size.width * SHAPE_OFFSET;
 
    if (self.count == 1 || self.count == 3) { // draw center item
        [self drawPipsWithHorizontalOffset:0];
    }
    if (self.count == 2) {
        [self drawPipsWithHorizontalOffset:hoffset * -0.75];
        [self drawPipsWithHorizontalOffset:hoffset * 0.75];
    }
    if (self.count == 3) { // draw left and right of center
        [self drawPipsWithHorizontalOffset:hoffset * -1.5];
        [self drawPipsWithHorizontalOffset:hoffset * 1.5];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset {
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint pipOrigin = CGPointMake(
                                    middle.x-hoffset,
                                    middle.y
                                    );
    if (self.shape == 1) {  // squiggle
        [self drawSquiggleWithOrigin:pipOrigin];
    }
    else if (self.shape == 2) { // oval
        [self drawCircleWithOrigin:pipOrigin];
    }
    else if (self.shape == 3) { // diamond
        [self drawDiamondWithOrigin:pipOrigin];
    }
    
}

// TODO: Johan's suggestion - use addCurveToPoint
#define SQUIGGLE_WIDTH 0.12
#define SQUIGGLE_HEIGHT 0.3
#define SQUIGGLE_CONST 0.8
// Google helped with drawing a squiggle
- (void) drawSquiggleWithOrigin:(CGPoint) pipOrigin {
    CGFloat dx = self.bounds.size.width * SQUIGGLE_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * SQUIGGLE_HEIGHT / 2;
    CGFloat dsqx = dx * SQUIGGLE_CONST;
    CGFloat dsqy = dy * SQUIGGLE_CONST;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(pipOrigin.x - dx, pipOrigin.y - dy)];
    [path addQuadCurveToPoint:CGPointMake(pipOrigin.x + dx, pipOrigin.y - dy)
                 controlPoint:CGPointMake(pipOrigin.x - dsqx, pipOrigin.y - dy - dsqy)];
    [path addCurveToPoint:CGPointMake(pipOrigin.x + dx, pipOrigin.y + dy)
            controlPoint1:CGPointMake(pipOrigin.x + dx + dsqx, pipOrigin.y - dy + dsqy)
            controlPoint2:CGPointMake(pipOrigin.x + dx - dsqx, pipOrigin.y + dy - dsqy)];
    [path addQuadCurveToPoint:CGPointMake(pipOrigin.x - dx, pipOrigin.y + dy)
                 controlPoint:CGPointMake(pipOrigin.x + dsqx, pipOrigin.y + dy + dsqy)];
    [path addCurveToPoint:CGPointMake(pipOrigin.x - dx, pipOrigin.y - dy)
            controlPoint1:CGPointMake(pipOrigin.x - dx - dsqx, pipOrigin.y + dy - dsqy)
            controlPoint2:CGPointMake(pipOrigin.x - dx + dsqx, pipOrigin.y - dy + dsqy)];
    path.lineWidth = self.bounds.size.width * SHAPE_LINE_WIDTH;
    
    UIColor *color = [self getStrokeColor:self.color];
    [self shadePath:path];
    
    [color setStroke];
    [path stroke];
    
}

#define OVAL_WIDTH 0.15
#define OVAL_HEIGHT 0.3
- (void) drawCircleWithOrigin:(CGPoint) pipOrigin {
    
    CGFloat dx = self.bounds.size.width * OVAL_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * OVAL_HEIGHT / 2;
    CGRect rect = CGRectMake(pipOrigin.x - dx, pipOrigin.y - dy , dx * 2, dy * 2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];

    UIColor *color = [self getStrokeColor:self.color];
    [self shadePath:path];
    
    [color setStroke];
    [path stroke];
}

#define DIAMOND_WIDTH 0.2
#define DIAMOND_HEIGHT 0.3
-(void) drawDiamondWithOrigin:(CGPoint) pipOrigin {
    CGFloat dx = self.bounds.size.width * DIAMOND_WIDTH / 2;
    CGFloat dy = self.bounds.size.height * DIAMOND_HEIGHT / 2;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(pipOrigin.x, pipOrigin.y + dy)];
    [path addLineToPoint:CGPointMake(pipOrigin.x + dx, pipOrigin.y)];
    [path addLineToPoint:CGPointMake(pipOrigin.x, pipOrigin.y - dy)];
    [path addLineToPoint:CGPointMake(pipOrigin.x - dx, pipOrigin.y)];
    [path closePath];

    UIColor *color = [self getStrokeColor:self.color];
    [color setStroke];
    [path stroke];
    [self shadePath:path];
}

- (UIColor *) getStrokeColor:(int) color {
    NSDictionary *colors = @{ @1 : [UIColor greenColor],
                              @2 : [UIColor purpleColor],
                              @3 : [UIColor redColor] };
    return colors[[[NSNumber alloc] initWithInt:color] ];
}

#define STRIPES_OFFSET 0.04
- (void)shadePath:(UIBezierPath *)path
{
    if (self.shading == 1) {
        [[self getStrokeColor:self.color] setFill];
        [path fill];
    }
    else if (self.shading == 2) {
        [[UIColor clearColor] setFill];
    }
    else if (self.shading == 3) { // vertical stripes
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [path addClip];
        UIBezierPath *stripes = [[UIBezierPath alloc] init];
        CGPoint start = self.bounds.origin;
        CGPoint end = start;
        CGFloat dx = self.bounds.size.width * STRIPES_OFFSET;
        end.y += self.bounds.size.height;
        for (int i = 0; i < 1 / STRIPES_OFFSET; i++) {
            [stripes moveToPoint:start];
            [stripes addLineToPoint:end];
            start.x += dx;
            end.x += dx;
        }
        stripes.lineWidth = self.bounds.size.width / 2 * SHAPE_LINE_WIDTH;
        UIColor *color = [self getStrokeColor:self.color];
        [color setStroke];
        [stripes stroke];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
}

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end

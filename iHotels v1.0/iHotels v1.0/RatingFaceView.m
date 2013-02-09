//
//  RatingFaceView.m
//  test
//
//  Created by Martin on 09-02-2013.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "RatingFaceView.h"

@interface RatingFaceView ()
@property (nonatomic, strong) UIColor* strokeColor;
@end

@implementation RatingFaceView
@synthesize ratingValue = _ratingValue;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.ratingValue = 0;
        self.strokeColor = [UIColor blackColor];
    }
    return self;
}


-(void) drawVeryHappyFace
{
    [self drawDefaultFaceComponents];
    UIColor* fillColor = [UIColor whiteColor];
    
    // Very happy mouth
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(15, 31)];
    [bezierPath addCurveToPoint: CGPointMake(35, 30) controlPoint1: CGPointMake(30, 45) controlPoint2: CGPointMake(35, 35)];
    [bezierPath addCurveToPoint: CGPointMake(15, 31) controlPoint1: CGPointMake(32, 30) controlPoint2: CGPointMake(13, 30)];
    [bezierPath closePath];
    [fillColor setFill];
    [bezierPath fill];
    [self.strokeColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
}



-(void) drawHappyFace
{
    [self drawDefaultFaceComponents];
    UIColor* fillColor = [UIColor whiteColor];
    
    // Happy mouth
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(15, 31)];
    [bezierPath addCurveToPoint: CGPointMake(35, 30) controlPoint1: CGPointMake(25, 38) controlPoint2: CGPointMake(32, 35)];
    [bezierPath addCurveToPoint: CGPointMake(15, 31) controlPoint1: CGPointMake(32, 30) controlPoint2: CGPointMake(13, 30)];
    [bezierPath closePath];
    [fillColor setFill];
    [bezierPath fill];
    [self.strokeColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
}



-(void)drawNeutralFace
{
    [self drawDefaultFaceComponents];
    UIColor* fillColor = [UIColor whiteColor];
    
    // Neutral mouth
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(15, 31)];
    [bezierPath addCurveToPoint: CGPointMake(35, 30) controlPoint1: CGPointMake(13, 35) controlPoint2: CGPointMake(32, 30)];
    [bezierPath addCurveToPoint: CGPointMake(15, 31) controlPoint1: CGPointMake(32, 30) controlPoint2: CGPointMake(13, 30)];
    [bezierPath closePath];
    [fillColor setFill];
    [bezierPath fill];
    [self.strokeColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
}



-(void)drawSadFace
{
    [self drawDefaultFaceComponents];
    UIColor* fillColor = [UIColor whiteColor];
    
    // sad mouth
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(15, 35)];
    [bezierPath addCurveToPoint: CGPointMake(35, 34) controlPoint1: CGPointMake(25, 33) controlPoint2: CGPointMake(32, 32)];
    [bezierPath addCurveToPoint: CGPointMake(15, 35) controlPoint1: CGPointMake(32, 29) controlPoint2: CGPointMake(13, 30)];
    [bezierPath closePath];
    [fillColor setFill];
    [bezierPath fill];
    [self.strokeColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
}



-(void)drawVerySadFace
{
    [self drawDefaultFaceComponents];
    UIColor* fillColor = [UIColor colorWithRed: 0.866 green: 0 blue: 0 alpha: 1];
    
    // very very sad!
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(7, 27, 36, 10)];
    [fillColor set];
    [rectanglePath fill];
    rectanglePath.lineWidth = 1;
    [rectanglePath stroke];
    
    NSString* textContent = @"Censored";
    CGRect textRect = CGRectMake(7, 27, 37, 10);
    [self.strokeColor setFill];
    [textContent drawInRect: textRect withFont:  [UIFont fontWithName: @"Helvetica" size: 8] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
}



-(void) drawDefaultFaceComponents
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 0.8 blue: 0.0 alpha: 1];
    
    UIColor* innerShadowColor = [UIColor colorWithRed: 1 green: 1 blue: 0.6 alpha: 1];
    
    // Shadow Declarations
    UIColor* outerShadow = self.strokeColor;
    CGSize outerShadowOffset = CGSizeMake(2.0, 2.0);
    CGFloat outerShadowBlurRadius = 5;
    
    UIColor* innerShadow = innerShadowColor;
    CGSize innerShadowOffset = CGSizeMake(7.0, 7.0);
    CGFloat innerShadowBlurRadius = 7;
    
    // Face
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(5, 5, 40, 40)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, outerShadowOffset, outerShadowBlurRadius, outerShadow.CGColor);
    [fillColor setFill];
    [ovalPath fill];
    
    // Face Inner Shadow
    CGRect ovalBorderRect = CGRectInset([ovalPath bounds], -innerShadowBlurRadius, -innerShadowBlurRadius);
    ovalBorderRect = CGRectOffset(ovalBorderRect, -innerShadowOffset.width, -innerShadowOffset.height);
    ovalBorderRect = CGRectInset(CGRectUnion(ovalBorderRect, [ovalPath bounds]), -1, -1);
    UIBezierPath* ovalNegativePath = [UIBezierPath bezierPathWithRect: ovalBorderRect];
    [ovalNegativePath appendPath: ovalPath];
    ovalNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = innerShadowOffset.width + round(ovalBorderRect.size.width);
        CGFloat yOffset = innerShadowOffset.height;
        CGContextSetShadowWithColor(context, CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)), innerShadowBlurRadius, innerShadow.CGColor);
        [ovalPath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(ovalBorderRect.size.width), 0);
        [ovalNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [ovalNegativePath fill];
    }
    
    CGContextRestoreGState(context);
    CGContextRestoreGState(context);
    [self.strokeColor setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];
    
    // Left Eye
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(16, 17, 5, 5)];
    [self.strokeColor setFill];
    [oval2Path fill];
    [self.strokeColor setStroke];
    oval2Path.lineWidth = 1;
    [oval2Path stroke];
    
    // Right Eye
    UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(29, 17, 5, 5)];
    [self.strokeColor setFill];
    [oval3Path fill];
    [self.strokeColor setStroke];
    oval3Path.lineWidth = 1;
    [oval3Path stroke];
}



- (void)drawRect:(CGRect)rect
{
    switch (self.ratingValue) {
        case 1:
            [self drawVerySadFace];
            break;
        case 2:
            [self drawSadFace];
            break;
        case 3:
            [self drawNeutralFace];
            break;
        case 4:
            [self drawHappyFace];
            break;
        case 5:
            [self drawVeryHappyFace];
        default:
            break;
    }
}


@end

//
//  MainViewController.m
//  JigsawExample
//
//  Created by Guntis Treulands on 3/18/13.
//  Copyright (c) 2013 Guntis Treulands. All rights reserved.
//

#import "MainViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
//    originalCatImage_ = [UIImage imageNamed:@"pic"];
//    
//    originalCatImage_ = [UIImage imageNamed:@"pic2"];
//
//    originalCatImage_ = [UIImage imageNamed:@"pic3"];
//    
//    originalCatImage_ = [UIImage imageNamed:@"pic4"];
//    
    originalCatImage_ = [UIImage imageNamed:@"QYttC"];
    
    
    peaceHCount_ = 3;
    
    peaceVCount_ = 3;
    
    
    cubeHeightValue_ = originalCatImage_.size.height/peaceVCount_;
    
    cubeWidthValue_ = originalCatImage_.size.width/peaceHCount_;
    
    deepnessH_ = -(cubeHeightValue_ / 4);
    
    deepnessV_ = -(cubeWidthValue_ / 4);
    
    
    
    [self setUpPeaceCoordinatesTypesAndRotationValuesArrays];
    
    [self setUpPeaceBezierPaths];
    
    [self setUpPuzzlePeaceImages];
}

- (void)dealloc
{
    DLog();
    
    [pieceCoordinateRectArray_ release], pieceCoordinateRectArray_ = nil;
    
    [pieceBezierPathsMutArray_ release], pieceBezierPathsMutArray_ = nil;
    
    [pieceRotationValuesArray_ release], pieceRotationValuesArray_ = nil;
    
    [pieceTypeValueArray_ release], pieceTypeValueArray_ = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark autorotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft
        || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark -
#pragma mark set up elements

- (void)setUpPeaceCoordinatesTypesAndRotationValuesArrays
{
    DLog();
    
    //--- rotations  (currently commented out so that at the beginning would be generated picture, where each peace is in its correct place)
    NSArray *mRotationTypeArray = [NSArray arrayWithObjects:
        [NSNumber numberWithFloat:M_PI/2],
        [NSNumber numberWithFloat:M_PI],
        [NSNumber numberWithFloat:M_PI + M_PI/2],
        [NSNumber numberWithFloat:M_PI*2],
        nil];
    //===
    
    
    //---
    pieceTypeValueArray_ = [NSMutableArray new]; //0: empty side /  1: outside  / -1: inside
    
    pieceCoordinateRectArray_ = [NSMutableArray new];
    
    pieceRotationValuesArray_ = [NSMutableArray new];
    
    int mSide1 = 0;
    
    int mSide2 = 0;
    
    int mSide3 = 0;
    
    int mSide4 = 0;
    
    int mCounter = 0;
    
    int mCubeWidth = 0;
    
    int mCubeHeight = 0;
    
    int mXPoint = 0;
    
    int mYPoint = 0;
    
    for(int i = 0; i < peaceVCount_; i++)
    {
        for(int j = 0; j < peaceHCount_; j++)
        {
            if(j != 0)
            {
                mSide1 = ([[[pieceTypeValueArray_ objectAtIndex:mCounter-1] objectAtIndex:2] intValue] == 1)?-1:1;
            }
            
            if(i != 0)
            {
                mSide4 = ([[[pieceTypeValueArray_ objectAtIndex:mCounter-peaceHCount_] objectAtIndex:1] intValue] == 1)?-1:1;
            }
            
            
            mSide2 = ((arc4random() % 2) == 1)?1:-1;
            
            mSide3 = ((arc4random() % 2) == 1)?1:-1;
            
            
            if(i == 0)
            {
                mSide4 = 0;
            }
            
            if(j == 0)
            {
                mSide1 = 0;
            }
            
            
            if(i == peaceVCount_-1)
            {
                mSide2 = 0;
            }
            
            if(j == peaceHCount_-1)
            {
                mSide3 = 0;
            }
            
            
            //--- calculate cube width and height
            mCubeWidth = cubeWidthValue_;
            
            mCubeHeight = cubeHeightValue_;
            
            if(mSide1 == 1)
            {
                mCubeWidth -= deepnessV_;
            }
            
            if(mSide3 == 1)
            {
                mCubeWidth -= deepnessV_;
            }
            
            if(mSide2 == 1)
            {
                mCubeHeight -= deepnessH_;
            }
            
            if(mSide4 == 1)
            {
                mCubeHeight -= deepnessH_;
            }
            //===
            
            
            //--- piece side types
            [pieceTypeValueArray_ addObject:[NSArray arrayWithObjects:
                [NSString stringWithFormat:@"%i", mSide1],
                [NSString stringWithFormat:@"%i", mSide2],
                [NSString stringWithFormat:@"%i", mSide3],
                [NSString stringWithFormat:@"%i", mSide4],
                nil]];
            //===
            
           
            //--- frames for cropping and imageviews
            mXPoint = MAX(mCubeWidth, MIN(arc4random() % MAX(1,(int)(self.view.frame.size.width - mCubeWidth*2)) + mCubeWidth, self.view.frame.size.width - mCubeWidth*2));
            
            mYPoint = MAX(mCubeHeight, MIN(arc4random() % MAX(1,(int)(self.view.frame.size.height - mCubeHeight*2)) + mCubeHeight, self.view.frame.size.height - mCubeHeight*2));
            
            [pieceCoordinateRectArray_ addObject:[NSArray arrayWithObjects:
                [NSValue valueWithCGRect:CGRectMake(j*cubeWidthValue_,i*cubeHeightValue_,mCubeWidth,mCubeHeight)],
                [NSValue valueWithCGRect:CGRectMake(j*cubeWidthValue_-(mSide1==1?-deepnessV_:0),i*cubeHeightValue_-(mSide4==1?-deepnessH_:0), mCubeWidth, mCubeHeight)], nil]];
                //[NSValue valueWithCGRect:CGRectMake(mXPoint, mYPoint, mCubeWidth, mCubeHeight)], nil]];
            //===
            
            // Rotation
            [pieceRotationValuesArray_ addObject:[NSNumber numberWithFloat:0]];//[mRotationTypeArray objectAtIndex:(arc4random() % 4)]];
            
            mCounter++;
        }
    }
}


- (void)setUpPeaceBezierPaths
{
    DLog();
    
    //---
    pieceBezierPathsMutArray_ = [NSMutableArray new];
    
    pieceBezierPathsWithoutHolesMutArray_ = [NSMutableArray new];
    //===
 
    
    float mYSideStartPos = 0;
    
    float mXSideStartPos = 0;
    
    float mCustomDeepness = 0;
    
    float mCurveHalfVLength = cubeWidthValue_ / 10;
    
    float mCurveHalfHLength = cubeHeightValue_ / 10;
    
    float mCurveStartXPos = cubeWidthValue_ / 2 - mCurveHalfVLength;
    
    float mCurveStartYPos = cubeHeightValue_ / 2 - mCurveHalfHLength;
    
    float mTotalHeight = 0;
    
    float mTotalWidth = 0;
    
    
    
    for(int i = 0; i < [pieceTypeValueArray_ count]; i++)
    {
        mXSideStartPos = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] intValue] == 1)?-deepnessV_:0;
      
        mYSideStartPos = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] intValue] == 1)?-deepnessH_:0;
        
        
        mTotalHeight = mYSideStartPos + mCurveStartYPos*2 + mCurveHalfHLength * 2;
    
        mTotalWidth = mXSideStartPos + mCurveStartXPos*2 + mCurveHalfVLength * 2;
    
    
        //--- bezierPath begins
        UIBezierPath* mPieceBezier = [UIBezierPath bezierPath];
        
        [mPieceBezier moveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        //===
        
        
        //--- bezier for touches begins
        UIBezierPath* mTouchPieceBezier = [UIBezierPath bezierPath];
        
        [mTouchPieceBezier moveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        //===
        
        
        //--- kreisā puse
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos)]; 
        
        if(![[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] isEqualToString:@"0"])
        {
            mCustomDeepness = deepnessV_ * [[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos+mCurveHalfHLength) controlPoint1: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength - mCurveStartYPos)];//25
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength*2) controlPoint1: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos, mYSideStartPos+mCurveStartYPos + mCurveHalfHLength*2)]; //156
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mTotalHeight)];
    
    
    
        [mTouchPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos)]; 
        
        if([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] isEqualToString:@"1"])
        {
            mCustomDeepness = deepnessV_;
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos+mCurveHalfHLength) controlPoint1: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength - mCurveStartYPos)];//25
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength*2) controlPoint1: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos, mYSideStartPos+mCurveStartYPos + mCurveHalfHLength*2)]; //156
        }
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mTotalHeight)];
        //===
        
        
        
        
        //--- apakša
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos+ mCurveStartXPos, mTotalHeight)];
        
        if(![[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:1] isEqualToString:@"0"])
        {
            mCustomDeepness = deepnessH_ * [[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:1] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint1: CGPointMake(mXSideStartPos + mCurveStartXPos, mTotalHeight) controlPoint2: CGPointMake(mXSideStartPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness)];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength+mCurveHalfVLength, mTotalHeight) controlPoint1: CGPointMake(mTotalWidth - mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength + mCurveHalfVLength, mTotalHeight)];
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight)];
        
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mXSideStartPos+ mCurveStartXPos, mTotalHeight)];
        
        if([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:1] isEqualToString:@"1"])
        {
            mCustomDeepness = deepnessH_;
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint1: CGPointMake(mXSideStartPos + mCurveStartXPos, mTotalHeight) controlPoint2: CGPointMake(mXSideStartPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness)];
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength+mCurveHalfVLength, mTotalHeight) controlPoint1: CGPointMake(mTotalWidth - mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength + mCurveHalfVLength, mTotalHeight)];
        }
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight)];
        //===

        
        //--- labā puse
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight - mCurveStartYPos)];
        
        if(![[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:2] isEqualToString:@"0"])
        {
            mCustomDeepness = deepnessV_ * [[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:2] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength) controlPoint1: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength * 2) controlPoint2: CGPointMake(mTotalWidth - mCustomDeepness, mTotalHeight - mCurveHalfHLength)];
        
            [mPieceBezier addCurveToPoint: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos) controlPoint1: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveHalfHLength) controlPoint2: CGPointMake(mTotalWidth, mCurveStartYPos + mYSideStartPos)];
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mYSideStartPos)];
        
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight - mCurveStartYPos)];
        
        if([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:2] isEqualToString:@"1"])
        {
            mCustomDeepness = deepnessV_;
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength) controlPoint1: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength * 2) controlPoint2: CGPointMake(mTotalWidth - mCustomDeepness, mTotalHeight - mCurveHalfHLength)];
        
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos) controlPoint1: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveHalfHLength) controlPoint2: CGPointMake(mTotalWidth, mCurveStartYPos + mYSideStartPos)];
        }
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mYSideStartPos)];
        //===
        
        
        //--- augša
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos)];
        
        if(![[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] isEqualToString:@"0"])
        {
            mCustomDeepness = deepnessH_ * [[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCurveStartXPos - mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint1: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos) controlPoint2: CGPointMake(mTotalWidth - mCurveHalfVLength, mYSideStartPos + mCustomDeepness)];
        
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos) controlPoint1: CGPointMake(mXSideStartPos + mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos)];
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos)];
        
        if([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] isEqualToString:@"1"])
        {
            mCustomDeepness = deepnessH_;
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCurveStartXPos - mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint1: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos) controlPoint2: CGPointMake(mTotalWidth - mCurveHalfVLength, mYSideStartPos + mCustomDeepness)];
        
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos) controlPoint1: CGPointMake(mXSideStartPos + mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos)];
        }
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        //===
        
        
        //---
        [pieceBezierPathsMutArray_ addObject:mPieceBezier];
        
        [pieceBezierPathsWithoutHolesMutArray_ addObject:mTouchPieceBezier];
        //===
    }
}


- (void)setUpPuzzlePeaceImages
{
    DLog();
      
    float mXAddableVal = 0;
    
    float mYAddableVal = 0;
    
    for(int i = 0; i < [pieceBezierPathsMutArray_ count]; i++)
    {
        CGRect mCropFrame = [[[pieceCoordinateRectArray_ objectAtIndex:i] objectAtIndex:0] CGRectValue];
        
        CGRect mImageFrame = [[[pieceCoordinateRectArray_ objectAtIndex:i] objectAtIndex:1] CGRectValue];
        
        //--- puzzle peace image.
        UIImageView *mPeace = [UIImageView new];
        
        [mPeace setFrame:mImageFrame];
        
        [mPeace setTag:i+100];
        
        [mPeace setUserInteractionEnabled:YES];
        
        [mPeace setContentMode:UIViewContentModeTopLeft];
        //===
        
    
        //--- addable value
        mXAddableVal = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] intValue] == 1)?deepnessV_:0;
        
        mYAddableVal = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] intValue] == 1)?deepnessH_:0;
        
        mCropFrame.origin.x += mXAddableVal;

        mCropFrame.origin.y += mYAddableVal;
        //===
        
        
        //--- crop and clip and add to self view
        [mPeace setImage:[self cropImage:originalCatImage_
            withRect:mCropFrame]];
    
        [self setClippingPath:[pieceBezierPathsMutArray_ objectAtIndex:i]:mPeace];
      
        [[self view] addSubview:mPeace];
        
        [mPeace setTransform:CGAffineTransformMakeRotation([[pieceRotationValuesArray_ objectAtIndex:i] floatValue])];
        //===
        
        
        //--- border line
        CAShapeLayer *mBorderPathLayer = [CAShapeLayer layer];
        
        [mBorderPathLayer setPath:[[pieceBezierPathsMutArray_ objectAtIndex:i] CGPath]];
        
        [mBorderPathLayer setFillColor:[UIColor clearColor].CGColor];
        
        [mBorderPathLayer setStrokeColor:[UIColor blackColor].CGColor];
        
        [mBorderPathLayer setLineWidth:2];
        
        [mBorderPathLayer setFrame:CGRectZero];

        [[mPeace layer] addSublayer:mBorderPathLayer];
        //===
        
        
        //--- secret border line for touch recognition 
        CAShapeLayer *mSecretBorder = [CAShapeLayer layer];
        
        [mSecretBorder setPath:[[pieceBezierPathsWithoutHolesMutArray_ objectAtIndex:i] CGPath]];
        
        [mSecretBorder setFillColor:[UIColor clearColor].CGColor];
        
        [mSecretBorder setStrokeColor:[UIColor blackColor].CGColor];
        
        [mSecretBorder setLineWidth:0];
        
        [mSecretBorder setFrame:CGRectZero];

        [[mPeace layer] addSublayer:mSecretBorder];
        //===
        
        
        //--- gestures
        UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc]
            initWithTarget:self action:@selector(rotate:)];
        
        [rotationRecognizer setDelegate:self];
        
        [mPeace addGestureRecognizer:rotationRecognizer];
        
        [rotationRecognizer release];
        
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
            initWithTarget:self action:@selector(move:)];
        
        [panRecognizer setMinimumNumberOfTouches:1];
        
        [panRecognizer setMaximumNumberOfTouches:2];
        
        [panRecognizer setDelegate:self];
        
        [mPeace addGestureRecognizer:panRecognizer];

        [panRecognizer release];
        //===
        
        
        //--- release img.
        [mPeace release];
        //===
    }
}

#pragma mark -
#pragma mark help functions

- (void) setClippingPath:(UIBezierPath *)clippingPath : (UIImageView *)imgView;
{
    if (![[imgView layer] mask])
    {
        [[imgView layer] setMask:[CAShapeLayer layer]];
    }
    
    [(CAShapeLayer*) [[imgView layer] mask] setPath:[clippingPath CGPath]];
}


- (UIImage *) cropImage:(UIImage*)originalImage withRect:(CGRect)rect
{
    return [UIImage imageWithCGImage:CGImageCreateWithImageInRect([originalImage CGImage], rect)]; 
}

#pragma mark -
#pragma mark gesture functions

- (void)rotate:(id)sender
{
    //DLog();
    
	[self.view bringSubviewToFront:[(UIRotationGestureRecognizer*)sender view]];

	if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        CGFloat realRotation = 0;
        
        realRotation = lastRotation_-((M_PI*2)*(int)(lastRotation_/(M_PI*2)));
        
        realRotation += [[pieceRotationValuesArray_ objectAtIndex:[(UIRotationGestureRecognizer*)sender view].tag-100] floatValue];
        
        
        if(realRotation > M_PI*2)
        {
            realRotation -= M_PI*2;
        }
        
        realRotation -= M_PI/4;
        
        if(realRotation < -M_PI/4)
        {
            realRotation += M_PI*2;
        }
        
        if(realRotation < 0)
        {
            realRotation = 0;
        }
        else if(realRotation < M_PI/2)
        {
            realRotation = M_PI/2;
        }
        else if(realRotation < M_PI)
        {
            realRotation = M_PI;
        }
        else if(realRotation < M_PI + M_PI/2)
        {
            realRotation = M_PI + M_PI/2;
        }
        else if(realRotation <= M_PI * 2)
        {
            realRotation = M_PI * 2;
        }
        
        [pieceRotationValuesArray_ replaceObjectAtIndex:[(UIRotationGestureRecognizer*)sender view].tag-100
            withObject:[NSNumber numberWithFloat:realRotation]];

        
        [UIView beginAnimations:nil context:nil];

        [UIView setAnimationDuration:0.25];

        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

            [[(UIRotationGestureRecognizer*)sender view] setTransform:CGAffineTransformMakeRotation(realRotation)];
        
        [UIView commitAnimations];

		lastRotation_ = 0.0;
        
		return;
	}

	CGFloat rotation = 0.0 - (lastRotation_ - [(UIRotationGestureRecognizer*)sender rotation]);

	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    
    
	CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);

	[[(UIRotationGestureRecognizer*)sender view] setTransform:newTransform];

	lastRotation_ = [(UIRotationGestureRecognizer*)sender rotation];
}


- (void)move:(id)sender
{
   // DLog();

    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];

    if(touchedImgViewTag_ == 0 || touchedImgViewTag_ == 99)
    {
        
        return;
    }
    


    UIImageView *mImgView = (UIImageView *)[[self view] viewWithTag:touchedImgViewTag_];
                    
    translatedPoint = CGPointMake(firstX_+translatedPoint.x, firstY_+translatedPoint.y);
    
    [mImgView setCenter:translatedPoint];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;//![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLog();
    
    if(touchedImgViewTag_ == 0)
    {
        return;
    }
    
    UIImageView *mImgView = (UIImageView *)[[self view] viewWithTag:touchedImgViewTag_];
    
    if(!mImgView || ![mImgView isKindOfClass:[UIImageView class]])
    {
        return;
    }

     
    CGFloat mRotation = [[pieceRotationValuesArray_ objectAtIndex:mImgView.tag-100] floatValue];
    
    [UIView beginAnimations:nil context:nil];

    [UIView setAnimationDuration:0.25];

    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

        if(mRotation >= 0  && mRotation < M_PI/2)
        {
            [mImgView setTransform:CGAffineTransformMakeRotation(M_PI/2)];
            
            mRotation = M_PI/2;
        }
        else if(mRotation >= M_PI/2 && mRotation < M_PI)
        {
            [mImgView setTransform:CGAffineTransformMakeRotation(M_PI)];
            
            mRotation = M_PI;
        }
        else if(mRotation >= M_PI && mRotation < M_PI + M_PI/2)
        {
            [mImgView setTransform:CGAffineTransformMakeRotation(M_PI + M_PI/2)];
            
            mRotation = M_PI + M_PI/2;
        }
        else
        {
            [mImgView setTransform:CGAffineTransformMakeRotation(M_PI*2)];
            
            mRotation = 0;
        }

    
    [UIView commitAnimations];

    
    [pieceRotationValuesArray_ replaceObjectAtIndex:mImgView.tag-100 withObject:[NSNumber numberWithFloat:mRotation]];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLog();
    
    touchedImgViewTag_ = 0;
    
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInView:self.view];
    
    
    //--- get imageview
    UIImageView *mImgView = nil;
    
    touchedImgViewTag_ = 0;
    
    for(int i = [[[self view] subviews] count]-1; i > -1 ; i--)
    {
        mImgView = (UIImageView *)[[[self view] subviews] objectAtIndex:i];
        
        location = [touch locationInView:mImgView];
    
        if(CGPathContainsPoint([(CAShapeLayer*) [[[mImgView layer] sublayers] objectAtIndex:1] path], nil, location, NO))
        {
            touchedImgViewTag_ = mImgView.tag;
            
            [[self view] bringSubviewToFront:mImgView];
            
            firstX_ = mImgView.center.x;
            
            firstY_ = mImgView.center.y;
            
            break;
        }
        
    }
}



@end

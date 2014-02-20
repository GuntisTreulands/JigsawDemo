//
//  MainViewController.h
//  JigsawExample
//
//  Created by Guntis Treulands on 3/18/13.
//  Copyright (c) 2013 Guntis Treulands. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController <UIGestureRecognizerDelegate> 
{
    NSInteger cubeHeightValue_;
    
    NSInteger cubeWidthValue_;
    
    NSInteger peaceHCount_;
    
    NSInteger peaceVCount_;
    
    NSInteger deepnessH_;
    
    NSInteger deepnessV_;
    
	CGFloat lastScale_;
	
    CGFloat lastRotation_;

	CGFloat firstX_;
	
    CGFloat firstY_;
    
    NSInteger touchedImgViewTag_;
    
    NSMutableArray *pieceTypeValueArray_;
    
    NSMutableArray *pieceRotationValuesArray_;
    
    NSMutableArray *pieceCoordinateRectArray_;
    
    NSMutableArray *pieceBezierPathsMutArray_;
    
    NSMutableArray *pieceBezierPathsWithoutHolesMutArray_;
    
    UIImage *originalCatImage_;
}

@end

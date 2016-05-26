//
//  HistogramView.h
//  Light-Meter
//
//  Created by     on 11/4/13.
//  Copyright (c) 2013 Cell Phone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistogramView : UIView
{
    int m_histogram[64];
@public
    BOOL    m_bPaused;
}
-(void)SetHistogram:(int*)value;
-(void)StartUpdate;
@end

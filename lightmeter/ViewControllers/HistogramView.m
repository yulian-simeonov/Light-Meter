//
//  HistogramView.m
//  Light-Meter
//
//  Created by     on 11/4/13.
//  Copyright (c) 2013 Cell Phone. All rights reserved.
//

#import "HistogramView.h"

@implementation HistogramView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)StartUpdate
{
    m_bPaused = false;
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(UpdateHistogram) userInfo:nil repeats:NO];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (m_histogram == NULL)
        return;
    int min = INT_MAX;
    int max = 0;
    for(int i = 0; i < 64; i++)
    {
        if (m_histogram[i] < min)
            min = m_histogram[i];
        if (m_histogram[i] > max)
            max = m_histogram[i];
    }
    if (max == 0)
        max = 1;
    float ratio = self.frame.size.height / max;
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGFloat black[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(c, black);
    CGContextBeginPath(c);
    for (int i = 0; i < 64; i++)
    {
        CGContextMoveToPoint(c, i * 2, self.frame.size.height);
        if (m_histogram[i] * ratio < 1)
            CGContextAddLineToPoint(c, i * 2, self.frame.size.height - 1);
        else
            CGContextAddLineToPoint(c, i * 2, self.frame.size.height - m_histogram[i] * ratio - 1);
    }
    CGContextStrokePath(c);
}

-(void)SetHistogram:(int*)value;
{
    if (value)
    {
        for(int i = 0; i < 64; i++)
            m_histogram[i] = value[i];
    }
}

-(void)UpdateHistogram
{
    [self setNeedsDisplay];
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(UpdateHistogram) userInfo:nil repeats:NO];
}
@end

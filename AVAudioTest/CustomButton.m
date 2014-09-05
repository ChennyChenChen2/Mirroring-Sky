//
//  CustomButton.m
//  MirroringSky
//
//  Created by Jonathan Chen on 8/14/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = [self colorWithR:64 G:189 B:74 A:0.75];
    
    CGContextSetFillColorWithColor(context,color.CGColor);
    
    // For some reason this makes it so that you can click on more than just the text to press the button??
    [self setBackgroundColor:[self colorWithR:64 G:189 B:74 A:0.75]];
    
    CGContextFillRect(context, self.bounds);
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 2;
    self.layer.borderColor = self.tintColor.CGColor;
    self.layer.masksToBounds = YES;
    //[self.titleLabel setFont:[UIFont fontWithName:@"Apple Garamond" size:15]];
    [self setTitleColor:[self colorWithR:255 G:30 B:100 A:1] forState:UIControlStateNormal];
    [self setTitleColor:[self colorWithR:0 G:0 B:255 A:1] forState:UIControlStateHighlighted];
}

- (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

@end

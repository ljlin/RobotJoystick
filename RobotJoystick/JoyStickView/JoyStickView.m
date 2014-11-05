//
//  VisualStickView.m
//  SampleGame
//
//  Created by Zhang Xiang on 13-4-26.
//  Copyright (c) 2013年 Myst. All rights reserved.
//

#import "JoyStickView.h"

#define STICK_CENTER_TARGET_POS_LEN 60

@implementation JoyStickView

-(void) initStick
{
    imgStickNormal = [UIImage imageNamed:@"stick_normal.png"];
    imgStickHold = [UIImage imageNamed:@"stick_hold.png"];
    stickView.image = imgStickNormal;
    radius = self.frame.size.width / 2;
    mCenter.x = mCenter.y = radius ;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initStick];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
	{
        [self initStick];
    }
	
    return self;
}

- (void)notifyDir:(CGPoint)dir
{
    
    NSValue *vdir = [NSValue valueWithCGPoint:dir];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              vdir, @"dir", nil];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"StickChanged" object:nil userInfo:userInfo];
    
}

- (void)stickMoveTo:(CGPoint)deltaToCenter
{
    CGRect fr = stickView.frame;
    fr.origin.x = mCenter.x-fr.size.width / 2 + deltaToCenter.x;
    fr.origin.y = mCenter.y-fr.size.height/ 2 + deltaToCenter.y;
    stickView.frame = fr;
}

- (void)touchEvent:(NSSet *)touches
{

    if([touches count] != 1) return ;
    
    UITouch *touch = [touches anyObject];
    UIView  *view  = [touch view];
    
    if(view != self) return ;
    
    CGPoint touchPoint = [touch locationInView:view];
    CGPoint dtarget, dir;
    dir.x = touchPoint.x - mCenter.x;
    dir.y = touchPoint.y - mCenter.y;
    double len = sqrt(dir.x * dir.x + dir.y * dir.y);

    if(len < 10.0 && len > -10.0)
    {
        // center pos
        dtarget.x = 0.0;
        dtarget.y = 0.0;
        dir.x = 0;
        dir.y = 0;
    }
    else
    {
        dtarget = CGPointMake(dir.x, dir.y);
        if(len>radius){
            double len_inv = (radius/len);
            dtarget.x *= len_inv;
            dtarget.y *= len_inv;
        }
        double len_inv = (1.0 / len);
        dir.x *= len_inv;
        dir.y *= len_inv;
        //dtarget.x = dir.x * STICK_CENTER_TARGET_POS_LEN;
        //dtarget.y = dir.y * STICK_CENTER_TARGET_POS_LEN;
    }
    [self stickMoveTo:dtarget];
    
    [self notifyDir:dir];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    stickView.image = imgStickHold;
    [self touchEvent:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchEvent:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    stickView.image = imgStickNormal;
    CGPoint dtarget, dir;
    dir.x = dtarget.x = 0.0;
    dir.y = dtarget.y = 0.0;
    [self stickMoveTo:dtarget];
    
    [self notifyDir:dir];
}

@end

//
//  WLButton.m
//  ButtonOnUITableView
//
//  Created by 王垒 on 16/9/6.
//  Copyright © 2016年 King. All rights reserved.
//

#import "WLButton.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@implementation WLButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initBtn{

    self.isExpanding = NO;
    
    // 主按钮
    self.mainBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, SCREEN_HEIGHT-84, 35, 35)];
    [self.mainBtn setBackgroundImage:[UIImage imageNamed:@"submit_pressed"] forState:UIControlStateNormal];
    
    [self.mainBtn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.mainBtn];
    
    CGPoint buttonCenter = CGPointMake(self.mainBtn.frame.size.width / 2.0f, self.mainBtn.frame.size.height / 2.0f);
    
    // 弹出的按钮
    self.btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"submit_pressed"] forState:UIControlStateNormal];
    
    [self.btn1 setCenter:buttonCenter];
    [self.btn1 setAlpha:0.0f];
    [self addSubview:self.btn1];
    
    self.btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"sumitmood"] forState:UIControlStateNormal];
    
    [self.btn2 setCenter:buttonCenter];
    [self.btn2 setAlpha:0.0f];
    [self addSubview:self.btn2];
    
    self.buttonArray = [NSArray arrayWithObjects:self.btn2, self.btn1, nil];

}

// 点击主按钮的响应
- (void)btnTap:(UIButton *)sender {
    CGAffineTransform angle = CGAffineTransformMakeRotation (0);
    if (!self.isExpanding) {// 初始未展开
        
        [UIView animateWithDuration:0.3 animations:^{// 动画开始
            [sender setTransform:angle];
        } completion:^(BOOL finished){// 动画结束
            [sender setTransform:angle];
            [self.mainBtn setBackgroundImage:[UIImage imageNamed:@"btn_quickoption_route"] forState:UIControlStateNormal];
        }];
        
        [self showButtonsAnimated];
        
        self.isExpanding = YES;
    } else {// 已展开
        //        CGAffineTransform unangle = CGAffineTransformMakeRotation (-M_PI*(45)/180.0);
        [UIView animateWithDuration:0.3 animations:^{// 动画开始
            [sender setTransform:angle];
        } completion:^(BOOL finished){// 动画结束
            [sender setTransform:angle];
            [self.mainBtn setBackgroundImage:[UIImage imageNamed:@"submit_pressed"] forState:UIControlStateNormal];
        }];
        
        [self hideButtonsAnimated];
        
        self.isExpanding = NO;
    }
}

// 展开按钮
- (void)showButtonsAnimated {
    NSLog(@"animate");
    float y = [self.mainBtn center].y;
    float x = [self.mainBtn center].x;
    float endY = y;
    float endX = x;
    for (int i = 0; i < [self.buttonArray count]; ++i) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        // 最终坐标
        endY -= button.frame.size.height + 30.0f;
        endX += 0.0f;
        // 反弹坐标
        float farY = endY - 30.0f;
        float farX = endX - 0.0f;
        float nearY = endY + 15.0f;
        float nearX = endX + 0.0f;
        
        // 动画集合
        NSMutableArray *animationOptions = [NSMutableArray array];
        
        // 旋转动画
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        [rotateAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * 2], nil]];
        [rotateAnimation setDuration:0.4f];
        [rotateAnimation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0f], nil]];
        [animationOptions addObject:rotateAnimation];
        
        // 位置动画
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        [positionAnimation setDuration:0.4f];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, x, y);
        CGPathAddLineToPoint(path, NULL, farX, farY);
        CGPathAddLineToPoint(path, NULL, nearX, nearY);
        CGPathAddLineToPoint(path, NULL, endX, endY);
        [positionAnimation setPath: path];
        CGPathRelease(path);
        [animationOptions addObject:positionAnimation];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        [animationGroup setAnimations: animationOptions];
        [animationGroup setDuration:0.4f];
        [animationGroup setFillMode: kCAFillModeForwards];
        [animationGroup setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        
        NSDictionary *properties = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:button, [NSValue valueWithCGPoint:CGPointMake(endX, endY)], animationGroup, nil] forKeys:[NSArray arrayWithObjects:@"view", @"center", @"animation", nil]];
        
        [self performSelector:@selector(_expand:) withObject:properties afterDelay:0.1f * ([self.buttonArray count] - i)];
    }
}

// 收起动画
- (void) hideButtonsAnimated {
    CGPoint center = [self.mainBtn center];
    float endY = center.y;
    float endX = center.x;
    for (int i = 0; i < [self.buttonArray count]; ++i) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        
        // 动画集合
        NSMutableArray *animationOptions = [NSMutableArray array];
        
        // 旋转动画
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        [rotateAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * -2], nil]];
        [rotateAnimation setDuration:0.4f];
        [rotateAnimation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0f], nil]];
        [animationOptions addObject:rotateAnimation];
        
        // 透明度？
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0f], [NSNumber numberWithFloat:0.0f], nil]];
        [opacityAnimation setDuration:0.4];
        [animationOptions addObject:opacityAnimation];
        
        // 位置动画
        float y = [button center].y;
        float x = [button center].x;
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        [positionAnimation setDuration:0.4f];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, x, y);
        CGPathAddLineToPoint(path, NULL, endX, endY);
        [positionAnimation setPath: path];
        CGPathRelease(path);
        [animationOptions addObject:positionAnimation];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        [animationGroup setAnimations: animationOptions];
        [animationGroup setDuration:0.4f];
        [animationGroup setFillMode: kCAFillModeForwards];
        [animationGroup setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        
        NSDictionary *properties = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:button, animationGroup, nil] forKeys:[NSArray arrayWithObjects:@"view", @"animation", nil]];
        [self performSelector:@selector(_close:) withObject:properties afterDelay:0.1f * ([self.buttonArray count] - i)];
    }
}

// 弹出
- (void) _expand:(NSDictionary*)properties
{
    NSLog(@"expand");
    UIView *view = [properties objectForKey:@"view"];
    CAAnimationGroup *animationGroup = [properties objectForKey:@"animation"];
    NSValue *val = [properties objectForKey:@"center"];
    CGPoint center = [val CGPointValue];
    [[view layer] addAnimation:animationGroup forKey:@"Expand"];
    [view setCenter:center];
    [view setAlpha:1.0f];
}

// 收起
- (void) _close:(NSDictionary*)properties
{
    UIView *view = [properties objectForKey:@"view"];
    CAAnimationGroup *animationGroup = [properties objectForKey:@"animation"];
    CGPoint center = [self.mainBtn center];
    [[view layer] addAnimation:animationGroup forKey:@"Collapse"];
    [view setAlpha:0.0f];
    [view setCenter:center];
}


@end

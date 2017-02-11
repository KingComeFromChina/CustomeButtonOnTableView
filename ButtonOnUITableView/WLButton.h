//
//  WLButton.h
//  ButtonOnUITableView
//
//  Created by 王垒 on 16/9/6.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLButton : UIView

@property BOOL isExpanding;// 是否点击过
@property (strong, nonatomic) UIButton *mainBtn;// 主按钮
@property (strong, nonatomic) NSArray *buttonArray;// 弹出的按钮数组
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@end

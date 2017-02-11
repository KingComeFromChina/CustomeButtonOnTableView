//
//  ViewController.h
//  ButtonOnUITableView
//
//  Created by 王垒 on 16/9/6.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

typedef void(^switchChangeBlock)(BOOL on);
@property (nonatomic, strong)switchChangeBlock block;

@end


//
//  TestCodeCell.h
//  CodeTest
//
//  Created by 王垒 on 16/8/19.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CodeModel;

@interface TestCodeCell : UITableViewCell

@property (nonatomic, strong) CodeModel *model;
/** switch状态改变的block*/
@property (copy, nonatomic) void(^switchChangeBlock)(BOOL on);

@end

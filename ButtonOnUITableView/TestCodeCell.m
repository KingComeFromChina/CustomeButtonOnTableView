//
//  TestCodeCell.m
//  CodeTest
//
//  Created by 王垒 on 16/8/19.
//  Copyright © 2016年 King. All rights reserved.
//

#import "TestCodeCell.h"
#import "CodeModel.h"

@interface TestCodeCell ()

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *label1;
@property (nonatomic, retain) UILabel *label2;

@end

@implementation TestCodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    [self.contentView addSubview:label];
    _label = label;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 40)];
    [self.contentView addSubview:label1];
    _label1 = label1;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 100, 40)];
    [self.contentView addSubview:label2];
    _label2 = label2;

}

- (void)setModel:(CodeModel *)model
{
    _model = model;
    
    _label.text = model.name;
    _label1.text = [NSString stringWithFormat:@"%@",model.old];
    _label2.text = [NSString stringWithFormat:@"%@",model.fat];
}

@end

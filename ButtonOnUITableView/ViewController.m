//
//  ViewController.m
//  ButtonOnUITableView
//
//  Created by 王垒 on 16/9/6.
//  Copyright © 2016年 King. All rights reserved.
//

#import "ViewController.h"
#import "TestCodeCell.h"
#import "CodeModel.h"
#import "WLButton.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
   {
        
        NSString *SwitchStatus;
        UISwitch* mySwitch;
    }



@property BOOL isExpanding;// 是否点击过
@property (strong, nonatomic) UIButton *mainBtn;// 主按钮
@property (strong, nonatomic) NSArray *buttonArray;// 弹出的按钮数组
@property (nonatomic, strong) NSArray *labelArray;
@property (nonatomic, strong) UITableView *codeTableView;
@property (nonatomic, strong) NSMutableArray *testDataArray;
@property (nonatomic, strong) WLButton *btn;
@property (nonatomic, strong) UIWindow *window;

@end

@implementation ViewController

- (NSMutableArray *)testDataArray{
    if (!_testDataArray) {
        _testDataArray = [NSMutableArray array];
    }
    return _testDataArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self fetchData];
    [self.codeTableView reloadData];
}

- (void)creatButton{

    
    [_window makeKeyAndVisible];

}
- (void)viewDidLoad {
    [super viewDidLoad];
//     [self performSelector:@selector(creatButton) withObject:nil afterDelay:1];
    // Do any additional setup after loading the view, typically from a nib.
    
   
    [self.view addSubview:self.codeTableView];
    self.isExpanding = NO;
    
    // 主按钮
    self.mainBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, SCREEN_HEIGHT-84, 35, 35)];
    [self.mainBtn setBackgroundImage:[UIImage imageNamed:@"submit_pressed"] forState:UIControlStateNormal];
    //self.mainBtn.transform = CGAffineTransformMakeRotation(- M_PI*(45)/180.0);
    [self.mainBtn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mainBtn];
    
    CGPoint buttonCenter = CGPointMake(self.mainBtn.frame.size.width / 2.0f, self.mainBtn.frame.size.height / 2.0f);
    CGPoint labelCenter = CGPointMake(self.mainBtn.frame.size.width / 2.0f-35, self.mainBtn.frame.size.height / 2.0f);
    
    // 弹出的按钮
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"submit_pressed"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Tap) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setCenter:buttonCenter];
    [btn1 setAlpha:0.0f];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"sumitmood"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Tap) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setCenter:buttonCenter];
    [btn2 setAlpha:0.0f];
    [self.view addSubview:btn2];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    lab1.text = @"App通知";
    lab1.font = [UIFont systemFontOfSize:10];
    lab1.backgroundColor = [UIColor redColor];
    [lab1 setCenter:labelCenter];
    [lab1 setAlpha:0.0f];
    [self.view addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    lab2.text = @"短信通知";
    lab2.font = [UIFont systemFontOfSize:10];
    lab2.backgroundColor = [UIColor redColor];
    [lab2 setCenter:labelCenter];
    [lab2 setAlpha:0.0f];
    [self.view addSubview:lab2];
    self.buttonArray = [NSArray arrayWithObjects:btn2, btn1, nil];
    self.labelArray = [NSArray arrayWithObjects:lab2,lab1, nil];
}

/**
 *  关闭悬浮的window
 */
- (void)resignWindow
{
    
    [_window resignKeyWindow];
    _window = nil;
    
}

// 点击按钮1的响应
- (void)btn1Tap {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"旋转，跳跃，我闭着眼" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
}

- (UITableView *)codeTableView{

    if (!_codeTableView) {
        _codeTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        //注册一些cell
        [_codeTableView registerClass:NSClassFromString(@"TestCodeCell") forCellReuseIdentifier:@"TestCodeCell"];
        _codeTableView.dataSource = self;
        _codeTableView.delegate = self;
        //设置tableview ...
        
    }
    return _codeTableView;

}

// 点击按钮2的响应
- (void)btn2Tap {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"我睁开眼" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];

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
    float labelendX = x - 50;
    float labelendY = y-20;
    for (int i = 0; i < [self.buttonArray count]; ++i) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        
        // 最终坐标
        endY -= button.frame.size.height + 30.0f;
        endX += 0.0f;
        NSLog(@"buttonx=======%f,buttonY====%f",endX,endY);
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
    for (int i = 0; i < [self.labelArray count]; ++i) {
        UILabel *label = [self.labelArray objectAtIndex:i];
        // 最终坐标
        labelendY -= label.frame.size.height + 30.0f;
        labelendX += 0.0f;
        NSLog(@"labelx=======%f,labelY====%f",endX,endY);
        // 反弹坐标
        float labelfarY = labelendY - 30.0f;
        float labelfarX = labelendX - 0.0f;
        float labelnearY = labelendY + 15.0f;
        float labelnearX = labelendX + 0.0f;
        
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
        CGPathAddLineToPoint(path, NULL, labelfarX , labelfarY);
        CGPathAddLineToPoint(path, NULL, labelnearX, labelnearY);
        CGPathAddLineToPoint(path, NULL, labelendX, labelendY);
        [positionAnimation setPath: path];
        CGPathRelease(path);
        [animationOptions addObject:positionAnimation];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        [animationGroup setAnimations: animationOptions];
        [animationGroup setDuration:0.4f];
        [animationGroup setFillMode: kCAFillModeForwards];
        [animationGroup setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        
        NSDictionary *properties = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:label, [NSValue valueWithCGPoint:CGPointMake(labelendX, labelendY)], animationGroup, nil] forKeys:[NSArray arrayWithObjects:@"view", @"center", @"animation", nil]];
        
        [self performSelector:@selector(_expand:) withObject:properties afterDelay:0.1f * ([self.labelArray count] - i)];
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
    for (int i = 0; i < [self.labelArray count]; ++i) {
        UILabel *label = [self.labelArray objectAtIndex:i];
        
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
        float y = [label center].y;
        float x = [label center].x;
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
        
        NSDictionary *properties = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:label, animationGroup, nil] forKeys:[NSArray arrayWithObjects:@"view", @"animation", nil]];
        [self performSelector:@selector(_close:) withObject:properties afterDelay:0.1f * ([self.labelArray count] - i)];
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

- (void)fetchData{
    //网络请求
    //假数据
    for (int i = 0; i<20; i++) {
        CodeModel *model = [[CodeModel alloc] init];
        model.name = @"Apple";
        model.old = @(10);
        model.fat = @(150);
        [self.testDataArray addObject:model];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.testDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCodeCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        
        mySwitch = [[ UISwitch alloc]init];
        
        cell.accessoryView = mySwitch;
        SwitchStatus = @"SwitchStatus";
        
        BOOL status = [[NSUserDefaults standardUserDefaults] boolForKey:SwitchStatus];
        mySwitch.on = status;
        NSLog(@"初始化--------%d",mySwitch.on);
        [mySwitch addTarget:self action:@selector(switchStatusChanged:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:mySwitch];
        ;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }



    [self configureCell:cell forRowAtIndexPath:indexPath];

    return cell;
}

#pragma mark - SwitchValueChanged

- (void)switchStatusChanged:(UISwitch *)theSwitch
{
    if (theSwitch == mySwitch) {
        BOOL status = mySwitch.on;
        NSLog(@"开始点击方法时候的-----%d",status);
        [[NSUserDefaults standardUserDefaults] setObject:@(status) forKey:SwitchStatus];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
      
        if (self.block) {
            self.block(status);
        }
    }
    
}

- (void)configureCell:(TestCodeCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    cell.model = self.testDataArray[row];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

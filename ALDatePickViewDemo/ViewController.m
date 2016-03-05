//
//  ViewController.m
//  ALDatePickViewDemo
//
//  Created by Alvin on 16/3/5.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ViewController.h"
#import "ALSelfDefineDatePickerView.h"
@interface ViewController ()

@property (nonatomic, strong) ALSelfDefineDatePickerView *pickerView;

@end

@implementation ViewController

- (ALSelfDefineDatePickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[ALSelfDefineDatePickerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _pickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.width/2.0f-130, 200, 100, 50);
    [btn setTitle:@"周日历" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.tag = DateViewTypeWeek;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(self.view.width/2.0f+30, 200, 100, 50);
    [btn2 setTitle:@"月日历" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    btn2.tag = DateViewTypeMonth;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)btn
{
    self.pickerView.type = (DateViewType)btn.tag;
    [self.pickerView showAnimate:YES];
}

@end

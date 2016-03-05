//
//  ALWeekDatePickerView.m
//  BusinessScale
//
//  Created by Alvin on 15/12/25.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ALSelfDefineDatePickerView.h"

@interface ALSelfDefineDatePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL _animate;
    NSInteger _formerWeek;
    
    NSInteger _weeksSelectedRow;
    NSInteger _yearRow;
    NSInteger _monthRow;
}
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSMutableArray *month;
@property (nonatomic, strong) NSMutableArray *weekdays;

@property (nonatomic, copy) NSDate *selectedMonth;


@end

@implementation ALSelfDefineDatePickerView

- (NSMutableArray *)years
{
    if (!_years) {
        _years = [NSMutableArray array];
        for (int i = 0; i<200; i++) {
            NSString *string = [NSString stringWithFormat:@"%i年",i+1970];
            [_years addObject:string];
        }
    }
    return _years;
}

- (NSMutableArray *)month
{
    if (!_month) {
        _month = [NSMutableArray array];
        for (int i = 1; i<13; i++) {
            [_month addObject:[NSString stringWithFormat:@"%i月",i]];
        }
    }
    return _month;
}

- (NSMutableArray *)weekdays
{
    if (!_weekdays) {
        _weekdays = [NSMutableArray array];
    }
    return _weekdays;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        _currentDate = [NSDate date];
        _selectedMonth = [NSDate dateWithYear:_currentDate.year Month:_currentDate.month Day:1];
        _weeksSelectedRow = _currentDate.weekLevel;
        _formerWeek = _weeksSelectedRow;
    }
    return self;
}

- (void)setup
{
    _backGroundView = [[UIView alloc]initWithFrame:self.bounds];
    _backGroundView.backgroundColor = [UIColor blackColor];
    _backGroundView.alpha = 0.4;
    _backGroundView.tag = ALWeekDatePickerView_canleTag;
    _backGroundView.userInteractionEnabled = YES;
    [_backGroundView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)]];
    [self addSubview:_backGroundView];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-50, 10, 100, 20)];
    title.text = @"编辑日期";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [self colorWithHexString:@"91be46"];
    title.font = [UIFont boldSystemFontOfSize:17];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = ALWeekDatePickerView_canleTag;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[self colorWithHexString:@"91be46"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(10, 12, 40, 15);
    
    UIButton *widthCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [widthCancle addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    widthCancle.tag = ALWeekDatePickerView_canleTag;
    widthCancle.frame = CGRectMake(0, 0, 80, 40);
    //
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.tag = ALWeekDatePickerView_confirmTag;
    saveBtn.frame = CGRectMake(screenWidth-60, 12, 40, 15);
    [saveBtn setTitleColor:[self colorWithHexString:@"91be46"] forState:UIControlStateNormal];
    [saveBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    UIButton *widthSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [widthSave addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    widthSave.tag = ALWeekDatePickerView_confirmTag;
    widthSave.frame = CGRectMake(screenWidth-80, 0, 80, 40);
    
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, screenWidth, 40)];
    _titleView.backgroundColor = [self colorWithHexString:@"f8f8f8"];
    [_titleView addSubview:title];
    [_titleView addSubview:saveBtn];
    [_titleView addSubview:cancelBtn];
    [_titleView addSubview:widthCancle];
    [_titleView addSubview:widthSave];
    
    UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, screenWidth,200)];
    picker.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    picker.dataSource = self;
    self.picker = picker;
    picker.showsSelectionIndicator = YES;
    [self addSubview:picker];
    [self addSubview:_titleView];
}

- (void)btnClick:(UIButton *)btn
{
    _selectedMonth = [NSDate dateWithYear:[_years[_yearRow] integerValue] Month:[_month[_monthRow] integerValue] Day:1];
    if (btn.tag == ALWeekDatePickerView_confirmTag) {
        if (self.type == DateViewTypeMonth) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(monthPickCallBackDate:)]) {
                [self.delegate monthPickCallBackDate:[NSDate dateWithYear:[_years[_yearRow] integerValue] Month:[_month[_monthRow]integerValue] Day:1]];
                _currentDate = [NSDate dateWithYear:[_years[_yearRow] integerValue] Month:[_month[_monthRow]integerValue] Day:1];
            }
        }else if (self.type == DateViewTypeWeek){
            if (self.delegate && [self.delegate respondsToSelector:@selector(weekPickCallBackBeginDate:endDate:)]) {
                NSDate *beginDate = [_selectedMonth beginDateByWeekLevel:_weeksSelectedRow];
                _currentDate = beginDate;
                NSDate *endDate = [_selectedMonth endDateByWeekLevel:_weeksSelectedRow];
                [self.delegate weekPickCallBackBeginDate:beginDate endDate:endDate];
            }
        }
    }
    [self hide];
}

- (void)tapClick
{
    [self hide];
}

#pragma mark -publicMethods

- (void)showAnimate:(BOOL)animate
{
    [[[[UIApplication sharedApplication]windows]lastObject] addSubview:self];
    _animate = animate;
    [self initializePickerRow];
    void (^block)() = ^{
        _titleView.y = self.height-200-40;
        self.picker.y = self.height-200;
    };
    if (!animate) {
        block();
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        block();
    }];
}
#pragma mark -初始化 时间选择器当前选择时间
- (void)initializePickerRow
{
    [self.picker reloadAllComponents];
    for (NSInteger i = 0; i<_years.count; i++) {
        if (_currentDate.year == [_years[i] integerValue]) {
            _yearRow = i;
            break;
        }
    }
    for (NSInteger i = 0; i<_month.count; i++) {
        if (_currentDate.month == [_month[i] integerValue]) {
            _monthRow = i;
            break;
        }
    }
    [self.picker selectRow:_yearRow inComponent:0 animated:NO];
    [self.picker selectRow:_monthRow inComponent:1 animated:NO];
    if (self.type == DateViewTypeWeek) {
        [self.picker selectRow:_weeksSelectedRow inComponent:2 animated:NO];
        [self caculateselectedMonthWeeks];
    }
}

- (void)hide
{
    void (^block)() = ^{
        _titleView.y = self.height;
        self.picker.y = self.height;
    };
    if (!_animate) {
        block();
        [self removeFromSuperview];
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        block();
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -pickerDele&&DataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.type == DateViewTypeMonth) {
        return 2;
    }
    return 3;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (!component) {
        return self.years.count;
    }else if (component == 1){
        return self.month.count;
    }
    return self.weekdays.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
    label.font = [UIFont systemFontOfSize:21];
    void (^block)() = ^{
        if (self.type == DateViewTypeWeek) {
            [self.weekdays removeAllObjects];
            [self caculateselectedMonthWeeks];
        }
    };
    if (!component) {
        _yearRow = row;
        NSInteger year = [self.years[_yearRow] integerValue];
        NSInteger nowRow = 0;
        for (NSInteger i = 0; i<_years.count; i++) {
            if ([NSDate date].year == [_years[i] integerValue]) {
                nowRow = i;
                break;
            }
        }
        if(year>=nowRow){
            if ([self currentDateIsLaterThanNow]) {
                _monthRow = [NSDate date].month-1;
                _weeksSelectedRow = 0;
                _yearRow = nowRow;
                [self.picker selectRow:nowRow inComponent:0 animated:YES];
                [self.picker selectRow:_monthRow inComponent:1 animated:YES];
                [self pickerView:self.picker didSelectRow:_monthRow inComponent:1];
            }
        }
        block();
    }else if (component == 1){
        _monthRow = row;
        NSInteger now = [NSDate date].month;
        if ([self currentDateIsLaterThanNow]) {
            _monthRow = now-1;
            _weeksSelectedRow = 0;
            [self.picker selectRow:now-1 inComponent:1 animated:YES];
        }
        block();
    }else{
        _formerWeek = _weeksSelectedRow;
        _weeksSelectedRow = row;
        if ([self currentDateIsLaterThanNow]) {
            [self.picker selectRow:_formerWeek inComponent:2 animated:YES];
            _weeksSelectedRow = _formerWeek;
        }
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:21];
    label.textColor = [UIColor blackColor];
    NSString *string = nil;
    if (!component) {
        string = self.years[row];
    }else if (component == 1){
        string = self.month[row];
    }else{
        NSArray *arr = self.weekdays[row];
        NSDate *weekFirstDate = [arr firstObject];
        NSDate *weekEndDate = [arr lastObject];
        NSString *weekFirstStr = [NSString stringWithFormat:@"%02d.%02d",(int)weekFirstDate.month,(int)weekFirstDate.day];
        NSString *weekEndStr = [NSString stringWithFormat:@"%02d.%02d",(int)weekEndDate.month,(int)weekEndDate.day];
        string = [NSString stringWithFormat:@"%@~%@",weekFirstStr,weekEndStr];
    }
    label.text = string;
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.type == DateViewTypeWeek) {
        if (component == 0) {
            return screenWidth*6.0f/20.0f;
        }
        if (component == 2) {
            return screenWidth*5.f/10.0f;
        }
        return screenWidth*4.0f/20.0f;
    }
    return screenWidth/3.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35.0f;
}

#pragma mark -Caculate monthTotalWeeks
- (void)caculateselectedMonthWeeks
{
    NSDate *weekFirstDate = nil;
    NSDate *weekEndDate = nil;
    _selectedMonth = [NSDate dateWithYear:[_years[_yearRow] integerValue] Month:[_month[_monthRow] integerValue] Day:1];
    NSInteger weeks = [_selectedMonth numberOfWeeksInCurrentMonth];
    for (NSInteger i = 0; i<weeks; i++) {
        weekFirstDate = [_selectedMonth beginDateByWeekLevel:i];
        weekEndDate = [_selectedMonth endDateByWeekLevel:i];
        [self.weekdays addObject:@[weekFirstDate,weekEndDate]];
    }
    [self.picker reloadComponent:2];
    [self.picker selectRow:_weeksSelectedRow inComponent:2 animated:YES];
    
}

- (NSDate *)currentDate
{
    if (self.type == DateViewTypeWeek) {
        return [_selectedMonth beginDateByWeekLevel:_weeksSelectedRow];
    }
    return [NSDate dateWithYear:[_years[_yearRow] integerValue] Month:[_month[_monthRow]integerValue] Day:1];
}

#pragma mark - compareDateWithNow
- (BOOL)currentDateIsLaterThanNow
{
    NSInteger year = [self.years[_yearRow] integerValue];
    NSInteger month = [self.month[_monthRow] integerValue];
    if (self.type == DateViewTypeMonth) {
        return year>[NSDate date].year||(year==[NSDate date].year&&month>[NSDate date].month);
    }else{
        return year>[NSDate date].year||(year==[NSDate date].year&&month>[NSDate date].month)||(year==[NSDate date].year&&month==[NSDate date].month&&_weeksSelectedRow>[NSDate date].weekLevel);
    }
}

- (UIColor *)colorWithHexString: (NSString *)color
{
    if (![color isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


@end

//
//  ALSelfDefineDatePickerView.h
//  BusinessScale
//
//  Created by Alvin on 15/12/25.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"
#import "NSDate+Category.h"

#define screenWidth ([UIScreen mainScreen].bounds.size.width)
#define screenHeight ([UIScreen mainScreen].bounds.size.height)

typedef NS_ENUM(NSInteger, ALSelfDefineDatePickerViewTag){
    ALWeekDatePickerView_canleTag = 0,
    ALWeekDatePickerView_confirmTag
};

typedef NS_ENUM(NSInteger , DateViewType) {
    DateViewTypeWeek = 0,
    DateViewTypeMonth,
};

@class ALSelfDefineDatePickerView;
@protocol ALSelfDefineDatePickerViewDelegate <NSObject>

- (void)monthPickCallBackDate:(NSDate *)date;
- (void)weekPickCallBackBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;

@end

@interface ALSelfDefineDatePickerView : UIView
{
    @private
    NSDate *_currentDate;
}
@property (nonatomic, assign) DateViewType type;
@property (nonatomic, weak) UIPickerView *picker;
@property (nonatomic, readonly,copy) NSDate *currentDate;
@property (nonatomic, weak) id<ALSelfDefineDatePickerViewDelegate> delegate;

- (void)showAnimate:(BOOL)animate;

@end

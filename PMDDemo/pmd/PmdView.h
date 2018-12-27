//
//  PmdView.h
//  Pmd
//
//  Created by bamq on 2018/11/7.
//  Copyright © 2018年 bamq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PmdView : UIView
///font
@property(nonatomic,strong)UIFont *font;
///color
@property(nonatomic,strong)UIColor *textColor;
///数据源
@property(nonatomic,copy)NSArray <NSString *>*dataSource;
///速度,默认0.5
@property(nonatomic,assign)CGFloat speed;
///间隔,默认20
@property(nonatomic,assign)CGFloat space;
-(void)startMarquee;
-(void)stopMarquee;
@end

NS_ASSUME_NONNULL_END

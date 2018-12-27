//
//  PmdCell.m
//  Pmd
//
//  Created by bamq on 2018/11/7.
//  Copyright © 2018年 bamq. All rights reserved.
//

#import "PmdCell.h"
@implementation PmdCell
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        _tLabel =[[UILabel alloc] init];
        [self.contentView addSubview:_tLabel];

        self.tLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *v =  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tLabel]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_tLabel)];
        NSArray *h =  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tLabel]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_tLabel)];
        [self.contentView addConstraints:v];
        [self.contentView addConstraints:h];
        _tLabel.font = [UIFont systemFontOfSize:14];
        _tLabel.textColor = [UIColor blackColor];
    }
    return self;
}
@end

//
//  LeftView.m
//  ZLSwipeViewController
//
//  Created by zhaoliang chen on 2017/11/8.
//  Copyright © 2017年 zhaoliang chen. All rights reserved.
//

#import "LeftView.h"
#import "Masonry.h"

@implementation LeftView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        UILabel* label = [[UILabel alloc]init];
        label.text = @"子页面";
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
    }
    return self;
}

@end

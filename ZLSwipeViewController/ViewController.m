//
//  ViewController.m
//  ZLSwipeViewController
//
//  Created by zhaoliang chen on 2017/11/8.
//  Copyright © 2017年 zhaoliang chen. All rights reserved.
//

#import "ViewController.h"
#import "LeftView.h"
#import "Masonry.h"

typedef enum{
    LEFT,
    RIGHT,
}ViewDirection;

@interface ViewController ()
{
    CGPoint oldPoint;           //老点
    CGPoint newPoint;           //新点
    CGPoint tranDirectionPoint; //改变方向时候的点
    CGPoint localPoint;
    ViewDirection oldDirection; //老的方向
    ViewDirection newDirection; //新的方向
    int number;
    BOOL transDirection;        //是否转向
    BOOL isBackView;            //是否在主页面
    BOOL isDragSub;             //是否拖动副页面
}

@property(nonatomic,strong)LeftView *leftView;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel* label = [[UILabel alloc]init];
    label.text = @"主页面";
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_left).offset(60);
        make.height.top.mas_equalTo(self.view);
        make.width.mas_equalTo(300);
    }];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
    [self.view addGestureRecognizer:panGes];
    
    isBackView = YES;
    isDragSub = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 手势的识别
- (void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        oldPoint = [gestureRecognizer locationInView:self.view];
        localPoint = oldPoint;
        number = 0;
        transDirection = FALSE;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        newPoint = [gestureRecognizer locationInView:self.view];
        newPoint.y = localPoint.y;
        int displacement = 0;
        if (CGRectContainsPoint(_leftView.frame, oldPoint)) {
            displacement = newPoint.x - oldPoint.x;
            if (displacement < 0) {
                if (number == 0) {
                    oldDirection = LEFT;
                    number = 1;
                }
                newDirection = LEFT;
            } else if (displacement > 0) {
                if (number == 0) {
                    oldDirection = RIGHT;
                    number = 1;
                }
                newDirection = RIGHT;
            }
            if (newDirection != oldDirection) {
                tranDirectionPoint = oldPoint;
                oldDirection = newDirection;
                transDirection = TRUE;
            }
            CGFloat newX = self.leftView.frame.origin.x + displacement;
            if (newX > 0) {
                newX = 0;
            }
            if (newX < 60 - self.leftView.frame.size.width) {
                newX = 60 - self.leftView.frame.size.width;
            }
            [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(newX);
                make.top.height.mas_equalTo(self.view);
                make.width.mas_equalTo(300);
            }];
            [self.view layoutIfNeeded];
            oldPoint = newPoint;
            isDragSub = YES;
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //if (CGRectContainsPoint(self.leftView.frame, oldPoint)) {
        if (isDragSub == YES) {
            int displacement = 0;
            if (!transDirection) {
                displacement = fabs(newPoint.x - localPoint.x);
            } else {
                displacement = fabs(newPoint.x - tranDirectionPoint.x);
            }
            if (displacement < 50) {
                if (isBackView) {
                    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(self.view.mas_left).offset(60);
                        make.height.top.mas_equalTo(self.view);
                        make.width.mas_equalTo(300);
                    }];
                    [UIView animateWithDuration:0.2 animations:^{
                        [self.view layoutIfNeeded];
                    }];
                    isBackView = YES;
                } else {
                    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.view);
                        make.height.top.mas_equalTo(self.view);
                        make.width.mas_equalTo(300);
                    }];
                    [UIView animateWithDuration:0.2 animations:^{
                        [self.view layoutIfNeeded];
                    }];
                    isBackView = NO;
                }
            } else {
                if (newDirection == LEFT) {
                    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(self.view.mas_left).offset(60);
                        make.height.top.mas_equalTo(self.view);
                        make.width.mas_equalTo(300);
                    }];
                    [UIView animateWithDuration:0.2 animations:^{
                        [self.view layoutIfNeeded];
                    }];
                    isBackView = YES;
                } else {
                    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(self.view);
                        make.height.top.mas_equalTo(self.view);
                        make.width.mas_equalTo(300);
                    }];
                    [UIView animateWithDuration:0.2 animations:^{
                        [self.view layoutIfNeeded];
                    }];
                    isBackView = NO;
                }
            }
            isDragSub = NO;
        }
    }
    //}
}

- (LeftView*)leftView {
    if (!_leftView) {
        _leftView = [[LeftView alloc]initWithFrame:CGRectZero];
    }
    return _leftView;
}


@end

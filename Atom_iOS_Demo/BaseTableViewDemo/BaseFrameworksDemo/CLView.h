//
//  CLView.h
//  AlertDemo
//
// Created by 齐翠丽 on 17/3/16.
//  Copyright © 2017年 RG. All rights reserved
//
#import <UIKit/UIKit.h>




@protocol CLViewDelegate <NSObject>

- (void)ClickedCommitButtonWithMoneyString:(NSString *)string;

@end

@interface CLView : UIView<UITextFieldDelegate>
+(instancetype)initclview;
@property(nonatomic,assign)id<CLViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;

@end

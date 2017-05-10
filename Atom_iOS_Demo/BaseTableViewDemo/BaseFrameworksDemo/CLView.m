//
//  CLView.m
//  AlertDemo
//
// Created by 齐翠丽 on 17/3/16.
//  Copyright © 2017年 RG. All rights reserved
//

#import "CLView.h"
#import "KGModal.h"

@implementation CLView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 3;
    self.clipsToBounds = YES;
    
    self.commitButton.layer.cornerRadius = 17.0f;
    self.commitButton.clipsToBounds = YES;
    self.moneyTextField.delegate = self;
}
+(instancetype)initclview;

{
 
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CLView class]) owner:nil options:nil].firstObject;
}
- (IBAction)commitButtonAction:(UIButton *)sender {
    if (!self.moneyTextField.text.length) {
        return;
    }
    if ([self.moneyTextField.text doubleValue] < 0.01) {
        return;
    }


    if ([self.delegate respondsToSelector:@selector(ClickedCommitButtonWithMoneyString:)]) {
        [self.delegate ClickedCommitButtonWithMoneyString:self.moneyTextField.text];
    }
    [self endEditing:YES];
    [[KGModal sharedInstance]hide];

}


- (IBAction)closeButtonAction:(UIButton *)sender {
    [[KGModal sharedInstance]hide];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    if ([string isEqualToString:@"\n"]) {
    //        return YES;
    //    }
    NSString *toBeStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeStr intValue]>10000) {
        return NO;
    }
//    if ([toBeStr floatValue] <0.001) {
//        return NO;
//    }
    
    NSLog(@"string = %@",toBeStr);
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

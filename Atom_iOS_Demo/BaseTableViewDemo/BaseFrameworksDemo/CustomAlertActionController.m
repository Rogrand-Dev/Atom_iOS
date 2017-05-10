//
//  CustomAlertActionController.m
//  AFN-DEMO
//
//  Created by 齐翠丽 on 17/2/22.
//  Copyright © 2017年 齐翠丽. All rights reserved.
//

#import "CustomAlertActionController.h"
#import <objc/runtime.h>
@implementation CustomAlertAction

//按钮标题的字体颜色
-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertAction class], &count);
    for(int i =0;i < count;i ++){
        
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        
        if ([ivarName isEqualToString:@"_titleTextColor"]) {
            
            [self setValue:textColor forKey:@"titleTextColor"];
        }
    }
}


@end
@interface CustomAlertActionController ()

@end

@implementation CustomAlertActionController

- (void)viewDidLoad {
    [super viewDidLoad];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertController class], &count);
    for(int i = 0;i < count;i ++){
        
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        
        //标题颜色
        if ([ivarName isEqualToString:@"_attributedTitle"] && self.title && self.titleColor) {
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.title attributes:@{NSForegroundColorAttributeName:self.titleColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0]}];
            [self setValue:attr forKey:@"attributedTitle"];
        }
        
        //描述颜色
        if ([ivarName isEqualToString:@"_attributedMessage"] && self.message && self.messageColor) {
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.message attributes:@{NSForegroundColorAttributeName:self.messageColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
            [self setValue:attr forKey:@"attributedMessage"];
        }
    }
    
    //按钮统一颜色
    if (self.tintColor) {
        for (CustomAlertAction *action in self.actions) {
            if (!action.textColor) {
                action.textColor = self.tintColor;
            }
        }
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

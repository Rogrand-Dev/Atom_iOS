//
//  CustomAlertActionController.h
//  AFN-DEMO
//
//  Created by 齐翠丽 on 17/2/22.
//  Copyright © 2017年 齐翠丽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertAction : UIAlertAction
@property(nonatomic,strong)UIColor * textColor;//按钮的title字体的颜色

@end
@interface CustomAlertActionController : UIAlertController
@property(nonatomic,strong)UIColor * tintColor;//统一按钮样式
@property (nonatomic,strong) UIColor *titleColor; /**< 标题的颜色 */
@property (nonatomic,strong) UIColor *messageColor; /**< 信息的颜色 */

@end

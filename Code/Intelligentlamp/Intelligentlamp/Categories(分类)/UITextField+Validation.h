//
//  UITextField+Validation.h
//  Intelligentlamp
//
//  Created by L on 16/8/21.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    VALIDATION_TYPE_NORMAL=0,//屏蔽特殊字符
    VALIDATION_TYPE_NUM_VALIDATED = 1,//数字
    VALIDATION_TYPE_ID_CARD_VALIDATED = 2,//身份证
    VALIDATION_TYPE_MOBILE_PHONE_VALIDATED = 3,//手机号
    VALIDATION_TYPE_EMAIL_VALIDATED = 4,//email
    VALIDATION_TYPE_PASSWORD_VALIDATED = 5,//密码
    VALIDATION_TYPE_CREDITCARD_VALIDATED //creditcard
} ValidationType;
typedef void (^TextFieldBlock) (float textFieldNum);
@interface UITextField (Validation)

@property (nonatomic , copy) TextFieldBlock textFieldBlock;/*投票选项内容Block*/

-(void)setValidationType:(ValidationType)validationType;

-(NSString *)errorMessage;

- (void)limitTextLength:(int)length;

-(void)limitTextNoSpecialChars;

//检查电话
- (BOOL)checkPhone;
//检查密码
- (BOOL)checkPassword;
//检查检查验证码
- (BOOL)checkValidateCode;
@end

//
//  UITextField+Validation.m
//  Intelligentlamp
//
//  Created by L on 16/8/21.
//  Copyright © 2016年 L. All rights reserved.
//

#import "UITextField+Validation.h"

#import <objc/objc.h>
#import <objc/runtime.h>
static NSString *kLimitTextMaxLengthKey = @"kLimitTextMaxLengthKey";
static NSString *kLimitTextErrorMessageKey = @"kLimitTextErrorMessageKey";
static NSString *kTextFieldBlock = @"TextFieldBlock";
@implementation UITextField (Validation)

-(void)resetTextfieldValidation
{
    objc_setAssociatedObject(self, (__bridge  const void *)(kLimitTextErrorMessageKey), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)setValidationType:(ValidationType)validationType
{
    [self addTarget:self action:@selector(resetTextfieldValidation) forControlEvents:UIControlEventEditingDidBegin];
    if (validationType == VALIDATION_TYPE_NUM_VALIDATED) {
        [self limitTextOnlyNumber];
    }else if(validationType == VALIDATION_TYPE_EMAIL_VALIDATED){
        [self limitTextOnlyEmail];
    }else if(validationType == VALIDATION_TYPE_MOBILE_PHONE_VALIDATED){
        [self limitTextOnlyPhone];
    }else if(validationType == VALIDATION_TYPE_NORMAL){
        [self limitTextNoSpecialChars];
    }else if(validationType == VALIDATION_TYPE_ID_CARD_VALIDATED){
        [self limitTextOnlyIDCard];
    }else if(validationType == VALIDATION_TYPE_CREDITCARD_VALIDATED){
        [self limitTextOnlyCreditCard];
    }
    else if(validationType == VALIDATION_TYPE_PASSWORD_VALIDATED){
        [self limitTextPassword];
    }
    [self limitTextNoSpace];
}

-(NSString *)errorMessage
{
    NSString *str= objc_getAssociatedObject(self, (__bridge  const void *)(kLimitTextErrorMessageKey));
    if (str) {
        return str;
    }
    return nil;
}

#pragma mark - Limit Text PassWord
-(void)limitTextPassword
{
    [self addTarget:self action:@selector(textFieldTextPasswordLimit:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldTextPasswordLimit:(id)sender
{
    [self limitTextLength:12];
}

#pragma mark - Limit Text Length
- (void)limitTextLength:(int)length
{
    objc_setAssociatedObject(self, (__bridge  const void *)(kLimitTextMaxLengthKey), [NSNumber numberWithInt:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextLengthLimit:(id)sender
{
    NSNumber *maxLengthNumber = objc_getAssociatedObject(self, (__bridge  const void *)(kLimitTextMaxLengthKey));
    int maxLength = [maxLengthNumber intValue];
    if(self.text.length > maxLength){
        
        self.text = [self.text substringToIndex:maxLength];
    }else{
        if (self.textFieldBlock) {
            self.textFieldBlock(self.text.length);
        }
    }
}

#pragma mark - Limit Text Only Number
-(void)limitTextOnlyNumber
{
    [self addTarget:self action:@selector(textFieldTextNumberLimit:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldTextNumberLimit:(id)sender
{
    if (!self.text.length) {
        [self resetTextfieldValidation];
        return;
    }
    NSString * regexNum = @"^\\d*$";
    NSPredicate *regexNumPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexNum];
    if ([regexNumPredicate evaluateWithObject:self.text]==YES) {
    }else{
        self.text=[self.text substringFromIndex:self.text.length];
    }
}

#pragma mark - Limit Text Only Phone
-(void)limitTextOnlyPhone
{
    [self addTarget:self action:@selector(textFieldTextPhoneLimit:) forControlEvents:UIControlEventEditingDidEnd];
    [self limitTextLength:11];
    [self limitTextOnlyNumber];
}

- (void)textFieldTextPhoneLimit:(id)sender
{
    if (!self.text.length) {
        [self resetTextfieldValidation];
        return;
    }
    //    NSString * regex=@"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSString * regex=@"^1\\d{10}$";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([regexPredicate evaluateWithObject:self.text]==YES) {
        self.text=[self.text substringToIndex:self.text.length];
        [self resetTextfieldValidation];
    }else{
        self.text=[self.text substringToIndex:self.text.length];
        objc_setAssociatedObject(self, (__bridge  const void *)(kLimitTextErrorMessageKey), @"请输入正确的手机号码", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
#pragma mark - Limit Text For Email
-(void)limitTextOnlyEmail
{
    [self addTarget:self action:@selector(textFieldTextForEmailLimit:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)textFieldTextForEmailLimit:(id)sender
{
    if (!self.text.length) {
        [self resetTextfieldValidation];
        return;
    }
    NSString *regex=@"^[a-zA-Z0-9][\\w\\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\\w\\.-]*[a-zA-Z0-9]\\.[a-zA-Z][a-zA-Z\\.]*[a-zA-Z]$";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([regexPredicate evaluateWithObject:self.text]==YES) {
        [self resetTextfieldValidation];
    }else{
        objc_setAssociatedObject(self, (__bridge  const void *)(kLimitTextErrorMessageKey), @"邮箱格式错误", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
#pragma mark - Limit Text For IDCard
-(void)limitTextOnlyIDCard
{
    [self addTarget:self action:@selector(textFieldTextForIDCardLimit:) forControlEvents:UIControlEventEditingDidEnd];
    [self limitTextLength:18];
}

- (void)textFieldTextForIDCardLimit:(id)sender
{
    if (!self.text.length) {
        [self resetTextfieldValidation];
        return;
    }
    //NSString *regex=@"^(4\\d{12}(?:\\d{3})?)$";
    NSString *regex=@"^([1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3})|([1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X))$";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([regexPredicate evaluateWithObject:self.text]==YES) {
        [self resetTextfieldValidation];
    }else{
        objc_setAssociatedObject(self, (__bridge  const void *)(kLimitTextErrorMessageKey), @"身份证格式错误", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
#pragma mark - Limit Text For CreditCard
-(void)limitTextOnlyCreditCard
{
    [self addTarget:self action:@selector(textFieldTextForCreditCardLimit:) forControlEvents:UIControlEventEditingDidEnd];
    [self limitTextLength:16];
}

- (void)textFieldTextForCreditCardLimit:(id)sender
{
    if (!self.text.length) {
        [self resetTextfieldValidation];
        return;
    }
    NSString *regex=@"^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})$";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([regexPredicate evaluateWithObject:self.text]==YES) {
        [self resetTextfieldValidation];
    }else{
        objc_setAssociatedObject(self, (__bridge  const void *)(kLimitTextErrorMessageKey), @"请检查信用卡卡号是否输入正确", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
#pragma mark - Limit Text For SpecialChars
-(void)limitTextNoSpecialChars
{
    [self addTarget:self action:@selector(textFieldTextNoSpecialCharsLimit:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)textFieldTextNoSpecialCharsLimit:(UITextField*)sender
{
    if (!self.text.length) {
        [self resetTextfieldValidation];
        return;
    }
    if (![self hasSpecialChar:sender.text] ) {
        [self resetTextfieldValidation];
    }else{
        objc_setAssociatedObject(self, (__bridge  const void *)(kLimitTextErrorMessageKey), @"含有非法字符!", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
-(BOOL)hasSpecialChar:(NSString *)str
{
    /*
     [1] |（竖线符号）124
     [2] & （& 符号）38
     [3] ;（分号）59
     [4] $（美元符号）36
     [5] %（百分比符号）37
     [6] @（at 符号）64
     [7] '（单引号）39
     [8] ""（引号）34
     [9] \'（反斜杠转义单引号）92
     [10] \""（反斜杠转义引号）
     [11] <>（尖括号）60 62
     [12] ()（括号）40 41
     [13] +（加号）43
     [14] CR（回车符，ASCII 0x0d）13
     [15] LF（换行，ASCII 0x0a）10
     [16] ,（逗号）
     [17] \（反斜杠）" 92
     */
    
    const int specialCharNum=17;
    int specialChars[specialCharNum] ={124,38,59,36,37,64,39,34,92,60,62,40,41,43,10,13,92};
    
    for (int i=0;i<str.length;i++) {
        for(int j=0;j<specialCharNum;j++){
            if ( *[[str substringWithRange:NSMakeRange(i,1)] cStringUsingEncoding:NSUTF8StringEncoding] == specialChars[j]) {
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark - Limit Text NoSpace
- (void)limitTextNoSpace
{
    [self addTarget:self action:@selector(textFieldTextNoSpaceLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextNoSpaceLimit:(id)sender
{
    self.text = [self noSpaceString:self.text];
}
- (NSString *)noSpaceString:(NSString *)str
{
    if (str.length) {
        return  [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    }
    
    return str;
}

//检查电话
- (BOOL)checkPhone
{
    if ([self.text hasPrefix:@"1"] && self.text.length == 11) {
        return YES;
    }
    return NO;
}
//检查密码
- (BOOL)checkPassword
{
    NSString *regex=@"^[a-zA-Z0-9_]{6,12}$";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([regexPredicate evaluateWithObject:self.text]==YES) {
        return YES;
    }else{
        return NO;
    }
}
//检查检查验证码
- (BOOL)checkValidateCode
{
    if (self.text.length == 6 && self.text.length != 0) {
        return YES;
    }
    return NO;
}

//添加Block回调
-(void)setTextFieldBlock:(TextFieldBlock)textFieldBlock
{
    objc_setAssociatedObject(self, (__bridge  const void *)(kTextFieldBlock),textFieldBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(TextFieldBlock)textFieldBlock
{
    return objc_getAssociatedObject(self, (__bridge  const void *)(kTextFieldBlock));
}
@end

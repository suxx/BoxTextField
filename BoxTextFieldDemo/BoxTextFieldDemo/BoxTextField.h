//
//  BoxTextField.h
//  DaoJiaApp
//
//  Created by suxx on 16/11/2.
//
//

#import <UIKit/UIKit.h>

@protocol  BoxTextFieldDelegate<NSObject>
@optional
/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(NSString *)passWord;

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(NSString *)passWord;

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(NSString *)passWord;
@end


@interface BoxTextField : UIView <UIKeyInput>

@property (assign, nonatomic)  NSUInteger passWordNum;//密码的位数
@property (assign, nonatomic)  CGFloat squareWidth;//正方形的大小
@property (assign, nonatomic)  CGFloat space;//正方形的间距

@property (weak, nonatomic) id<BoxTextFieldDelegate> delegate;
@property (strong, nonatomic) NSMutableString *textStore;//保存密码的字符串

@end

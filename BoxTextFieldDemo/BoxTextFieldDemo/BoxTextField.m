//
//  BoxTextField.m
//  DaoJiaApp
//
//  Created by suxx on 16/11/2.
//
//

#import "BoxTextField.h"

@interface BoxTextField ()
{
    CAShapeLayer *shapLayer;
}
@property (strong, nonatomic) NSString *textNum;//当前输入的textNum
@end

@implementation BoxTextField
static NSString  * const MONEYNUMBERS = @"0123456789";

-(void)setDelegate:(id<BoxTextFieldDelegate>)delegate
{
    _delegate = delegate;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textStore = [NSMutableString string];
        self.passWordNum = 6;
        self.squareWidth = 65/2;
        self.space = 11;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    CGFloat x = (width - self.squareWidth*self.passWordNum-self.space*(self.passWordNum-1))/2.0;//box起始坐标x
    CGFloat y = (height - self.squareWidth)/2.0;
    CGContextRef context = UIGraphicsGetCurrentContext();

    //画框框
    for (int i = 0; i < self.passWordNum; i++) {
        CGContextAddRect(context, CGRectMake(x+(self.squareWidth+self.space)*i, y, self.squareWidth, self.squareWidth));
        CGContextSetLineWidth(context, 0.5);
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    //画数字
    for (int i = 0; i < self.textStore.length; i++) {
        NSString *textNum = [self.textStore substringWithRange:NSMakeRange(i, 1)];
        [textNum drawInRect:CGRectMake(x+11+(self.squareWidth+self.space)*i, y+6, self.squareWidth, self.squareWidth) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    //画光标
    if (!shapLayer) {
        shapLayer = [[CAShapeLayer alloc] init];
    }else
    {
        [shapLayer removeFromSuperlayer];
        shapLayer = nil;
        shapLayer = [[CAShapeLayer alloc] init];
    }
    if(self.textStore.length<6)
    {
        shapLayer.strokeColor = [UIColor blackColor].CGColor;
        shapLayer.lineWidth = 1.5;
        shapLayer.lineCap = @"round";
        
        UIBezierPath *bpath = [UIBezierPath bezierPath];
        [bpath moveToPoint:CGPointMake(x+16+(self.squareWidth+self.space)*self.textStore.length, y+6)];
        [bpath addLineToPoint:CGPointMake(x+16+(self.squareWidth+self.space)*self.textStore.length, y+25)];
        shapLayer.path = bpath.CGPath;
        [self.layer addSublayer:shapLayer];
        
        CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        expandAnimation.fromValue = @0;
        expandAnimation.toValue = @1;
        expandAnimation.duration = 0.5;
        expandAnimation.autoreverses = YES;//动画执行完回到原始值
        expandAnimation.removedOnCompletion = NO;
        expandAnimation.repeatCount = MAXFLOAT;//无限循环
        [shapLayer addAnimation:expandAnimation forKey:nil];
    }
}

//#pragma mark --- UIKeyInput
//用于显示的文本对象是否有任何文本
- (BOOL)hasText {
    return self.textStore.length > 0;
}

//插入文本
- (void)insertText:(NSString *)text
{
    if (self.textStore.length < self.passWordNum) {
    //判断是否是数字
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:MONEYNUMBERS] invertedSet];
        NSString*filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [text isEqualToString:filtered];
        if(basicTest) {
            self.textNum = text;
            [self.textStore appendString:text];
            if ([self.delegate respondsToSelector:@selector(passWordDidChange:)]) {
                [self.delegate passWordDidChange:self.textStore];
            }
            if (self.textStore.length == self.passWordNum) {
                if ([self.delegate respondsToSelector:@selector(passWordCompleteInput:)]) {
                    [self.delegate passWordCompleteInput:self.textStore];
                }
            }
            [self setNeedsDisplay];
        }
    }
}

/*删除文本
 */
- (void)deleteBackward {
    if (self.textStore.length > 0) {
        [self.textStore deleteCharactersInRange:NSMakeRange(self.textStore.length - 1, 1)];
        if ([self.delegate respondsToSelector:@selector(passWordDidChange:)]) {
            [self.delegate passWordDidChange:self.textStore];
        }
    }
    [self setNeedsDisplay];
}

/**
 *  设置键盘的类型
 */
- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder {
    if ([self.delegate respondsToSelector:@selector(passWordBeginInput:)]) {
        [self.delegate passWordBeginInput:self.textStore];
    }
    return [super becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}


@end

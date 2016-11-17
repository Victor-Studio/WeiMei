//
//  ZRUIWebView.m
//  WeiMei
//
//  Created by Victor Zhang on 11/13/16.
//  Copyright © 2016 com.xiaoruigege. All rights reserved.
//

#import "ZRWebView.h"
#import "ZRYouDaoDict.h"
#import "BDSSpeechSynthesizer.h"


@interface ZRWebView()<ZRYouDaoDictDelegate>

@property (nonatomic, strong) UILabel *originTextLabel;

@property (nonatomic, strong) UILabel *destinationTextLable0;
@property (nonatomic, strong) UILabel *destinationTextLable1;
@property (nonatomic, strong) UILabel *destinationTextLable2;

@property (nonatomic, strong) ZRYouDaoDict *youdaoDict;

@property (nonatomic, copy) NSString *selectionText; //选中的文本

@end

@implementation ZRWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIMenuItem *translation = [[UIMenuItem alloc] initWithTitle:@"翻译"action:@selector(translate:)];
        UIMenuItem *copying = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copying:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:translation, copying, nil]];
    }
    return self;
}

- (ZRYouDaoDict *)youdaoDict
{
    if (!_youdaoDict) {
        _youdaoDict = [[ZRYouDaoDict alloc] init];
        _youdaoDict.delegate = self;
    }
    return _youdaoDict;
}

- (UIView *)translateResultView
{
    if (!_translateResultView) {
        CGRect rect = [UIScreen mainScreen].bounds;
        CGFloat w = rect.size.width;
        CGFloat h = 90;
        CGFloat y = rect.size.height;
        _translateResultView = [[UIView alloc] initWithFrame:CGRectMake(0, y, w, h)];
        _translateResultView.backgroundColor = [UIColor whiteColor];
        _translateResultView.layer.shadowColor = [UIColor blackColor].CGColor;
        _translateResultView.layer.shadowOpacity = 0.3;
        _translateResultView.layer.shadowOffset = CGSizeMake(0, -6);
        _translateResultView.alpha = 0.f;
        [self addSubview:_translateResultView];
        
        CGFloat margin = 8;
        CGFloat topMargin = 0.3;
        CGFloat leftMargin = 33;
        
        UIFont *srcfont = [UIFont systemFontOfSize:15];
        UIFont *dstfont = [UIFont systemFontOfSize:13];
        
        //原文view
        CGFloat otW = w - margin * 2;
        CGFloat otH = 20;
        CGFloat otX = leftMargin;
        CGFloat otY = margin;
        UIView *originView = [[UIView alloc] initWithFrame:CGRectMake(otX, otY, otW, otH)];
        [_translateResultView addSubview:originView];
        
        //原文label + 美音发音
        UILabel *originLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, otW, otH)];
        originLabel.textColor = [UIColor blackColor];
        originLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:15];
        originLabel.userInteractionEnabled = YES;
        [originLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(americanPronounce:)]];
        [originView addSubview:originLabel];
        self.originTextLabel = originLabel;
        
        //英音发音
        //待开发
        
        
        
        //译文1
        CGFloat dtW = otW;
        CGFloat dtH = otH;
        CGFloat dtX = leftMargin;
        CGFloat dtY = otH + topMargin + margin;
        UILabel *destinationText0 = [[UILabel alloc] initWithFrame:CGRectMake(dtX, dtY, dtW, dtH)];
        destinationText0.textColor = [UIColor blackColor];
        destinationText0.font = dstfont;
        [_translateResultView addSubview:destinationText0];
        self.destinationTextLable0 = destinationText0;
        
        //译文2
        dtY += otH + topMargin;
        UILabel *destinationText1 = [[UILabel alloc] initWithFrame:CGRectMake(dtX, dtY, dtW, dtH)];
        destinationText1.textColor = [UIColor blackColor];
        destinationText1.font = dstfont;
        [_translateResultView addSubview:destinationText1];
        self.destinationTextLable1 = destinationText1;
        
        //译文3
        dtY += otH + topMargin;
        UILabel *destinationText2 = [[UILabel alloc] initWithFrame:CGRectMake(dtX, dtY, dtW, dtH)];
        destinationText2.textColor = [UIColor blackColor];
        destinationText2.font = dstfont;
        [_translateResultView addSubview:destinationText2];
        self.destinationTextLable2 = destinationText2;
        
        //操作面板
        //        CGFloat pcW = w - margin * 2;
        //        CGFloat pcH = 25;
        //        CGFloat pcX = margin;
        //        CGFloat pcY = h + 10;
        //        UIView *planeCtrl = [[UIView alloc] initWithFrame:CGRectMake(pcX, pcY, pcW, pcH)];
        //        planeCtrl.backgroundColor = [UIColor purpleColor];
        //        planeCtrl.layer.shadowColor = [UIColor clearColor].CGColor;
        //        planeCtrl.layer.shadowOpacity = 1.f;
        //        planeCtrl.layer.shadowOffset = CGSizeMake(0, 0);
        //        [_translateResultView addSubview:planeCtrl];
        
        //关闭按钮
        //        CGFloat cbW = pcW / 2;
        //        CGFloat cbX = margin;
        //        CGFloat cbH = pcH;
        //        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(cbX, 0, cbW, cbH)];
        //        [closeBtn setTitle:@"X 关闭" forState:UIControlStateNormal];
        //        closeBtn.backgroundColor = [UIColor redColor];
        //        closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        //        closeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        //        closeBtn.titleLabel.textColor = MainColorRed;
        //        [closeBtn addTarget:self action:@selector(closeResultPlane:) forControlEvents:UIControlEventTouchUpInside];
        //        [planeCtrl addSubview:closeBtn];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, h)];
        [closeBtn setTitle:@"C" forState:UIControlStateNormal];
        closeBtn.backgroundColor = [UIColor redColor];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        closeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        closeBtn.titleLabel.textColor = MainColorRed;
        [closeBtn addTarget:self action:@selector(closeResultPlane:) forControlEvents:UIControlEventTouchUpInside];
        [_translateResultView addSubview:closeBtn];
        
        
    }
    return _translateResultView;
}

#pragma mark 美音发音
- (void)americanPronounce:(UITapGestureRecognizer *)gesture
{
    NSString *text = self.selectionText;
    if (text.length <= 0) {
        return;
    }
    [self speakByWord:text];
}

- (void)speakByWord:(NSString *)word
{
    NSError* speakerr;
    NSInteger sentenceID = [[BDSSpeechSynthesizer sharedInstance] speakSentence:word withError:&speakerr];
    if (sentenceID == -1) {
        /*错误*/
        NSLog(@"百度语音合成错误！ error = %@", speakerr);
    }
}

//显示翻译面板
- (void)showResultPlane
{
    //    if ([self.translationDelegate respondsToSelector:@selector(showTranslationPlane)]) {
    //        [self.translationDelegate showTranslationPlane];
    //    }
    
    [UIView animateWithDuration:kResultingPlaneAnimationDuration animations:^{
        self.translateResultView.alpha = 1.f;
        CGRect rect = self.translateResultView.frame;
        rect.origin.y = self.frame.size.height - rect.size.height;
        self.translateResultView.frame = rect;
    }];
}

//关闭翻译面板
- (void)closeResultPlane:(UIButton *)button
{
    [UIView animateWithDuration:kResultingPlaneAnimationDuration animations:^{
        self.translateResultView.alpha = 0.f;
        CGRect rect = self.translateResultView.frame;
        rect.origin.y = self.frame.size.height;
        self.translateResultView.frame = rect;
    } completion:^(BOOL finished) {
        if (finished) {
            //            if ([self.translationDelegate respondsToSelector:@selector(hideTranslationPlane)]) {
            //                [self.translationDelegate hideTranslationPlane];
            //            }
        }
    }];
}

- (void)translate:(UIMenuItem *)menuItem
{

#if 0
    self.originTextLabel.text = [NSString stringWithFormat:@"Good   英音['ru:di]   美音['ru:di]"];
    self.destinationTextLable0.text = [NSString stringWithFormat:@"n. 好处；善行；慷慨的行为"];
    self.destinationTextLable1.text = [NSString stringWithFormat:@"adj. 好的；优良的；愉快的；虔诚的"];
    self.destinationTextLable2.text = [NSString stringWithFormat:@"adv. 好"];

#else
    
    NSString *selection = [self stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString();"];
    self.selectionText = selection;
    [self.youdaoDict translate:selection];
#endif
}

#pragma mark - ZRYouDaoDictDelegate
- (void)translationResult:(ZRYouDaoModel *)youdaoModel selectionText:(NSString *)selectionText
{
    //更新UI一定要放在主线程里，谨记！！！
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self showResultPlane];
        
        //调用前，先清空
        self.originTextLabel.text = @"";
        self.destinationTextLable0.text = @"";
        self.destinationTextLable1.text = @"";
        self.destinationTextLable2.text = @"";
        
        ZRYouDaoBasicModel *basic = youdaoModel.basic;
        if (!basic.us_phonetic) {
            self.originTextLabel.text = [NSString stringWithFormat:@"原文: %@", self.selectionText];
        } else {
            self.originTextLabel.text = [NSString stringWithFormat:@"%@   美音[%@]", self.selectionText, basic.us_phonetic];
        }
        
        if (basic.explains.count > 0) {
            int i = 0;
            for (NSString *explain in basic.explains) {
                ++i;
                switch (i) {
                    case 1:
                        self.destinationTextLable0.text = [NSString stringWithFormat:@"%@", explain];
                        break;
                    case 2:
                        self.destinationTextLable1.text = [NSString stringWithFormat:@"%@", explain];
                        break;
                    case 3:
                        self.destinationTextLable2.text = [NSString stringWithFormat:@"%@", explain];
                        break;
                    default:
                        break;
                }
            }
        } else {
            if (youdaoModel.translation.count > 0) {
                NSMutableString *directTranslation = [[NSMutableString alloc] init];
                for (NSString *ttxt in youdaoModel.translation) {
                    [directTranslation appendString:ttxt];
                }
                self.destinationTextLable0.text = [NSString stringWithFormat:@"%@", directTranslation];
            }
        }
    });
}

- (void)copying:(UIMenuItem *)menuItem
{
    NSString *selection = [self stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString();"];
    if (selection.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = selection;
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(translate:) ||
        action == @selector(copying:)) {
        return YES;
    }
    return NO;
}

@end


















@interface ZRWKWebView()<ZRYouDaoDictDelegate>

@property (nonatomic, strong) UILabel *originTextLabel;

@property (nonatomic, strong) UILabel *destinationTextLable0;
@property (nonatomic, strong) UILabel *destinationTextLable1;
@property (nonatomic, strong) UILabel *destinationTextLable2;

@property (nonatomic, strong) ZRYouDaoDict *youdaoDict;

@property (nonatomic, copy) NSString *selectionText;

@end

@implementation ZRWKWebView

- (ZRYouDaoDict *)youdaoDict
{
    if (!_youdaoDict) {
        _youdaoDict = [[ZRYouDaoDict alloc] init];
        _youdaoDict.delegate = self;
    }
    return _youdaoDict;
}

- (UIView *)translateResultView
{
    if (!_translateResultView) {
        CGRect rect = [UIScreen mainScreen].bounds;
        CGFloat w = rect.size.width;
        CGFloat h = 90;
        CGFloat y = rect.size.height;
        _translateResultView = [[UIView alloc] initWithFrame:CGRectMake(0, y, w, h)];
        _translateResultView.backgroundColor = [UIColor whiteColor];
        _translateResultView.layer.shadowColor = [UIColor blackColor].CGColor;
        _translateResultView.layer.shadowOpacity = 0.3;
        _translateResultView.layer.shadowOffset = CGSizeMake(0, -6);
        _translateResultView.alpha = 0.f;
        [self addSubview:_translateResultView];
        
        CGFloat margin = 8;
        CGFloat topMargin = 0.3;
        CGFloat leftMargin = 33;

//        UIFont *srcfont = [UIFont systemFontOfSize:15];
        UIFont *dstfont = [UIFont systemFontOfSize:13];
        
        //原文view
        CGFloat otW = w - margin * 2;
        CGFloat otH = 20;
        CGFloat otX = leftMargin;
        CGFloat otY = margin;
        UIView *originView = [[UIView alloc] initWithFrame:CGRectMake(otX, otY, otW, otH)];
        [_translateResultView addSubview:originView];
        
        //原文label + 美音发音
        UILabel *originLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, otW, otH)];
        originLabel.textColor = [UIColor blackColor];
        originLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [originLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(americanPronounce:)]];
        [originView addSubview:originLabel];
        self.originTextLabel = originLabel;
        
        //英音发音
        //待开发
        
        
        
        //译文1
        CGFloat dtW = otW;
        CGFloat dtH = otH;
        CGFloat dtX = leftMargin;
        CGFloat dtY = otH + topMargin + margin;
        UILabel *destinationText0 = [[UILabel alloc] initWithFrame:CGRectMake(dtX, dtY, dtW, dtH)];
        destinationText0.textColor = [UIColor blackColor];
        destinationText0.font = dstfont;
        [_translateResultView addSubview:destinationText0];
        self.destinationTextLable0 = destinationText0;
        
        //译文2
        dtY += otH + topMargin;
        UILabel *destinationText1 = [[UILabel alloc] initWithFrame:CGRectMake(dtX, dtY, dtW, dtH)];
        destinationText1.textColor = [UIColor blackColor];
        destinationText1.font = dstfont;
        [_translateResultView addSubview:destinationText1];
        self.destinationTextLable1 = destinationText1;
        
        //译文3
        dtY += otH + topMargin;
        UILabel *destinationText2 = [[UILabel alloc] initWithFrame:CGRectMake(dtX, dtY, dtW, dtH)];
        destinationText2.textColor = [UIColor blackColor];
        destinationText2.font = dstfont;
        [_translateResultView addSubview:destinationText2];
        self.destinationTextLable2 = destinationText2;
     
        //操作面板
//        CGFloat pcW = w - margin * 2;
//        CGFloat pcH = 25;
//        CGFloat pcX = margin;
//        CGFloat pcY = h + 10;
//        UIView *planeCtrl = [[UIView alloc] initWithFrame:CGRectMake(pcX, pcY, pcW, pcH)];
//        planeCtrl.backgroundColor = [UIColor purpleColor];
//        planeCtrl.layer.shadowColor = [UIColor clearColor].CGColor;
//        planeCtrl.layer.shadowOpacity = 1.f;
//        planeCtrl.layer.shadowOffset = CGSizeMake(0, 0);
//        [_translateResultView addSubview:planeCtrl];
        
        //关闭按钮
//        CGFloat cbW = pcW / 2;
//        CGFloat cbX = margin;
//        CGFloat cbH = pcH;
//        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(cbX, 0, cbW, cbH)];
//        [closeBtn setTitle:@"X 关闭" forState:UIControlStateNormal];
//        closeBtn.backgroundColor = [UIColor redColor];
//        closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        closeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        closeBtn.titleLabel.textColor = MainColorRed;
//        [closeBtn addTarget:self action:@selector(closeResultPlane:) forControlEvents:UIControlEventTouchUpInside];
//        [planeCtrl addSubview:closeBtn];
    
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, h)];
        [closeBtn setTitle:@"C" forState:UIControlStateNormal];
        closeBtn.backgroundColor = [UIColor redColor];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        closeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        closeBtn.titleLabel.textColor = MainColorRed;
        [closeBtn addTarget:self action:@selector(closeResultPlane:) forControlEvents:UIControlEventTouchUpInside];
        [_translateResultView addSubview:closeBtn];
        
        
    }
    return _translateResultView;
}


#pragma mark 美音发音
- (void)americanPronounce:(UITapGestureRecognizer *)gesture
{
    NSString *text = self.selectionText;
    if (text.length <= 0) {
        return;
    }
    [self speakByWord:text];
}

- (void)speakByWord:(NSString *)word
{
    NSError* speakerr;
    NSInteger sentenceID = [[BDSSpeechSynthesizer sharedInstance] speakSentence:word withError:&speakerr];
    if (sentenceID == -1) {
        /*错误*/
        NSLog(@"百度发声错误！ error = %@", speakerr);
    }
}

//显示翻译面板
- (void)showResultPlane
{
//    if ([self.translationDelegate respondsToSelector:@selector(showTranslationPlane)]) {
//        [self.translationDelegate showTranslationPlane];
//    }
    
    [UIView animateWithDuration:kResultingPlaneAnimationDuration animations:^{
        self.translateResultView.alpha = 1.f;
        CGRect rect = self.translateResultView.frame;
        rect.origin.y = self.frame.size.height - rect.size.height;
        self.translateResultView.frame = rect;
    }];
}

//关闭翻译面板
- (void)closeResultPlane:(UIButton *)button
{
    [UIView animateWithDuration:kResultingPlaneAnimationDuration animations:^{
        self.translateResultView.alpha = 0.f;
        CGRect rect = self.translateResultView.frame;
        rect.origin.y = self.frame.size.height;
        self.translateResultView.frame = rect;
    } completion:^(BOOL finished) {
        if (finished) {
//            if ([self.translationDelegate respondsToSelector:@selector(hideTranslationPlane)]) {
//                [self.translationDelegate hideTranslationPlane];
//            }
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIMenuItem *translation = [[UIMenuItem alloc] initWithTitle:@"翻译"action:@selector(translate:)];
        UIMenuItem *copying = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copying:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:translation, copying, nil]];
    }
    return self;
}

- (void)translate:(UIMenuItem *)menuItem
{
    
#if 0
    self.originTextLabel.text = [NSString stringWithFormat:@"Good   英音['ru:di]   美音['ru:di]"];
    self.destinationTextLable0.text = [NSString stringWithFormat:@"n. 好处；善行；慷慨的行为"];
    self.destinationTextLable1.text = [NSString stringWithFormat:@"adj. 好的；优良的；愉快的；虔诚的"];
    self.destinationTextLable2.text = [NSString stringWithFormat:@"adv. 好"];
    return;
#endif
    
    __weak typeof(self) SELF = self;
    [self evaluateJavaScript:@"window.getSelection().toString()" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        SELF.selectionText = value;
        [SELF.youdaoDict translate:value];
    }];
}

#pragma mark - ZRYouDaoDictDelegate
- (void)translationResult:(ZRYouDaoModel *)youdaoModel selectionText:(NSString *)selectionText
{
    
    //更新UI一定要放在主线程里，谨记！！！
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self showResultPlane];
        
        //调用前，先清空
        self.originTextLabel.text = @"";
        self.destinationTextLable0.text = @"";
        self.destinationTextLable1.text = @"";
        self.destinationTextLable2.text = @"";
        
        ZRYouDaoBasicModel *basic = youdaoModel.basic;
        if (!basic.us_phonetic) {
            self.originTextLabel.text = [NSString stringWithFormat:@"原文: %@", self.selectionText];
        } else {
            self.originTextLabel.text = [NSString stringWithFormat:@"%@   美音[%@]", self.selectionText, basic.us_phonetic];
        }
        
        if (basic.explains.count > 0) {
            int i = 0;
            for (NSString *explain in basic.explains) {
                ++i;
                switch (i) {
                    case 1:
                        self.destinationTextLable0.text = [NSString stringWithFormat:@"%@", explain];
                        break;
                    case 2:
                        self.destinationTextLable1.text = [NSString stringWithFormat:@"%@", explain];
                        break;
                    case 3:
                        self.destinationTextLable2.text = [NSString stringWithFormat:@"%@", explain];
                        break;
                    default:
                        break;
                }
            }
        }
   });
}

- (void)copying:(UIMenuItem *)menuItem
{
    [self evaluateJavaScript:@"window.getSelection().toString()" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        NSString *selection = value;
        if (selection.length > 0) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = value;
        }
    }];

}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(translate:) ||
        action == @selector(copying:)) {
        return YES;
    }
    return NO;
}

@end







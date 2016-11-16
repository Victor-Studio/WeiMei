//
//  ZRYouDaoDict.m
//  WeiMei
//
//  Created by Victor Zhang on 11/15/16.
//  Copyright © 2016 com.xiaoruigege. All rights reserved.
//


#import "ZRYouDaoDict.h"

#define YOUDAOFANYI(queryText) [NSString stringWithFormat:@"http://fanyi.youdao.com/openapi.do?keyfrom=weimeibrowser&key=543890898&type=data&doctype=json&version=1.1&q=%@", CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)queryText, NULL, NULL, kCFStringEncodingUTF8)]

@implementation ZRYouDaoBasicModel

@end

@implementation ZRYouDaoModel

- (void)setTranslation:(NSArray *)translation
{
    _translation = translation;
    
    NSMutableString *mstr = [[NSMutableString alloc] init];
    for (NSString *str in translation) {
        [mstr appendFormat:@"%@，", str];
    }
    if (mstr.length > 1) {
        self.translationStr = [mstr substringToIndex:mstr.length - 1];
    }
}

@end


@implementation ZRYouDaoDict

- (void)translate:(NSString *)queryText
{
    if (queryText.length <= 0) {
        return;
    }
    
    dispatch_queue_t getInterpretation_queue = dispatch_queue_create("com.victor.weimei.getinterpretation", NULL);
    dispatch_async(getInterpretation_queue, ^{
        NSURL *url = [NSURL URLWithString:YOUDAOFANYI(queryText)];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask * task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error = %@", error);
                return;
            }
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"Translation Result = %@", dict);
            
            ZRYouDaoModel *model = [[ZRYouDaoModel alloc] init];
            
            NSDictionary *tdic = dict[@"basic"];
            ZRYouDaoBasicModel *baseModel = [[ZRYouDaoBasicModel alloc] init];
            baseModel.explains = tdic[@"explains"];
            baseModel.phonetic = tdic[@"phonetic"];
            baseModel.uk_phonetic = tdic[@"uk-phonetic"];
            baseModel.us_phonetic = tdic[@"us-phonetic"];
            
            model.basic = baseModel;
            model.query = dict[@"query"];
            model.translation = dict[@"translation"];
            model.web = dict[@"web"];
           
            if ([self.delegate respondsToSelector:@selector(translationResult:selectionText:)]) {
                [self.delegate translationResult:model selectionText:queryText];
            }
        }];
        [task resume];
    });
}

@end


/*
 
 http://fanyi.youdao.com/openapi.do?keyfrom=weimeibrowser&key=543890898&type=data&doctype=json&version=1.1&q=good
 {
 "translation": [
 "好"
 ],
 "basic": {
 "us-phonetic": "ɡʊd",
 "phonetic": "gʊd",
 "uk-phonetic": "gʊd",
 "explains": [
 "n. 好处；善行；慷慨的行为",
 "adj. 好的；优良的；愉快的；虔诚的",
 "adv. 好",
 "n. (Good)人名；(英)古德；(瑞典)戈德"
 ]
 },
 "query": "good",
 "errorCode": 0,
 "web": [
 {
 "value": [
 "好",
 "善",
 "商品"
 ],
 "key": "Good"
 },
 {
 "value": [
 "公共物品",
 "公益事业",
 "公共财"
 ],
 "key": "public good"
 },
 {
 "value": [
 "굿 닥터",
 "Good Doctor (TV series)",
 "好医生"
 ],
 "key": "Good Doctor"
 }
 ]
 }
 
 */









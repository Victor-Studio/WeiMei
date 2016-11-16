//
//  ZRYouDaoDict.h
//  WeiMei
//
//  Created by Victor Zhang on 11/15/16.
//  Copyright © 2016 com.xiaoruigege. All rights reserved.
//  有道词典翻译

#import <Foundation/Foundation.h>



//模型2
@interface ZRYouDaoBasicModel : NSObject

@property (nonatomic, copy) NSString *us_phonetic;

@property (nonatomic, copy) NSString *phonetic;

@property (nonatomic, copy) NSString *uk_phonetic;

@property (nonatomic, strong) NSArray *explains;

@end


//模型1
@interface ZRYouDaoModel : NSObject

@property (nonatomic, copy) NSString *query;

@property (nonatomic, strong) NSArray *translation;

@property (nonatomic, copy) NSString *translationStr;

@property (nonatomic, strong) ZRYouDaoBasicModel *basic;

@property (nonatomic, strong) NSArray<NSDictionary *> *web;

@end



@protocol ZRYouDaoDictDelegate <NSObject>

- (void)translationResult:(ZRYouDaoModel *)youdaoModel selectionText:(NSString *)selectionText;

@end


@interface ZRYouDaoDict : NSObject

@property (nonatomic, weak) id<ZRYouDaoDictDelegate> delegate;

- (void)translate:(NSString *)queryText;

@end






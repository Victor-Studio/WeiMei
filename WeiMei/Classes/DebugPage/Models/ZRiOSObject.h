//
//  ZRiOSObject.h
//  WeiMeiBrowser
//
//  Created by Victor Zhang on 4/1/16.
//  Copyright © 2016 XiaoRuiGeGeStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol ZRiOSObjectProtocol <JSExport>

//生成HTML源码到页面
- (void)generalCodeToHtml:(NSString *)htmlCode;

@end

@interface ZRiOSObject : NSObject<ZRiOSObjectProtocol>

@end

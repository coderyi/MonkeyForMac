//
//  AppConfig.h
//  Monkey
//
//  Created by coderyi on 15/7/11.
//  Copyright (c) 2015年 www.coderyi.com. All rights reserved.
//

#ifndef Monkey_AppConfig_h
#define Monkey_AppConfig_h

/**
 *   define
 */

//我喜欢的蓝色
#define YiBlue [NSColor colorWithRed:0.24f green:0.51f blue:0.78f alpha:1.00f]
//灰色
#define YiGray [NSColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f]
#define YiTextGray [NSColor colorWithRed:0.54f green:0.54f blue:0.54f alpha:1.00f]




// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;


#define CoderyiClientID @""
#define CoderyiClientSecret @""


#endif




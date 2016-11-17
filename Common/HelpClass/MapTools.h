

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

#define GBScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define GBScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define GBHeightWithScreen(_height)  (_height/568.0)*([[UIScreen mainScreen] bounds].size.height)
#define GBWidthtWithScreen(_width)  (_width/320.0)*([[UIScreen mainScreen] bounds].size.width)

@interface MapTools : NSObject

+(NSData *)objectToData:(NSObject *)object;
+(NSObject *)dataToObject:(NSData *)data;

/*********************为空的校验start***********************/
//判断NSString是否为空
+(BOOL)isBlankString:(NSString*)str;
//判断NSArray是否为空
+(BOOL)isBlankArray:(NSArray*)array;
//判断NSDictionary是否为空
+(BOOL)isBlankDictionary:(NSDictionary*)dict;
//判断对象是否为空
+(BOOL) isObjEmpty:(id) obj;
/*********************为空的校验end***********************/

/*********************常用校验start*********************/
//获取系统时间
+(NSString *)GetSysDataTime;
//判断是否包含汉字
+(BOOL)isChinese:(NSString *)str;

+(void)showMessage:(NSString *)message;



@end



#import <Foundation/Foundation.h>

@interface MapPaths : NSObject<NSCopying>

@property(nonatomic,strong)NSString *count;//path的总个数
@property(nonatomic,strong)NSMutableArray *paths;

@end

@interface MapPath : NSObject<NSCopying>

@property(nonatomic,strong)NSString *d;
@property(nonatomic,strong)NSString *pId;

@end

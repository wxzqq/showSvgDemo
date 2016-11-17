

#import <Foundation/Foundation.h>

@interface MapPoints : NSObject<NSCopying>

@property(nonatomic,strong)NSString *count;//Points的总个数
@property(nonatomic,strong)NSMutableArray *points;

@end

@interface MapPoint : NSObject<NSCopying>

@property(nonatomic,strong)NSString *bles;
@property(nonatomic,strong)NSString *connIds;
@property(nonatomic,strong)NSString *coord;
@property(nonatomic,strong)NSString *pointId;

@end

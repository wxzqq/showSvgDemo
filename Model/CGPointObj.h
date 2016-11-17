
#import <Foundation/Foundation.h>

@interface CGPointObj : NSObject

@property(nonatomic,strong)NSString *pointId;//点对应的id
@property(nonatomic,strong)NSString *pointX;//点对应的x坐标
@property(nonatomic,strong)NSString *pointY;//点对应的y坐标

//保存的点的信息
@property(nonatomic,strong)NSString *longitude;//经度
@property(nonatomic,strong)NSString *latitude;//纬度
@property(nonatomic,strong)NSString *index;//点对应的号
@property(nonatomic,strong)NSString *accuracy;//精确度

@end

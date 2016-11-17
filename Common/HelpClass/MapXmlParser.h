
#import <Foundation/Foundation.h>
#import "MapPaths.h"
#import "MapPoints.h"

typedef NS_ENUM(NSUInteger, MapResourceType) {
    MapResourceTypeData,
    MapResourceTypeSvg,
    MapResourceTypePaths,
    MapResourceTypePoints
};

typedef void(^MapXmlParsedData)(id data);

@interface MapXmlParser : NSObject<NSXMLParserDelegate>


@property(nonatomic,strong)MapPaths *mapPaths;
@property(nonatomic,strong)MapPoints *mapPoints;

@property(nonatomic,copy)MapXmlParsedData parsedBlock;
/**
 *  根据类型初始化MapXmlParser
 *
 *  @param resourceType 类型
 *  @param xmlPath      xml文件路径
 *
 *  @return 返回MapXmlParser
 */
-(instancetype)initWithType:(MapResourceType)resourceType path:(NSString *)xmlPath;
/**
 *  调用该方法开始转化
 */
-(void)parseXml;

@end

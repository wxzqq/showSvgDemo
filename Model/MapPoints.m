
#import "MapPoints.h"

@implementation MapPoints

-(instancetype)init{
    if(self=[super init]){
        _points=[[NSMutableArray alloc] init];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    MapPoints *mapPoints=[[[self class] allocWithZone:zone] init];
    mapPoints.count=[_count copy];
    mapPoints.points=[_points mutableCopy];
    return mapPoints;
}

@end


@implementation MapPoint

-(id)copyWithZone:(NSZone *)zone{
    MapPoint *mapPoint=[[[self class] allocWithZone:zone] init];
    mapPoint.bles=[_bles copy];
    mapPoint.connIds=[_connIds copy];
    mapPoint.coord=[_coord copy];
    mapPoint.pointId=[_pointId copy];
    return mapPoint;
}

@end

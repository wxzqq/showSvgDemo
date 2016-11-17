
#import "MapPaths.h"

@implementation MapPaths

-(instancetype)init{
    if(self=[super init]){
        _paths=[[NSMutableArray alloc] init];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    MapPaths *mapPaths=[[[self class] allocWithZone:zone] init];
    mapPaths.count=[_count copy];
    mapPaths.paths=[_paths mutableCopy];
    return mapPaths;
}


@end

@implementation MapPath

-(id)copyWithZone:(NSZone *)zone{
    MapPath *mapPath=[[[self class] allocWithZone:zone] init];
    mapPath.d=[_d copy];
    mapPath.pId=[_pId copy];
    return mapPath;
}

@end

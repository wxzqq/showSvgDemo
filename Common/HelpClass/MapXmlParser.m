
#import "MapXmlParser.h"

@interface MapXmlParser()

@property (nonatomic, strong) NSXMLParser *xmlParser;
//标记当前标签
@property (nonatomic, copy) NSString *currentElement;
@property (nonatomic, assign) MapResourceType resourceType;

@end

@implementation MapXmlParser

-(instancetype)init{
    NSAssert( FALSE, @"This class has no init method - it MUST NOT be init'd via init - you MUST use one of the multi-argument constructors instead" );
    
    return nil;
}

-(instancetype)initWithType:(MapResourceType)resourceType path:(NSString *)xmlPath{
    if(self=[super init]){
        _resourceType=resourceType;
        NSData *xmlData=[NSData dataWithContentsOfFile:xmlPath];
        /*
        NSString *aString = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
        aString = [aString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        aString = [aString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        aString = [aString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        */
        _xmlParser=[[NSXMLParser alloc] initWithData:xmlData];
        _xmlParser.delegate=self;
    }
    return self;
}

#pragma mark - NSXMLParserDelegate

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    switch (self.resourceType) {
        case MapResourceTypeData:{
            
            break;
        }
        case MapResourceTypeSvg:{
            
            break;
        }
        case MapResourceTypePaths:{
            _mapPaths=[[MapPaths alloc] init];
            break;
        }
        case MapResourceTypePoints:{
            _mapPoints=[[MapPoints alloc] init];
            break;
        }
    }
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    self.currentElement=elementName;
    
    switch (self.resourceType) {
        case MapResourceTypeData:{
            
            
            break;
        }
        case MapResourceTypeSvg:{
            
            
            break;
        }
        case MapResourceTypePaths:{
            if([elementName isEqualToString:@"Paths"]){
                _mapPaths.count=[NSString stringWithFormat:@"%@",[attributeDict objectForKey:@"count"]];
                
            }else if([elementName isEqualToString:@"Path"]){
                MapPath *mapPath=[[MapPath alloc] init];
                mapPath.d=[NSString stringWithFormat:@"%@",[attributeDict objectForKey:@"d"]];
                mapPath.pId=[NSString stringWithFormat:@"%@",[attributeDict objectForKey:@"id"]];
                [_mapPaths.paths addObject:mapPath];
            }
            break;
        }
        case MapResourceTypePoints:{
            if([elementName isEqualToString:@"Connection"]){
                _mapPoints.count=[NSString stringWithFormat:@"%@",[attributeDict objectForKey:@"count"]];
                
            }else if([elementName isEqualToString:@"Point"]){
                MapPoint *mapPoint=[[MapPoint alloc] init];
                mapPoint.bles=[NSString stringWithFormat:@"%@",[attributeDict objectForKey:@"bles"]];
                mapPoint.connIds=[NSString stringWithFormat:@"%@",[attributeDict objectForKey:@"connIds"]];
                mapPoint.coord=[NSString stringWithFormat:@"%@",[attributeDict objectForKey:@"coord"]];
                mapPoint.pointId=[NSString stringWithFormat:@"%@",[attributeDict objectForKey:@"id"]];
                [_mapPoints.points addObject:mapPoint];
            }
            break;
        }
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    self.currentElement = nil;
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    if(_parsedBlock){
        switch (self.resourceType) {
            case MapResourceTypeData:{
                
                
                break;
            }
            case MapResourceTypeSvg:{
                
                
                break;
            }
            case MapResourceTypePaths:{
                _parsedBlock(_mapPaths);
                
                break;
            }
            case MapResourceTypePoints:{
                _parsedBlock(_mapPoints);
                break;
            }
        }
        
    }
}

#pragma mark - parseXml:开始解析数据

-(void)parseXml{
    [_xmlParser parse];
}

@end

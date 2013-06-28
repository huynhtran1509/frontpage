#import "frontpageAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "TTTDateTransformers.h"

static NSString * const kfrontpageAPIBaseURLString = @"http://www.reddit.com/";

@implementation frontpageAPIClient

+ (frontpageAPIClient *)sharedClient {
    static frontpageAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kfrontpageAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

#pragma mark - AFIncrementalStore

- (NSURLRequest *)requestForFetchRequest:(NSFetchRequest *)fetchRequest
                             withContext:(NSManagedObjectContext *)context
{
    NSMutableURLRequest *mutableURLRequest = nil;
    if ([fetchRequest.entityName isEqualToString:@"Post"]) {
        mutableURLRequest = [self requestWithMethod:@"GET" path:@"/r/all/top.json" parameters:nil];
    }
    
    return mutableURLRequest;
}

-(id)representationOrArrayOfRepresentationsFromResponseObject:(id)responseObject {
    return [responseObject valueForKey:@"data"];
}

- (id)representationOrArrayOfRepresentationsOfEntity:(NSEntityDescription *)entity fromResponseObject:(id)responseObject {
    id ro = [super representationOrArrayOfRepresentationsOfEntity:entity fromResponseObject:responseObject];
    
    if ([ro isKindOfClass:[NSDictionary class]]) {
        id posts = nil;
        posts = [[ro valueForKey:@"data"] valueForKey:@"children"];// valueForKey:@"data"];
        if (posts) {
            NSLog(@"got %i posts", [posts count]);
            return posts;
        } else {
            abort();
        }
    }
    NSLog(@"returning %@", responseObject);
    return ro;
}


- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation  
                                     ofEntity:(NSEntityDescription *)entity 
                                 fromResponse:(NSHTTPURLResponse *)response 
{
    NSDictionary *data = [representation valueForKey:@"data"];
    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:data ofEntity:entity fromResponse:response] mutableCopy];
    
    if ([entity.name isEqualToString:@"Post"]) {
        [mutablePropertyValues setValue:[data valueForKey:@"id"] forKey:@"postID"];
//        [mutablePropertyValues setValue:[[NSValueTransformer valueTransformerForName:TTTISO8601DateTransformerName] reverseTransformedValue:[data valueForKey:@"created"]] forKey:@"createdAt"];
    }
//    NSLog(@"entity %@ got  response %@ and mutable property values %@", entity.name, representation, mutablePropertyValues);
    return mutablePropertyValues;
}
//
//- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID
//                                 inManagedObjectContext:(NSManagedObjectContext *)context
//{
//    return NO;
//}
//
//- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship
//                               forObjectWithID:(NSManagedObjectID *)objectID
//                        inManagedObjectContext:(NSManagedObjectContext *)context
//{
//    return NO;
//}
//
@end

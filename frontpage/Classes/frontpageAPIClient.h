#import "AFIncrementalStore.h"
#import "AFRestClient.h"

@interface frontpageAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (frontpageAPIClient *)sharedClient;

@end

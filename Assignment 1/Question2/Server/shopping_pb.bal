import ballerina/grpc;
import ballerina/protobuf;
import ballerina/protobuf.types.empty;

public const string SHOPPING_DESC = "0A0E73686F7070696E672E70726F746F120873686F7070696E671A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F225B0A045573657212170A07757365725F6964180120012809520675736572496412120A046E616D6518022001280952046E616D6512260A047479706518032001280E32122E73686F7070696E672E557365725479706552047479706522A6010A0750726F6475637412100A03736B751801200128095203736B7512120A046E616D6518022001280952046E616D6512200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12140A0570726963651804200128015205707269636512250A0E73746F636B5F7175616E74697479180520012805520D73746F636B5175616E7469747912160A06737461747573180620012809520673746174757322380A08436172744974656D12100A03736B751801200128095203736B75121A0A087175616E7469747918022001280552087175616E746974792286010A054F7264657212190A086F726465725F696418012001280952076F72646572496412170A07757365725F6964180220012809520675736572496412280A056974656D7318032003280B32122E73686F7070696E672E436172744974656D52056974656D73121F0A0B746F74616C5F7072696365180420012801520A746F74616C507269636522400A1141646450726F6475637452657175657374122B0A0770726F6475637418012001280B32112E73686F7070696E672E50726F64756374520770726F6475637422370A1241646450726F64756374526573706F6E736512210A0C70726F647563745F636F6465180120012809520B70726F64756374436F6465223A0A1243726561746555736572735265717565737412240A05757365727318012003280B320E2E73686F7070696E672E5573657252057573657273222F0A134372656174655573657273526573706F6E736512180A076D65737361676518012001280952076D65737361676522550A1455706461746550726F647563745265717565737412100A03736B751801200128095203736B75122B0A0770726F6475637418022001280B32112E73686F7070696E672E50726F64756374520770726F6475637422280A1452656D6F766550726F647563745265717565737412100A03736B751801200128095203736B7522450A144C69737450726F6475637473526573706F6E7365122D0A0870726F647563747318012003280B32112E73686F7070696E672E50726F64756374520870726F647563747322280A1453656172636850726F647563745265717565737412100A03736B751801200128095203736B75225E0A1553656172636850726F64756374526573706F6E7365122B0A0770726F6475637418012001280B32112E73686F7070696E672E50726F64756374520770726F6475637412180A076D65737361676518022001280952076D65737361676522590A10416464546F436172745265717565737412170A07757365725F6964180120012809520675736572496412100A03736B751802200128095203736B75121A0A087175616E7469747918032001280552087175616E74697479222C0A11506C6163654F726465725265717565737412170A07757365725F69641801200128095206757365724964225B0A12506C6163654F72646572526573706F6E7365122B0A086E65774F7264657218012001280B320F2E73686F7070696E672E4F7264657252086E65774F7264657212180A076D65737361676518022001280952076D6573736167652A230A085573657254797065120C0A08435553544F4D4552100012090A0541444D494E100132E6040A0853686F7070696E6712470A0A61646450726F64756374121B2E73686F7070696E672E41646450726F64756374526571756573741A1C2E73686F7070696E672E41646450726F64756374526573706F6E736512470A0D75706461746550726F64756374121E2E73686F7070696E672E55706461746550726F64756374526571756573741A162E676F6F676C652E70726F746F6275662E456D707479124F0A0D72656D6F766550726F64756374121E2E73686F7070696E672E52656D6F766550726F64756374526571756573741A1E2E73686F7070696E672E4C69737450726F6475637473526573706F6E7365124F0A156C697374417661696C61626C6550726F647563747312162E676F6F676C652E70726F746F6275662E456D7074791A1E2E73686F7070696E672E4C69737450726F6475637473526573706F6E736512500A0D73656172636850726F64756374121E2E73686F7070696E672E53656172636850726F64756374526571756573741A1F2E73686F7070696E672E53656172636850726F64756374526573706F6E7365123F0A09616464546F43617274121A2E73686F7070696E672E416464546F43617274526571756573741A162E676F6F676C652E70726F746F6275662E456D70747912470A0A706C6163654F72646572121B2E73686F7070696E672E506C6163654F72646572526571756573741A1C2E73686F7070696E672E506C6163654F72646572526573706F6E7365124A0A0B6372656174655573657273121C2E73686F7070696E672E4372656174655573657273526571756573741A1D2E73686F7070696E672E4372656174655573657273526573706F6E7365620670726F746F33";

public isolated client class ShoppingClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SHOPPING_DESC);
    }

    isolated remote function addProduct(AddProductRequest|ContextAddProductRequest req) returns AddProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddProductRequest message;
        if req is ContextAddProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/addProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddProductResponse>result;
    }

    isolated remote function addProductContext(AddProductRequest|ContextAddProductRequest req) returns ContextAddProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddProductRequest message;
        if req is ContextAddProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/addProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddProductResponse>result, headers: respHeaders};
    }

    isolated remote function updateProduct(UpdateProductRequest|ContextUpdateProductRequest req) returns grpc:Error? {
        map<string|string[]> headers = {};
        UpdateProductRequest message;
        if req is ContextUpdateProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        _ = check self.grpcClient->executeSimpleRPC("shopping.Shopping/updateProduct", message, headers);
    }

    isolated remote function updateProductContext(UpdateProductRequest|ContextUpdateProductRequest req) returns empty:ContextNil|grpc:Error {
        map<string|string[]> headers = {};
        UpdateProductRequest message;
        if req is ContextUpdateProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/updateProduct", message, headers);
        [anydata, map<string|string[]>] [_, respHeaders] = payload;
        return {headers: respHeaders};
    }

    isolated remote function removeProduct(RemoveProductRequest|ContextRemoveProductRequest req) returns ListProductsResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveProductRequest message;
        if req is ContextRemoveProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/removeProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ListProductsResponse>result;
    }

    isolated remote function removeProductContext(RemoveProductRequest|ContextRemoveProductRequest req) returns ContextListProductsResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveProductRequest message;
        if req is ContextRemoveProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/removeProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ListProductsResponse>result, headers: respHeaders};
    }

    isolated remote function listAvailableProducts() returns ListProductsResponse|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/listAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ListProductsResponse>result;
    }

    isolated remote function listAvailableProductsContext() returns ContextListProductsResponse|grpc:Error {
        empty:Empty message = {};
        map<string|string[]> headers = {};
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/listAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ListProductsResponse>result, headers: respHeaders};
    }

    isolated remote function searchProduct(SearchProductRequest|ContextSearchProductRequest req) returns SearchProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchProductRequest message;
        if req is ContextSearchProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/searchProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SearchProductResponse>result;
    }

    isolated remote function searchProductContext(SearchProductRequest|ContextSearchProductRequest req) returns ContextSearchProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchProductRequest message;
        if req is ContextSearchProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/searchProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SearchProductResponse>result, headers: respHeaders};
    }

    isolated remote function addToCart(AddToCartRequest|ContextAddToCartRequest req) returns grpc:Error? {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        _ = check self.grpcClient->executeSimpleRPC("shopping.Shopping/addToCart", message, headers);
    }

    isolated remote function addToCartContext(AddToCartRequest|ContextAddToCartRequest req) returns empty:ContextNil|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/addToCart", message, headers);
        [anydata, map<string|string[]>] [_, respHeaders] = payload;
        return {headers: respHeaders};
    }

    isolated remote function placeOrder(PlaceOrderRequest|ContextPlaceOrderRequest req) returns PlaceOrderResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceOrderRequest message;
        if req is ContextPlaceOrderRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/placeOrder", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PlaceOrderResponse>result;
    }

    isolated remote function placeOrderContext(PlaceOrderRequest|ContextPlaceOrderRequest req) returns ContextPlaceOrderResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceOrderRequest message;
        if req is ContextPlaceOrderRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/placeOrder", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PlaceOrderResponse>result, headers: respHeaders};
    }

    isolated remote function createUsers(CreateUsersRequest|ContextCreateUsersRequest req) returns CreateUsersResponse|grpc:Error {
        map<string|string[]> headers = {};
        CreateUsersRequest message;
        if req is ContextCreateUsersRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/createUsers", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CreateUsersResponse>result;
    }

    isolated remote function createUsersContext(CreateUsersRequest|ContextCreateUsersRequest req) returns ContextCreateUsersResponse|grpc:Error {
        map<string|string[]> headers = {};
        CreateUsersRequest message;
        if req is ContextCreateUsersRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.Shopping/createUsers", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CreateUsersResponse>result, headers: respHeaders};
    }
}

public isolated client class ShoppingAddProductResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAddProductResponse(AddProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAddProductResponse(ContextAddProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingPlaceOrderResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendPlaceOrderResponse(PlaceOrderResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextPlaceOrderResponse(ContextPlaceOrderResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingNilCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingSearchProductResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSearchProductResponse(SearchProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSearchProductResponse(ContextSearchProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingListProductsResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendListProductsResponse(ListProductsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextListProductsResponse(ContextListProductsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingCreateUsersResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCreateUsersResponse(CreateUsersResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCreateUsersResponse(ContextCreateUsersResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextAddProductResponse record {|
    AddProductResponse content;
    map<string|string[]> headers;
|};

public type ContextListProductsResponse record {|
    ListProductsResponse content;
    map<string|string[]> headers;
|};

public type ContextAddProductRequest record {|
    AddProductRequest content;
    map<string|string[]> headers;
|};

public type ContextUpdateProductRequest record {|
    UpdateProductRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchProductRequest record {|
    SearchProductRequest content;
    map<string|string[]> headers;
|};

public type ContextAddToCartRequest record {|
    AddToCartRequest content;
    map<string|string[]> headers;
|};

public type ContextPlaceOrderResponse record {|
    PlaceOrderResponse content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersRequest record {|
    CreateUsersRequest content;
    map<string|string[]> headers;
|};

public type ContextPlaceOrderRequest record {|
    PlaceOrderRequest content;
    map<string|string[]> headers;
|};

public type ContextRemoveProductRequest record {|
    RemoveProductRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchProductResponse record {|
    SearchProductResponse content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersResponse record {|
    CreateUsersResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type Order record {|
    string order_id = "";
    string user_id = "";
    CartItem[] items = [];
    float total_price = 0.0;
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type User record {|
    string user_id = "";
    string name = "";
    UserType 'type = CUSTOMER;
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type AddProductResponse record {|
    string product_code = "";
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type Product record {|
    string sku = "";
    string name = "";
    string description = "";
    float price = 0.0;
    int stock_quantity = 0;
    string status = "";
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type ListProductsResponse record {|
    Product[] products = [];
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type CartItem record {|
    string sku = "";
    int quantity = 0;
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type AddProductRequest record {|
    Product product = {};
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type UpdateProductRequest record {|
    string sku = "";
    Product product = {};
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type SearchProductRequest record {|
    string sku = "";
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type AddToCartRequest record {|
    string user_id = "";
    string sku = "";
    int quantity = 0;
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type PlaceOrderResponse record {|
    Order newOrder = {};
    string message = "";
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type CreateUsersRequest record {|
    User[] users = [];
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type PlaceOrderRequest record {|
    string user_id = "";
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type RemoveProductRequest record {|
    string sku = "";
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type SearchProductResponse record {|
    Product product = {};
    string message = "";
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type CreateUsersResponse record {|
    string message = "";
|};

public enum UserType {
    CUSTOMER, ADMIN
}


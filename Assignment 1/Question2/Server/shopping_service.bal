import ballerina/grpc;
import ballerina/time;

listener grpc:Listener ep = new (9090);

// Helper function to generate a unique order ID
function generateOrderId(string userId) returns string {
    time:Utc currentUtc = time:utcNow();
    time:Civil currentDateTime = time:utcToCivil(currentUtc);
    return "order_" + userId + "_" + currentDateTime.toString();
}

map<map<CartItem>> carts = {};
map<Product> products = {};
map<User> users = {};
map<Order> orders = {};

@grpc:Descriptor {value: SHOPPING_DESC}
service "Shopping" on ep {

    // Admin function to add a product
    remote function addProduct(AddProductRequest request) returns AddProductResponse|error {
        products[request.product.sku] = request.product;
        return {product_code: request.product.sku};
    }

    // Admin function to update a product's details
    remote function updateProduct(UpdateProductRequest request) returns error? {

        Product? retrievedProduct = products[request.sku];

        if (retrievedProduct is Product) {
            products[request.sku] = request.product;
        } else {
            return error("Product not found");
        }

    }

    // Admin function to remove a product
    remote function removeProduct(RemoveProductRequest request) returns ListProductsResponse|error {
        Product? product = products.remove(request.sku);
        if product is () {
            return error("Product not found");
        }

        Product[] remainingProducts = [];
        foreach var p in products {
            remainingProducts.push(p);
        }

        ListProductsResponse response = {products: remainingProducts};
        return response;
    }

    // Customer function to list all available products  
    remote function listAvailableProducts() returns ListProductsResponse {
        Product[] availableProducts = [];
        foreach var product in products {
            if product.status == "available" {
                availableProducts.push(product);
            }
        }
        return {products: availableProducts};
    }

    // Customer function to search for a product by SKU
    remote function searchProduct(SearchProductRequest request) returns SearchProductResponse|error {
        Product? product = products[request.sku];
        if product is () {
            return {message: "Product not found"};
        }
        return {product: product};
    }

    // Customer function to add a product to the cart
    remote function addToCart(AddToCartRequest request) returns error? {
        Product? product = products[request.sku];
        if product is () {
            return error("Product not found");
        }

        if carts.hasKey(request.user_id) {
            CartItem? existingItem = carts[request.user_id][request.sku];
            if existingItem is CartItem { // Check if existingItem is of type CartItem
                existingItem.quantity += request.quantity; // Modify the existing item's quantity
            } else {
                // If there is no existing item, create a new one
                carts[request.user_id][request.sku] = {sku: request.sku, quantity: request.quantity};
            }
        } else {
            // Create a new cart for the user
            map<CartItem> newCart = {};
            newCart[request.sku] = {sku: request.sku, quantity: request.quantity};
            carts[request.user_id] = newCart;
        }
    }

    // Customer function to place an order
    remote function placeOrder(PlaceOrderRequest request) returns PlaceOrderResponse {
        // Check if the cart exists for the user
        if carts.hasKey(request.user_id) {
            map<CartItem>? cartItems = carts[request.user_id];
            float totalPrice = 0.0;

            // Ensure cartItems is a valid map
            if cartItems is map<CartItem> {
                foreach var item in cartItems {
                    Product? product = products[item.sku];
                    if product is Product {
                        totalPrice += product.price * item.quantity;
                    }
                }

                string orderId = generateOrderId(request.user_id);
                Order currentOrder = {
                    order_id: orderId,
                    user_id: request.user_id,
                    items: cartItems.toArray(),
                    total_price: totalPrice
                };

                orders[orderId] = currentOrder;
                _ = carts.remove(request.user_id);

                PlaceOrderResponse pOR = {newOrder: {order_id: "", user_id: "", items: [], total_price: 0.0}, message: "Your message here"};

                return pOR;
            } else {
                PlaceOrderResponse pOR = {newOrder: {}, message: "Cart is empty or invalid"};
                return pOR;
            }
        } else {
            PlaceOrderResponse pOR = {newOrder: {}, message: "No items in the cart"};
            return pOR;
        }
    }

    // Function to create multiple users
    remote function createUsers(stream<User> userStream) returns CreateUsersResponse {
        error? e = userStream.forEach(function(User user) {
            users[user.user_id] = user;
        });
        if e is error {
            return {message: "Failed to create users"};
        }
        return {message: "Users created successfully"};
    }

}


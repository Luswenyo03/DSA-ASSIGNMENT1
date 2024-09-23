import ballerina/io;

ShoppingClient ep = check new ("http://localhost:9090");

// Function to capture user input
function getInput(string prompt) returns string {
    io:print(prompt);
    return io:readln();
}

public function displayProduct(Product product) returns error? {
    io:println("\n*** Product Details ***\n");
    io:println("SKU: " + product.sku);
    io:println("Name: " + product.name);
    io:println("Description: " + product.description);
    io:println("Price: N$: " + product.price.toString());
    io:println("Stock Quantity: " + product.stock_quantity.toString());
    io:println("Status: " + product.status);
    io:println("\n ------------------------------\n");
}

// Function to add a product
function addProduct() returns error? {

    io:println("\n ***Adding new product***");

    string sku = getInput("\n  Enter product SKU: ");
    string name = getInput("  Enter product name: ");
    string description = getInput("  Enter product description: ");

    float price = 0.0; // Initialize with a default value
    while true {
        string priceInput = getInput("  Enter product price (e.g. 100.00) N$: ");
        var result = float:fromString(priceInput);
        if result is float {
            price = result;
            if (price < 0.0) {
                io:println("\n  Error: Price must be a positive float.\n");
            } else {
                break;
            }
        } else {
            io:println("\n  Error: Invalid input for price. Please enter a valid float like 100.00.\n");
        }
    }

    int stock_quantity = 0; // Initialize with a default value
    while true {
        string quantityInput = getInput("  Enter stock quantity: ");
        var result = int:fromString(quantityInput);
        if result is int {
            stock_quantity = result;
            if (stock_quantity < 0) {
                io:println("\n  Error: Stock quantity must be a non-negative integer.\n");
            } else {
                break;
            }
        } else {
            io:println("\n  Error: Invalid input for quantity. Please enter a valid integer.\n");
        }
    }

    string statusInput = ""; // Initialize with an empty string
    while true {
        string statusChoice = getInput("  Enter product status (A for available, U for unavailable): ");
        if (statusChoice == "A") {
            statusInput = "available";
            break;
        } else if (statusChoice == "U") {
            statusInput = "unavailable";
            break;
        } else {
            io:println("\n  Error: Status must be 'A' for available or 'U' for unavailable.\n");
        }
    }

    AddProductRequest addProductRequest = {
        product: {
            sku: sku,
            name: name,
            description: description,
            price: price,
            stock_quantity: stock_quantity,
            status: statusInput
        }
    };

    AddProductResponse addProductResponse = check ep->addProduct(addProductRequest);

    io:println("\n Successfully added new product: " + addProductResponse.toString());
}

// Function to update a product
function updateProduct() returns error? {
    io:println("\n ***Update product***");

    string sku = getInput("\n  Enter product SKU: ");

    string updatedSku = getInput("  Enter updated product SKU: ");
    string updatedName = getInput("  Enter updated product name: ");
    string updatedDescription = getInput("  Enter updated product description: ");

    float updatedPrice = 0.0; // Initialize with a default value
    while true {
        string priceInput = getInput("  Enter updated price: ");
        var result = float:fromString(priceInput);
        if result is float {
            updatedPrice = result;
            if (updatedPrice < 0.0) {
                io:println("\n  Error: Price must be a positive float.");
            } else {
                break;
            }
        } else {
            io:println("\n  Error: Invalid input for price. Please enter a valid float like 100.00.");
        }
    }

    int updatedStockQuantity = 0; // Initialize with a default value
    while true {
        string quantityInput = getInput("  Enter updated stock quantity: ");
        var result = int:fromString(quantityInput);
        if result is int {
            updatedStockQuantity = result;
            if (updatedStockQuantity < 0) {
                io:println("  Error: Stock quantity must be a non-negative integer.");
            } else {
                break;
            }
        } else {
            io:println("  Error: Invalid input for quantity. Please enter a valid integer.");
        }
    }

    string updatedStatus = ""; // Initialize with a default value
    while true {
        string statusInput = getInput("  Enter updated product status (A for available, U for unavailable): ");
        if (statusInput == "A") {
            updatedStatus = "available";
            break;
        } else if (statusInput == "U") {
            updatedStatus = "unavailable";
            break;
        } else {
            io:println("  Error: Status must be 'A' for available or 'U' for unavailable. Please enter again.");
        }
    }

    UpdateProductRequest updateProductRequest = {
        sku: sku,
        product: {
            sku: updatedSku,
            name: updatedName,
            description: updatedDescription,
            price: updatedPrice,
            stock_quantity: updatedStockQuantity,
            status: updatedStatus
        }
    };

    check ep->updateProduct(updateProductRequest);

    io:println("\n Successfully updated product: ");
}

// Function to remove a product
function removeProduct() returns error? {
    RemoveProductRequest removeProductRequest = {sku: getInput("Enter product SKU to remove: ")};
    ListProductsResponse removeProductResponse = check ep->removeProduct(removeProductRequest);
    io:println(removeProductResponse);
}

// Function to list available products
function listAvailableProducts() returns error? {
    ListProductsResponse listAvailableProductsResponse = check ep->listAvailableProducts();
    io:println(listAvailableProductsResponse);
}

// Function to search for a product
function searchProduct() returns error? {
    SearchProductRequest searchProductRequest = {sku: getInput("Enter product SKU to search: ")};
    SearchProductResponse searchProductResponse = check ep->searchProduct(searchProductRequest);
    io:println(searchProductResponse);
}

// Function to add to cart
function addToCart() returns error? {
    AddToCartRequest addToCartRequest = {
        user_id: getInput("Enter user ID: "),
        sku: getInput("Enter product SKU to add: "),
        quantity: check int:fromString(getInput("Enter quantity: "))
    };
    check ep->addToCart(addToCartRequest);
}

// Function to place an order
function placeOrder() returns error? {
    PlaceOrderRequest placeOrderRequest = {user_id: getInput("Enter user ID to place order: ")};
    PlaceOrderResponse placeOrderResponse = check ep->placeOrder(placeOrderRequest);
    io:println(placeOrderResponse);
}

// Function to create users
function createUsers() returns error? {
    CreateUsersRequest createUsersRequest = {
        users: [
            {
                user_id: getInput("Enter user ID: "),
                name: getInput("Enter user name: "),
                'type: <UserType>getInput("Enter user type (CUSTOMER/ADMIN): ")
            }
        ]
    };
    CreateUsersResponse createUsersResponse = check ep->createUsers(createUsersRequest);
    io:println(createUsersResponse);
}

// Main function to handle user choices
public function main() returns error? {
    while true {
        int choice = check getUserChoice();

        if choice == 1 {
            check addProduct();
        } else if choice == 2 {
            check updateProduct();
        } else if choice == 3 {
            check removeProduct();
        } else if choice == 4 {
            check listAvailableProducts();
        } else if choice == 5 {
            check searchProduct();
        } else if choice == 6 {
            check addToCart();
        } else if choice == 7 {
            check placeOrder();
        } else if choice == 8 {
            check createUsers();
        } else if choice == 9 {
            io:println("Exiting...");
            return;
        } else {
            io:println("Invalid option. Please try again.");
        }
    }
}

// Function to display menu and get user choice
function getUserChoice() returns int|error {
    io:println("\n==== Shopping Management System ====\n");
    io:println("1. Add Product");
    io:println("2. Update Product");
    io:println("3. Remove Product");
    io:println("4. List Available Products");
    io:println("5. Search Product");
    io:println("6. Add To Cart");
    io:println("7. Place Order");
    io:println("8. Create Users");
    io:println("9. Exit");

    return check int:fromString(getInput("\nChoose an option (1-9): "));
}

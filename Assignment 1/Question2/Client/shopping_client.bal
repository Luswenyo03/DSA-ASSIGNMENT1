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

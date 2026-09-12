import 'package:flutter/material.dart';

void main() {
  runApp(const ShoppingCartApp());
}

class Product {
  final String name;
  final double price;
  final String category;
  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.category,
    this.quantity = 0,
  });
}

class ShoppingCartApp extends StatelessWidget {
  const ShoppingCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Shopping Cart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ShoppingCartPage(),
    );
  }
}

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  final TextEditingController searchController = TextEditingController();

  String searchText = '';
  String selectedCategory = 'All';

  final List<Product> products = [
    Product(name: 'T-Shirt', price: 500, category: 'Clothes'),
    Product(name: 'Shoes', price: 1500, category: 'Fashion'),
    Product(name: 'Watch', price: 2000, category: 'Accessories'),
    Product(name: 'Bag', price: 1000, category: 'Fashion'),
  ];

  List<Product> get filteredProducts {
    return products.where((product) {
      final searchMatch = product.name
          .toLowerCase()
          .contains(searchText.toLowerCase());

      final categoryMatch = selectedCategory == 'All' ||
          product.category == selectedCategory;

      return searchMatch && categoryMatch;
    }).toList();
  }

  int get totalItems {
    return products.fold(
      0,
          (sum, product) => sum + product.quantity,
    );
  }

  double get subtotal {
    return products.fold(
      0,
          (sum, product) => sum + (product.price * product.quantity),
    );
  }

  double get discount {
    return subtotal >= 3000 ? subtotal * 0.10 : 0;
  }

  double get grandTotal {
    return subtotal - discount;
  }

  void increaseQuantity(Product product) {
    setState(() {
      product.quantity++;
    });
  }

  void decreaseQuantity(Product product) {
    if (product.quantity > 0) {
      setState(() {
        product.quantity--;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simple Shopping Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchText = '';
                    });
                  },
                  icon: const Icon(Icons.clear),
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Category Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'All',
                  child: Text('All'),
                ),
                DropdownMenuItem(
                  value: 'Clothes',
                  child: Text('Clothes'),
                ),
                DropdownMenuItem(
                  value: 'Fashion',
                  child: Text('Fashion'),
                ),
                DropdownMenuItem(
                  value: 'Accessories',
                  child: Text('Accessories'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
          ),

          const SizedBox(height: 8),

          // Product List
          Expanded(
            child: visibleProducts.isEmpty
                ? const Center(
              child: Text(
                'No matching products found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: visibleProducts.length,
              itemBuilder: (context, index) {
                final product = visibleProducts[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '৳${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(product.category),
                            ],
                          ),
                        ),

                        // Quantity
                        Row(
                          children: [
                            IconButton(
                              onPressed: product.quantity > 0
                                  ? () => decreaseQuantity(product)
                                  : null,
                              icon: const Icon(
                                Icons.remove_circle_outline,
                              ),
                            ),
                            Text(
                              '${product.quantity}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  increaseQuantity(product),
                              icon: const Icon(
                                Icons.add_circle_outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Cart Summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Column(
              children: [
                summaryRow('Total Items', '$totalItems'),
                summaryRow(
                  'Subtotal',
                  '৳${subtotal.toStringAsFixed(0)}',
                ),
                summaryRow(
                  'Discount',
                  '৳${discount.toStringAsFixed(0)}',
                ),
                const Divider(),
                summaryRow(
                  'Grand Total',
                  '৳${grandTotal.toStringAsFixed(0)}',
                  isGrandTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryRow(
      String title,
      String value, {
        bool isGrandTotal = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isGrandTotal ? 18 : 15,
              fontWeight:
              isGrandTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isGrandTotal ? 20 : 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
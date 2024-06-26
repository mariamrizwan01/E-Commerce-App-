import 'package:flutter/material.dart';
import 'package:app/models/Products.dart';
import 'package:app/screens/Favourite.dart';
import 'CartPage.dart';
import 'package:app/data/productdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/utilities/app_colors.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  ProductDetailPage({required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool showFullDescription = false;
  List<Product> favItems = [];
  List<Product> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoriteProducts = prefs.getStringList('favorites') ?? [];
    setState(() {
      favItems = favoriteProducts
          .map((productId) =>
              products.firstWhere((product) => product.id == productId))
          .toList();
    });
  }

  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoriteIds = favItems.map((product) => product.id).toList();
    await prefs.setStringList('favorites', favoriteIds.cast<String>());
  }

  void addToCart(Product product) {
    setState(() {
      cartItems.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    String descriptionToShow = widget.product.description;

    if (!showFullDescription && widget.product.description.length > 100) {
      descriptionToShow = widget.product.description.substring(0, 100);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        title:  Text(
           widget.product.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        toolbarHeight: 70,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 25.0,
                  color: Colors.black,
                ),
                onPressed: navigateToCartPage,
              ),
              if (getCartItemCount() > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: AppColors.Color_Yellow,
                    radius: 8,
                    child: Text(
                      getCartItemCount().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Adjust the image size here
            Image.network(
              widget.product.imageUrl,
              fit: BoxFit.cover,
              height: 300, // Adjust the height
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.product.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 100), // Add spacing
                          IconButton(
                            onPressed: () {
                              toggleFavorite();
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: isFavorite() ? Colors.red : Colors.grey,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
               const SizedBox(height: 8),
Row(
  children: [
    Text(
      '\$${widget.product.price.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.Color_Blue,
      ),
    ),
    const SizedBox(width: 8), // Add spacing
    Container(
      height: 24,
      width: 84,
      decoration: BoxDecoration(
        color: AppColors.Color_Blue,
        borderRadius: BorderRadius.circular(70),
      ),
      margin: EdgeInsets.only(left:10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), // Adjust padding here
      child:Center(
      child: const Text(
        '10% Off',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    ),
    ),
  ],
),

                  const SizedBox(height: 16),
                  // Row for rating and text box with border radius
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          for (int i = 0; i < 5; i++)
                            Icon(
                              Icons.star,
                              color: i < 4 ? Colors.yellow : Colors.black45,
                              size: 24,
                            ),
                          const SizedBox(width: 8), // Add spacing
                          const Text(
                            '4.5 Rating',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffA1A1AB),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(height: 16),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 5), // Adjust the horizontal padding as needed
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Product Details:',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xff1E222B),
        ),
      ),
      const SizedBox(height: 10), // Add vertical spacing as needed
      Text(
        descriptionToShow,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xff8891A5),
        ),
      ),
    ],
  ),
),
                  widget.product.description.length > 100
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              showFullDescription = !showFullDescription;
                            });
                          },
                          child: Text(
                            showFullDescription ? "See Less" : "See More",
                            style: const TextStyle(
                              color: AppColors.Color_Blue,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 60,
              width: 170,
              decoration: BoxDecoration(
                color: AppColors.Color_Blue,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: TextButton(
                onPressed: () {
                  addToCart(widget.product);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Item Added to Cart'),
                        content:
                            const Text('The item has been added to your cart.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                color: AppColors.Color_Blue
                           
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  "Add To Cart",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    
                      color: Colors.white),
                ),
              ),
            ),
            Container(
              height: 60,
              width: 170,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.Color_Blue,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritesPage(favItems: favItems),
                    ),
                  );
                },
                child: const Text(
                  "View WishList",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                
                    color: AppColors.Color_Blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleFavorite() {
    setState(() {
      if (isFavorite()) {
        favItems.remove(widget.product);
      } else {
        favItems.add(widget.product);
      }
      saveFavorites();
    });
  }

  bool isFavorite() {
    return favItems.contains(widget.product);
  }

  void navigateToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(cartItems: cartItems),
      ),
    );
  }

  int getCartItemCount() {
    return cartItems.length;
  }
}
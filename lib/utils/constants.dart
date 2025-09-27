class AppConstants {
  // App Information
  static const String appName = 'Ecommerce App';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://fakestoreapi.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Local Storage Keys
  static const String productBoxName = 'products';
  static const String cartBoxName = 'cart';
  static const String favoritesBoxName = 'favorites';
  static const String userBoxName = 'user';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const double defaultBorderRadius = 10.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  static const double defaultElevation = 4.0;
  static const double smallElevation = 2.0;
  static const double largeElevation = 8.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Image Constants
  static const String defaultProductImage = 'assets/images/default_product.png';
  static const String defaultUserAvatar = 'assets/images/default_avatar.png';

  // Error Messages
  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unknown error occurred.';

  // Success Messages
  static const String productAddedToCart = 'Product added to cart successfully';
  static const String productRemovedFromCart = 'Product removed from cart';
  static const String productAddedToFavorites = 'Product added to favorites';
  static const String productRemovedFromFavorites =
      'Product removed from favorites';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Currency
  static const String defaultCurrency = 'USD';
  static const String currencySymbol = 'MMK';

  // Tax Rate (8.5%)
  static const double defaultTaxRate = 0.085;

  // Discount Thresholds
  static const double freeShippingThreshold = 50.0;
  static const double bulkDiscountThreshold = 100.0;

  // Search
  static const int minSearchLength = 2;
  static const Duration searchDebounceDelay = Duration(milliseconds: 500);

  // Cache
  static const Duration cacheExpiration = Duration(hours: 1);
  static const int maxCacheSize = 100;
}

class AppRoutes {
  static const String home = '/';
  static const String productList = '/products';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String favorites = '/favorites';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String checkout = '/checkout';
  static const String orderHistory = '/orders';
  static const String login = '/login';
  static const String register = '/register';
}

class AppStrings {
  // Common
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String remove = 'Remove';
  static const String clear = 'Clear';
  static const String retry = 'Retry';
  static const String refresh = 'Refresh';

  // Navigation
  static const String home = 'Home';
  static const String products = 'Products';
  static const String cart = 'Cart';
  static const String favorites = 'Favorites';
  static const String search = 'Search';
  static const String profile = 'Profile';
  static const String settings = 'Settings';

  // Product
  static const String productDetails = 'Product Details';
  static const String addToCart = 'Add to Cart';
  static const String outOfStock = 'Out of Stock';
  static const String inStock = 'In Stock';
  static const String quantity = 'Quantity';
  static const String price = 'Price';
  static const String description = 'Description';
  static const String category = 'Category';
  static const String brand = 'Brand';
  static const String rating = 'Rating';
  static const String reviews = 'Reviews';

  // Cart
  static const String shoppingCart = 'Shopping Cart';
  static const String cartEmpty = 'Your cart is empty';
  static const String cartEmptyMessage = 'Add some products to get started';
  static const String subtotal = 'Subtotal';
  static const String tax = 'Tax';
  static const String discount = 'Discount';
  static const String total = 'Total';
  static const String proceedToCheckout = 'Proceed to Checkout';
  static const String clearCart = 'Clear Cart';
  static const String clearCartMessage =
      'Are you sure you want to remove all items from your cart?';

  // Favorites
  static const String favoritesEmpty = 'No favorites yet';
  static const String favoritesEmptyMessage =
      'Add products to your favorites to see them here';
  static const String addToFavorites = 'Add to Favorites';
  static const String removeFromFavorites = 'Remove from Favorites';

  // Search
  static const String searchHint = 'Search products...';
  static const String noResults = 'No results found';
  static const String searchResults = 'Search Results';

  // User
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String phoneNumber = 'Phone Number';

  // Settings
  static const String theme = 'Theme';
  static const String language = 'Language';
  static const String notifications = 'Notifications';
  static const String privacy = 'Privacy';
  static const String about = 'About';

  // Errors
  static const String networkError = 'Network Error';
  static const String serverError = 'Server Error';
  static const String unknownError = 'Unknown Error';
  static const String validationError = 'Validation Error';
  static const String authenticationError = 'Authentication Error';
}

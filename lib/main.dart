import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bloc/app_bloc_observer.dart';
import 'bloc/product/product_bloc.dart';
import 'bloc/product/product_event.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/cart/cart_event.dart';
import 'bloc/favorites/favorites_bloc.dart';
import 'bloc/favorites/favorites_event.dart';
import 'repositories/product_repository.dart';
import 'repositories/cart_repository.dart';
import 'repositories/favorites_repository.dart';
import 'services/local_storage_service.dart';
import 'services/api_service.dart';
import 'services/connectivity_service.dart';
import 'screens/home_screen.dart';
import 'widgets/connectivity_wrapper.dart';
import 'utils/themes.dart';
import 'utils/constants.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize services
  await _initializeServices();

  // Set up BLoC observer
  Bloc.observer = AppBlocObserver();

  runApp(const EcommerceApp());
}

Future<void> _initializeServices() async {
  // Register services
  getIt.registerSingleton<LocalStorageService>(LocalStorageService());
  getIt.registerSingleton<ApiService>(ApiService());

  // Initialize local storage
  await getIt<LocalStorageService>().init();

  // Initialize connectivity service
  await ConnectivityService().initialize();

  // Register repositories
  getIt.registerSingleton<ProductRepository>(
    ProductRepository(
      localStorageService: getIt<LocalStorageService>(),
      apiService: getIt<ApiService>(),
    ),
  );

  getIt.registerSingleton<CartRepository>(
    CartRepository(localStorageService: getIt<LocalStorageService>()),
  );

  getIt.registerSingleton<FavoritesRepository>(
    FavoritesRepository(localStorageService: getIt<LocalStorageService>()),
  );
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (context) =>
              ProductBloc(productRepository: getIt<ProductRepository>())
                ..add(const LoadProducts()),
        ),
        BlocProvider<CartBloc>(
          create: (context) =>
              CartBloc(cartRepository: getIt<CartRepository>())
                ..add(const LoadCart()),
        ),
        BlocProvider<FavoritesBloc>(
          create: (context) =>
              FavoritesBloc(favoritesRepository: getIt<FavoritesRepository>())
                ..add(const LoadFavorites()),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        themeMode: ThemeMode.system,
        home: const ConnectivityWrapper(child: HomeScreen()),
      ),
    );
  }
}

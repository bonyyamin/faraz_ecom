import 'dart:async';
import 'package:faraz/features/Account/presentaion/screens/account.dart';
import 'package:faraz/features/cart/presentation/screens/cart.dart';
import 'package:faraz/features/messages/presentaion/screens/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/home_bloc.dart';
import '../blocs/home_event.dart';
import '../blocs/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required String country}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Widget> _pages = [
    const Center(child: Text("Home Page", style: TextStyle(fontSize: 20))), // Placeholder for Home
    const MessagePage(),
    const CartPage(),
    const AccountPage(),
  ];

  final List<String> _searchHints = [
    "Standing Mirror",
    "Men Watch",
    "Women Clothes",
    "Smartphone",
    "Shoes",
    "Accessories",
  ];

  late String _currentHint;
  late Timer _timer;
  int _currentPage = 0; // To track the current page in the PageView
  int _selectedIndex = 0; // To track the selected tab in BottomNavigationBar

  @override
  void initState() {
    super.initState();
    _currentHint = _searchHints[0];
    _startHintTextUpdate();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startHintTextUpdate() {
    int index = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        index = (index + 1) % _searchHints.length;
        _currentHint = _searchHints[index];
      });
    });
  }

  // Handle Bottom Navigation Tab Changes
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index; // Update _selectedIndex to the tapped tab index
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Faraz"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _selectedIndex == 0? _buildHomeContent(): _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),// Content changes based on selected tab
    );
  }
  // Build the Bottom Navigation Bar
  Widget _buildBottomNavigationBar(){
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onTabSelected,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.message),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
            icon:Icon(Icons.shopping_cart),
          label: 'Cart'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Account',
        ),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }

  // Home Content with Search Bar and PageView
  Widget _buildHomeContent() {
    return Column(
      children: [
        // Search Bar
        _buildSearchBar(),

        const SizedBox(height: 10),

        // Home Content
        Expanded(
          child: BlocProvider(
            create: (_) => HomeBloc()..add(LoadHomePageEvent()),
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HomeLoadedState) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Banner Slider with Dot Indicator
                        _buildBannerSlider(state.banners),

                        const SizedBox(height: 10),

                        // Category Bar
                        _buildCategoryBar(state.categories),

                        const SizedBox(height: 10),

                        // Flash Sale Section
                        _buildFlashSaleSection(state.flashSales),

                        const SizedBox(height: 20),

                        // As Low As Section
                        _buildAsLowAsSection(state.asLowAs),
                      ],
                    ),
                  );
                } else if (state is HomeErrorState) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: _currentHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (query) {
                // Handle search action
                print("Searching for: $query");
              },
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.blue),
            onPressed: () {
              // Handle camera-based search action
              print("Camera button pressed");
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.blue),
            onPressed: () {
              // Execute search action
              print("Search button pressed");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSlider(List<HomeBanner> banners) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(banners[index].imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),

        // Dot Indicator
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 8.0,
              width: _currentPage == index ? 16.0 : 8.0,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBar(List<String> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Center(child: Text(category)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFlashSaleSection(List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("Flash Sale", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: products.map((product) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("\$${product.price}"),
                    Text(product.discount, style: const TextStyle(color: Colors.red)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAsLowAsSection(List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("As Low As \$70 Any 3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: products.map((product) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("\$${product.price}"),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

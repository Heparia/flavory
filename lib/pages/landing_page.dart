import 'package:flavory/pages/login.dart';
import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(
        backgroundAsset: 'images/bg-1.png',
        pages: [
          OnboardingPageModel(
            title: 'Flavory',
            description: 'Ciptakan koneksi melalui setiap resep yang Anda bagikan.',
          ),
          OnboardingPageModel(
            title: 'Find',
            description: 'Cari resep favorit Anda di komunitas kami.',
          ),
          OnboardingPageModel(
            title: 'Share',
            description: 'Bagikan resep andalan Anda dengan komunitas kami.',
          ),
        ],
      ),
    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final String backgroundAsset;

  const OnboardingPagePresenter({
    Key? key,
    required this.pages,
    required this.backgroundAsset,
  }) : super(key: key);

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.backgroundAsset),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Page view
        PageView.builder(
          controller: _pageController,
          itemCount: widget.pages.length,
          onPageChanged: (idx) {
            setState(() {
              _currentPage = idx;
            });
          },
          itemBuilder: (context, idx) {
            final item = widget.pages[idx];
            return Stack(
              children: [
                Positioned(
                  bottom: 150, // Posisi teks lebih ke bawah
                  left: 50,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item.description,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        // Indicators and Next button
        Positioned(
          bottom: 40,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Page indicators
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: widget.pages.map((item) {
                    int index = widget.pages.indexOf(item);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.black : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Next button
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(150, 40), // Ukuran tetap tombol
                    backgroundColor: Colors.black, // Warna background tombol
                    foregroundColor: Colors.white, // Warna teks tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Radius border
                    ),
                  ),
                  onPressed: () {
                    if (_currentPage == widget.pages.length - 1) {
                      // Navigate to Login page when the user reaches the last page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()), // Ganti LoginPage dengan halaman login yang sesuai
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == widget.pages.length - 1 ? 'Mulai' : 'Next',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OnboardingPageModel {
  final String title;
  final String description;

  OnboardingPageModel({
    required this.title,
    required this.description,
  });
}

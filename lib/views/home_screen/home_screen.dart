import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/category_screen/item_details.dart';
import 'package:ecommerce_app/views/category_screen/category_screen.dart';
import 'package:ecommerce_app/views/home_screen/components/featured_buttons.dart';
import 'package:ecommerce_app/views/home_screen/search_screen.dart';
import 'package:ecommerce_app/widgets_common/home_button.dart';
import 'package:ecommerce_app/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _search(controller),
                  ),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchanything,
                  hintStyle: const TextStyle(color: textfieldGrey),
                ),
                onFieldSubmitted: (_) => _search(controller),
              ),
            ),
            10.heightBox,
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _slider(slidersList),
                    20.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        homeButtons(
                          height: context.screenHeight * .15,
                          width: context.screenWidth / 2.5,
                          icon: icTodaysDeal,
                          title: todayDeal,
                          onPress: () => Get.to(() => const CategoryScreen()),
                        ),
                        homeButtons(
                          height: context.screenHeight * .15,
                          width: context.screenWidth / 2.5,
                          icon: icFlashDeal,
                          title: flashsale,
                          onPress: () => Get.to(() => const CategoryScreen()),
                        ),
                      ],
                    ),
                    20.heightBox,
                    _slider(secondSlidersList),
                    20.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        homeButtons(
                          height: context.screenHeight * .15,
                          width: context.screenWidth / 3.5,
                          icon: icTopCategories,
                          title: topCategories,
                          onPress: () => Get.to(() => const CategoryScreen()),
                        ),
                        homeButtons(
                          height: context.screenHeight * .15,
                          width: context.screenWidth / 3.5,
                          icon: icBrands,
                          title: brand,
                          onPress: () => Get.to(() => const CategoryScreen()),
                        ),
                        homeButtons(
                          height: context.screenHeight * .15,
                          width: context.screenWidth / 3.5,
                          icon: icTopSeller,
                          title: topSellers,
                          onPress: () => Get.to(() => const CategoryScreen()),
                        ),
                      ],
                    ),
                    24.heightBox,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: featuredCategories.text
                          .color(darkFontGrey)
                          .size(18)
                          .fontFamily(semibold)
                          .make(),
                    ),
                    14.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          3,
                          (index) => Column(
                            children: [
                              featuredButton(
                                icon: featuredImages1[index],
                                title: featuredTitles1[index],
                              ),
                              10.heightBox,
                              featuredButton(
                                icon: featuredImages2[index],
                                title: featuredTitles2[index],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    24.heightBox,
                    _FeaturedSection(),
                    20.heightBox,
                    _slider(secondSlidersList),
                    20.heightBox,
                    _AllProductsGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _search(HomeController controller) {
    final title = controller.searchController.text.trim();
    if (title.isNotEmpty) Get.to(() => SearchScreen(title: title));
  }

  Widget _slider(List<String> images) => VxSwiper.builder(
    aspectRatio: 16 / 9,
    autoPlay: true,
    height: 150,
    enlargeCenterPage: true,
    itemCount: images.length,
    itemBuilder: (context, index) =>
        Image.asset(images[index], fit: BoxFit.cover).box.rounded
            .clip(Clip.antiAlias)
            .margin(const EdgeInsets.symmetric(horizontal: 10))
            .make(),
  );
}

class _FeaturedSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: redColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          featuredProduct.text.white.fontFamily(bold).size(18).make(),
          12.heightBox,
          SizedBox(
            height: 220,
            child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: FirestorServices.getFeaturedProducts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: loadingIndicator());
                final products = snapshot.data!.docs;
                if (products.isEmpty) {
                  return 'No featured products'.text.white.makeCentered();
                }
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  separatorBuilder: (context, index) => 10.widthBox,
                  itemBuilder: (context, index) =>
                      _ProductTile(data: products[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AllProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirestorServices.allproducts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return loadingIndicator();
        final products = snapshot.data!.docs;
        if (products.isEmpty) {
          return 'No products available'.text.color(fontGrey).makeCentered();
        }
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: 270,
          ),
          itemBuilder: (context, index) => _ProductTile(data: products[index]),
        );
      },
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.data});
  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    final product = data.data();
    final images = product['p_imgs'];
    final imageUrl = images is List && images.isNotEmpty
        ? images.first.toString()
        : '';
    final title = product['p_name']?.toString() ?? 'Unnamed product';
    final price = product['p_price']?.toString() ?? '0';
    return GestureDetector(
      onTap: () => Get.to(() => ItemDetails(title: title, data: data)),
      child:
          Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: imageUrl.isEmpty
                        ? _placeholder()
                        : Image.network(
                            imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _placeholder(),
                          ),
                  ),
                  10.heightBox,
                  title.text
                      .fontFamily(semibold)
                      .color(darkFontGrey)
                      .maxLines(1)
                      .ellipsis
                      .make(),
                  6.heightBox,
                  '\$$price'.text
                      .color(redColor)
                      .fontFamily(bold)
                      .size(16)
                      .make(),
                ],
              ).box.white.roundedSM
              .clip(Clip.antiAlias)
              .padding(const EdgeInsets.all(10))
              .make(),
    );
  }
}

Widget _placeholder() => Container(
  color: lightGolden,
  alignment: Alignment.center,
  child: const Icon(Icons.image_not_supported, color: redColor),
);

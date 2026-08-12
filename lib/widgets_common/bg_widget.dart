import "package:ecommerce_app/consts/consts.dart";

Widget bgWidget({required Scaffold child}) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xff312E81), Color(0xff4F46E5), Color(0xff7C3AED)],
      ),
    ),
    child: child,
  );
}

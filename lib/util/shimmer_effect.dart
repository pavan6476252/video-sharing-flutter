import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({super.key});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ShimmerCard(),
            Expanded(child: ShimmerList()),
          ],
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  const ShimmerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    // color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Card(
                  child: Container(
                    height: 20,
                    width: 200,
                    // color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Card(
                  child: Container(
                    height: 20,
                    width: 100,
                    // color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: double.infinity,
              // color: Colors.white,
            ),
            SizedBox(height: 8),
            Container(
              height: 20,
              width: 160,
              // color: Colors.white,
            ),
            SizedBox(height: 8),
            Container(
              height: 20,
              width: 100,
              // color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

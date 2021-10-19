import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CoinListShimmerWidget extends StatelessWidget {
  const CoinListShimmerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, i) {
              return Container(
                  child: Container(
                // color: Colors.blue,
                height: 75,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Container(
                        // height: 50,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        // margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(color: Colors.white24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 12,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 100,
                                  height: 12,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 12,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 7,
                                        color: Colors.grey,
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 30,
                                        height: 7,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 7,
                                        color: Colors.grey,
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 30,
                                        height: 7,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
            }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CoinDetailShimmerWidget extends StatelessWidget {
  const CoinDetailShimmerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: Shimmer.fromColors(
        baseColor: Colors.black54,
        highlightColor: Colors.white,
        child: Container(
          // color: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          height: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // color: Colors.amber,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    SizedBox(width: 6),
                    Container(width: 200, height: 25, color: Colors.black54),
                    SizedBox(width: 5),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(width: 150, height: 20, color: Colors.black54),
              ),
              SizedBox(height: 3),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(width: 100, height: 15, color: Colors.black54),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(width: 100, height: 25, color: Colors.black54),
                    SizedBox(width: 5),
                    Container(width: 100, height: 25, color: Colors.black54),
                  ],
                ),
              ),
              Divider(color: Colors.white54, thickness: 2),
              SizedBox(height: 10),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(children: [
                        Container(width: 50, height: 14, color: Colors.black54),
                        Spacer(),
                        Container(width: 90, height: 14, color: Colors.black54),
                      ]),
                    ),
                    SizedBox(height: 5),
                    Container(
                      child: Row(children: [
                        Container(width: 50, height: 14, color: Colors.black54),
                        Spacer(),
                        Container(width: 90, height: 14, color: Colors.black54),
                      ]),
                    ),
                    Divider(color: Colors.white54, thickness: 2),
                    SizedBox(height: 5),
                    Container(
                      child: Row(children: [
                        Container(
                            width: 100, height: 14, color: Colors.black54),
                        Spacer(),
                        Container(
                            width: 100, height: 14, color: Colors.black54),
                      ]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Row(children: [
                        Container(width: 90, height: 14, color: Colors.black54),
                        Spacer(),
                        Container(
                            width: 150, height: 14, color: Colors.black54),
                      ]),
                    ),
                    SizedBox(height: 5),
                    Container(
                      child: Row(children: [
                        Container(
                            width: 150, height: 14, color: Colors.black54),
                        Spacer(),
                        Container(
                            width: 120, height: 14, color: Colors.black54),
                      ]),
                    ),
                    SizedBox(height: 5),
                    Container(
                      child: Row(children: [
                        Container(
                            width: 120, height: 14, color: Colors.black54),
                        Spacer(),
                        Container(
                            width: 110, height: 14, color: Colors.black54),
                      ]),
                    ),
                    SizedBox(height: 5),
                    Container(
                      child: Row(children: [
                        Container(
                            width: 110, height: 14, color: Colors.black54),
                        Spacer(),
                        Container(
                            width: 100, height: 14, color: Colors.black54),
                      ]),
                    ),
                    SizedBox(height: 5),
                    Container(
                      child: Row(children: [
                        Container(
                            width: 100, height: 14, color: Colors.black54),
                        Spacer(),
                        Container(
                            width: 100, height: 14, color: Colors.black54),
                      ]),
                    ),
                    Divider(color: Colors.white54, thickness: 2),
                    SizedBox(height: 5),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 100, height: 20, color: Colors.black54),
                          SizedBox(height: 5),
                          Container(
                              width: double.infinity,
                              height: 220,
                              color: Colors.black54),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

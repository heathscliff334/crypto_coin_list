import 'dart:ui';

import 'package:coingecko_coinlist/src/widgets/coin_detail_shimmer_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class CoinDetailPage extends StatefulWidget {
  CoinDetailPage({Key? key, @required this.coinId}) : super(key: key);
  final String? coinId;

  @override
  _CoinDetailPageState createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  bool _isLoading = true;
  var _coinDetail;
  final formatter = intl.NumberFormat("#,##0.0######"); // for price change
  final percentageFormat = intl.NumberFormat("##0.0#"); // for price change

  getCoinDetail() async {
    Dio _dio = new Dio();
    Response _response;
    try {
      _response = await _dio
          .get("https://api.coingecko.com/api/v3/coins/${widget.coinId}");
      // print("Response data : ${_response.data}");
      _coinDetail = _response.data;
      // print(_coinDetail);
      print("Success");
      setState(() {
        _isLoading = false;
      });
    } on DioError catch (e) {
      String errorMessage = e.response!.data.toString();
      print("Error message : $errorMessage");
      switch (e.type) {
        case DioErrorType.connectTimeout:
          break;
        case DioErrorType.sendTimeout:
          break;
        case DioErrorType.receiveTimeout:
          break;
        case DioErrorType.response:
          errorMessage = e.response!.data["error"];
          break;
        case DioErrorType.cancel:
          break;
        case DioErrorType.other:
          break;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCoinDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFCECECE),
                    const Color(0xFFFAA6EF),
                  ],
                  begin: const FractionalOffset(0.0, 1.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 40),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        // color: Colors.red,
                        height: 50,
                        child: Center(
                            child: Text(
                          "COIN DETAIL",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5),
                        )),
                      ),
                      LiquidPullToRefresh(
                        color: Colors.transparent,
                        backgroundColor: Colors.black54,
                        springAnimationDurationInMilliseconds: 500,
                        showChildOpacityTransition: false,
                        onRefresh: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await getCoinDetail();
                        },
                        child: (_isLoading == true)
                            ? CoinDetailShimmerWidget()
                            : Container(
                                // color: Colors.red,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                height: 600,
                                child: CustomScrollView(
                                  slivers: [
                                    SliverList(
                                        delegate: SliverChildListDelegate([
                                      Container(
                                        // color: Colors.amber,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              child: Image.network(
                                                  "${_coinDetail['image']['small']}]"),
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "${_coinDetail['name']} (${_coinDetail['symbol'].toUpperCase()})",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                              // height: 30,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white54,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      "#${_coinDetail['market_cap_rank']}",
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "\$${formatter.format(_coinDetail['market_data']['current_price']['usd'])}",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            SizedBox(width: 6),
                                            (_coinDetail['market_data'][
                                                            'price_change_percentage_24h_in_currency']
                                                        ['usd'] >
                                                    0)
                                                ? Row(
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .arrow_drop_up_sharp,
                                                          color: Colors
                                                              .green[600]),
                                                      Text(
                                                        "(${percentageFormat.format(_coinDetail['market_data']['price_change_percentage_24h_in_currency']['usd'])}%)",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .green[700]),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .arrow_drop_down_sharp,
                                                          color: Colors.red),
                                                      Text(
                                                          "(${percentageFormat.format(_coinDetail['market_data']['price_change_percentage_24h_in_currency']['usd'])}%)",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.red)),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: (_coinDetail['market_data']
                                                    ['price_change_24h'] >
                                                0)
                                            ? Text(
                                                (_coinDetail['market_data'][
                                                                'current_price']
                                                            ['usd'] <
                                                        2)
                                                    ? "+${formatter.format(_coinDetail['market_data']['price_change_24h'])}"
                                                    : "+${percentageFormat.format(_coinDetail['market_data']['price_change_24h'])}",
                                                style: TextStyle(
                                                    color: Colors.green[700]),
                                              )
                                            : Text(
                                                (_coinDetail['market_data'][
                                                                'current_price']
                                                            ['usd'] <
                                                        2)
                                                    ? "${formatter.format(_coinDetail['market_data']['price_change_24h'])}"
                                                    : "${percentageFormat.format(_coinDetail['market_data']['price_change_24h'])}",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                          width: double.infinity,
                                          height: 25,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _coinDetail['categories']
                                                .length,
                                            itemBuilder: (context, i) => Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  alignment: Alignment.center,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black26,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7)),
                                                  child: Text(
                                                      "${_coinDetail['categories'][i]}",
                                                      style: TextStyle(
                                                          color: Colors.white54,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                SizedBox(width: 5),
                                              ],
                                            ),
                                          )),
                                      Divider(
                                          color: Colors.white54, thickness: 2),
                                      SizedBox(height: 10),
                                      SingleChildScrollView(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Row(children: [
                                                  Text("High 24H"),
                                                  Spacer(),
                                                  Text(
                                                      "\$${formatter.format(_coinDetail['market_data']['high_24h']['usd'])}")
                                                ]),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                child: Row(children: [
                                                  Text("Low 24H"),
                                                  Spacer(),
                                                  Text(
                                                      "\$${formatter.format(_coinDetail['market_data']['low_24h']['usd'])}")
                                                ]),
                                              ),
                                              Divider(
                                                  color: Colors.white54,
                                                  thickness: 2),
                                              SizedBox(height: 5),
                                              Container(
                                                child: Row(children: [
                                                  Text("All Time High"),
                                                  Spacer(),
                                                  Text(
                                                      "\$${formatter.format(_coinDetail['market_data']['ath']['usd'])}")
                                                ]),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                child: Row(children: [
                                                  Text("Market Cap"),
                                                  Spacer(),
                                                  Text(
                                                      "\$${formatter.format(_coinDetail['market_data']['market_cap']['usd'])}")
                                                ]),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                child: Row(children: [
                                                  Text("24H Trading Volume"),
                                                  Spacer(),
                                                  Text(
                                                      "\$${formatter.format(_coinDetail['market_data']['total_volume']['usd'])}")
                                                ]),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                child: Row(children: [
                                                  Text("Circulation Supply"),
                                                  Spacer(),
                                                  Text(
                                                      "\$${formatter.format(_coinDetail['market_data']['circulating_supply'])}")
                                                ]),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                child: Row(children: [
                                                  Text("Total Supply"),
                                                  Spacer(),
                                                  Text((_coinDetail[
                                                                  'market_data']
                                                              [
                                                              'total_supply'] ==
                                                          null)
                                                      ? "-"
                                                      : "${_coinDetail['market_data']['total_supply']}")
                                                ]),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                child: Row(children: [
                                                  Text("Max Supply"),
                                                  Spacer(),
                                                  Text((_coinDetail[
                                                                  'market_data']
                                                              ['max_supply'] ==
                                                          null)
                                                      ? "-"
                                                      : "${_coinDetail['market_data']['max_supply']}")
                                                ]),
                                              ),
                                              Divider(
                                                  color: Colors.white54,
                                                  thickness: 2),
                                              SizedBox(height: 5),
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Description",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Container(
                                                      height: 250,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Text((_coinDetail[
                                                                        'description']
                                                                    ['en'] ==
                                                                "")
                                                            ? "-"
                                                            : "${_coinDetail['description']['en']}"),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]))
                                  ],
                                ),
                              ),
                      ),
                    ]),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Developed by Kevin Lauren",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12)),
                          Text(
                            "Powered by CoinGecko API",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:coingecko_coinlist/src/ui/home/coin_detail_page.dart';
import 'package:coingecko_coinlist/src/widgets/coin_list_shimmer_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var coinLists;
  var _listCoin = [];
  // final formatter = intl.NumberFormat.decimalPattern();
  final formatter = intl.NumberFormat("#,##0.0######"); // for price change
  final percentageFormat = intl.NumberFormat("##0.0#"); // for price change
  Timer? _timer;
  int _itemPerPage = 1, _currentMax = 10;
  bool _isLoading = true;

  ScrollController _scrollController = ScrollController();

  void refreshWithTimer(_startTime, runTimer) {
    // isTimerRun = true;
    const oneMin = const Duration(minutes: 1);
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (runTimer == false) {
        timer.cancel();
        print('Timer turned off');
      } else {
        if (_startTime == 0) {
          getCoinList();
          // refreshWithTimer(30, true);
        } else {
          // setState(() {
          setState(() {
            _startTime--;

            print("Timer $_startTime");
          });
        }
      }
    });
  }

  getCoinList() async {
    Dio _dio = new Dio();
    Response _response;
    try {
      _response = await _dio.get(
          "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=$_itemPerPage&sparkline=false");
      print("Response data : ${_response.data}");
      // _listCoin = _response.data;
      if (_listCoin == null) {
        _listCoin = List.generate(10, (i) => _response.data[i]);
      } else {
        int j = 0;
        for (int i = _currentMax; i < _currentMax + 10; i++) {
          _listCoin.add(_response.data[j]);
          j++;
        }
      }
      print("Success");
      _isLoading = false;

      setState(() {});
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
      _isLoading = false;
      setState(() {});
    }
  }

  _getMoreData() {
    print("Load more data");
    _itemPerPage = _itemPerPage + 1;
    _currentMax = _currentMax + 10;
    getCoinList();
  }

  @override
  void initState() {
    super.initState();
    // refreshWithTimer(10, true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
    getCoinList();
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
                    const Color(0xFFFAA6EF),
                    const Color(0xFFCECECE),
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
                          "COIN LIST",
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
                            _itemPerPage = 1;
                            _currentMax = 10;
                            _listCoin.clear();
                          });
                          await getCoinList();
                        },
                        child: (_isLoading == true)
                            ? CoinListShimmerWidget()
                            : Container(
                                // color: Colors.red,
                                height: 600,
                                child: Container(
                                  // color: Colors.amber,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      controller: _scrollController,
                                      itemCount: _listCoin.length + 1,
                                      itemBuilder: (context, i) {
                                        if (i == _listCoin.length) {
                                          return CupertinoActivityIndicator();
                                        }
                                        return Bounceable(
                                          onTap: () {
                                            print("${_listCoin[i]['id']}");
                                            // ScaffoldMessenger.of(context)
                                            //     .showSnackBar(SnackBar(
                                            //         content: Text(
                                            //             "${_listCoin[i]['id']} is tapped")));
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CoinDetailPage(
                                                            coinId: _listCoin[i]
                                                                ['id'])));
                                          },
                                          child: Container(
                                            // color: Colors.blue,
                                            height: 75,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 2),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  color: Colors.black38,
                                                  child: Center(
                                                    child: Text(
                                                      "${i + 1}",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    // height: 50,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                    // margin: EdgeInsets.symmetric(vertical: 5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white24),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height: 25,
                                                          width: 25,
                                                          child: Image.network(
                                                              "${_listCoin[i]['image']}"),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                "${_listCoin[i]['symbol'].toUpperCase()}/USD"),
                                                            (_listCoin[i][
                                                                        'price_change_24h'] >
                                                                    0)
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .arrow_drop_up_sharp,
                                                                          color:
                                                                              Colors.green[600]),
                                                                      Text(
                                                                        // "${_listCoin[i]['price_change_24h']}",
                                                                        (_listCoin[i]['current_price'] <
                                                                                2)
                                                                            ? formatter.format(_listCoin[i]['price_change_24h'])
                                                                            : percentageFormat.format(_listCoin[i]['price_change_24h']),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                            fontSize: 11),
                                                                      ),
                                                                      Text(
                                                                        " (${percentageFormat.format(_listCoin[i]['price_change_percentage_24h'])}%)",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                            fontSize: 11),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .arrow_drop_down_sharp,
                                                                          color:
                                                                              Colors.red),
                                                                      Text(
                                                                        // "${_listCoin[i]['price_change_24h']}",
                                                                        (_listCoin[i]['current_price'] <
                                                                                2)
                                                                            ? formatter.format(_listCoin[i]['price_change_24h'])
                                                                            : percentageFormat.format(_listCoin[i]['price_change_24h']),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize: 10.5),
                                                                      ),
                                                                      Text(
                                                                        " (${percentageFormat.format(_listCoin[i]['price_change_percentage_24h'])}%)",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize: 11),
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        Container(
                                                          width: 80,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  "\$${formatter.format(_listCoin[i]['current_price'])}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13.5),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 3),
                                                              Row(
                                                                children: [
                                                                  Text("High",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              8)),
                                                                  Spacer(),
                                                                  Text(
                                                                    "\$${_listCoin[i]['high_24h']}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            9,
                                                                        color: Colors
                                                                            .green),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text("Low",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              8)),
                                                                  Spacer(),
                                                                  Text(
                                                                    "\$${_listCoin[i]['low_24h']}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            9,
                                                                        color: Colors
                                                                            .red),
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
                                          ),
                                        );
                                      }),
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

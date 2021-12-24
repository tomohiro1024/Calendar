import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // 現在の時刻
  DateTime _now = DateTime.now();
  // 曜日のリスト
  List<String> _weekName = [
    '月',
    '火',
    '水',
    '木',
    '金',
    '土',
    '日',
  ];

  // 現在より過去のカレンダーを表示するためのコントローラー
  PageController _pageController = PageController();

  // indexの初期値
  int initialIndex = 3;

  int monthDuration = 0;

  // カレンダーの初期位置（2022年1月1日）
  DateTime firstDay = DateTime(2021, 1, 1);

  @override
  void initState() {
    super.initState();

    initialIndex =
        (_now.year - firstDay.year) * 12 + (_now.month - firstDay.month);

    _pageController = PageController(initialPage: initialIndex);

    // ページをスクロールしたかどうか感知する
    _pageController.addListener(() {
      monthDuration = (_pageController.page! - initialIndex).round();
      // ページをスクロールした場合画面を切り替える
      setState(() {});
    });
  }

  // ↑はビルドが実行される前の状態
  // ビルドをした場合下記のコードが実行される
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${DateFormat('yyyy年 M月').format(DateTime(_now.year, _now.month + monthDuration, 1))}'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 30,
            child: Row(
              children: _weekName
                  .map((e) => Expanded(
                        child: Container(
                          child: Text(
                            e,
                            style: TextStyle(color: Colors.white),
                          ),
                          alignment: Alignment.center,
                          color: Theme.of(context).primaryColor,
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(child: buildContainer()),
        ],
      ),
    );
  }

  Widget buildContainer() {
    // ページをスワイプさせる
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, index) {
        // index(3) - initialIndex(3) = 0で今月のカレンダーを表示する。
        int _monthDuration = index - initialIndex;

        List<Widget> _list = [];
        List<Widget> _listCathe = [];

        // 現在の月の1日
        DateTime _date = DateTime(_now.year, _now.month + _monthDuration, 1);

        // 現在の時刻の月を来月の1日から1日引いた数を最終日と設定する
        int monthLastNumbar = DateTime(_date.year, _date.month + 1, 1)
            .add(Duration(days: -1))
            .day;

        // リストに日にちを表示
        for (int i = 0; i < monthLastNumbar; i++) {
          _listCathe.add(
            Expanded(
              child: Container(
                // height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      child: Text('${i + 1}'),
                    ),
                    Expanded(
                      child: Container(),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.1, color: Colors.orangeAccent)),
              ),
            ),
          );
          // iの数字が日曜日だった場合改行(改行の分岐)またはiが最後の日だった場合
          if (_date.add(Duration(days: i)).weekday == 7 ||
              i == monthLastNumbar - 1) {
            int repeatNumber = 7 - _listCathe.length;
            // 一番最後の日、iが改行の数字(7桁の数字)ではない途中の数字でもリストを表示(コンテナで空白を埋める)
            // 一番最初の日が月曜日以外だった場合コンテナで埋める
            if (i == monthLastNumbar - 1) {
              for (int j = 0; j < repeatNumber; j++) {
                _listCathe.add(Expanded(
                  child: Container(
                    color: Colors.orange.withOpacity(0.2),
                  ),
                ));
              }
            } else if (i < 7) {
              for (int j = 0; j < repeatNumber; j++) {
                _listCathe.insert(
                    0,
                    Expanded(
                      child: Container(
                        color: Colors.orange.withOpacity(0.2),
                      ),
                    ));
              }
            }

            _list.add(
              Expanded(
                child: Row(
                  children: _listCathe,
                ),
              ),
            );
            _listCathe = [];
          }
        }

        return Column(
          children: _list,
        );
      },
    );
  }
}

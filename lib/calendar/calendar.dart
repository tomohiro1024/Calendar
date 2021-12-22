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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${DateFormat('yyyy年 M月').format(_now)}'),
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
          buildContainer()
        ],
      ),
    );
  }

  Widget buildContainer() {
    List<Widget> _list = [];
    List<Widget> _listCathe = [];

    // 現在の月の1日
    DateTime _date = DateTime(_now.year, _now.month, 1);

    // 現在の時刻の月を来月の1日から1日引いた数を最終日と設定する
    int monthLastNumbar =
        DateTime(_now.year, _now.month + 1, 1).add(Duration(days: -1)).day;

    // リストに日にちを表示
    for (int i = 0; i < monthLastNumbar; i++) {
      _listCathe.add(
        Expanded(
          child: Container(
            height: 100,
            child: Text('${i + 1}'),
            decoration: BoxDecoration(
                border: Border.all(width: 0.1, color: Colors.greenAccent)),
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
              child: Container(),
            ));
          }
        } else if (i < 7) {
          for (int j = 0; j < repeatNumber; j++) {
            _listCathe.insert(
                0,
                Expanded(
                  child: Container(),
                ));
          }
        }

        _list.add(
          Row(
            children: _listCathe,
          ),
        );
        _listCathe = [];
      }
    }

    return Column(
      children: _list,
    );
  }
}

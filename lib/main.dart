import 'dart:io';
import 'package:demo/widgets/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/transaction_list.dart';
import 'widgets/new_transaction.dart';
import 'models/Transaction.dart';
import 'widgets/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: ThemeData.light().textTheme.copyWith(
              button: TextStyle(color: Colors.white),
            ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title = 'Demp app';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;

  final List<Transaction> _transaction = [
    Transaction(amount: 200, title: 'test', id: '1', date: DateTime.now()),
    Transaction(amount: 200, title: 'test', id: '1', date: DateTime.now()),
    Transaction(amount: 200, title: 'test', id: '1', date: DateTime.now()),
    Transaction(amount: 200, title: 'test', id: '1', date: DateTime.now()),
    Transaction(amount: 200, title: 'test', id: '1', date: DateTime.now()),
    Transaction(amount: 200, title: 'test', id: '1', date: DateTime.now()),
    Transaction(amount: 200, title: 'test', id: '1', date: DateTime.now()),
    Transaction(amount: 200, title: 'test', id: '1', date: DateTime.now()),
    Transaction(amount: 200, title: 'test', id: '1', date: DateTime.now()),
  ];

  List<Transaction> get _recentTransaction {
    return _transaction.where((tran) {
      return tran.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newtx = Transaction(
        title: txTitle,
        amount: txAmount,
        id: DateTime.now().toString(),
        date: txDate);

    setState(() {
      _transaction.add(newtx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transaction.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: context, builder: (_) => NewTransaction(_addNewTransaction));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Persoanl Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CupertinoButton(
                  child: Icon(CupertinoIcons.add),
                  onPressed: () => _startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(widget.title),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _startAddNewTransaction(context)),
            ],
          );

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_recentTransaction, _deleteTransaction));

    final chartWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            (isLandscape ? 0.7 : 0.3),
        child: Chart(_transaction));

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart', style: Theme.of(context).textTheme.title),
                  Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            if (!isLandscape) chartWidget,
            if (!isLandscape) txListWidget,
            if (isLandscape) _showChart ? chartWidget : txListWidget,
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddNewTransaction(context),
                    child: Icon(Icons.add),
                  ),
          );
  }
}

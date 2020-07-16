import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/coin_data_model.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidMenu() {
    List<DropdownMenuItem<String>> dropItems = [];
    for (String currencies in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(
          currencies,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        value: currencies,
      );
      dropItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
      },
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      dropdownColor: Theme.of(context).primaryColor,
    );
  }

  CupertinoPicker iOSMenu() {
    List<Text> pickerItems = [];

    for (String currencies in currenciesList) {
      pickerItems.add(Text(currencies));
    }
    return CupertinoPicker(
      backgroundColor: Theme.of(context).primaryColor,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(CryptoCard(
        value: isWaiting ? '?' : coinValues[crypto],
        selectedCurrency: selectedCurrency,
        cryptoCurrency: crypto,
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BitCoin Tracker',
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            makeCards(),
            Container(
              height: 110,
              padding: EdgeInsets.only(bottom: 30),
              alignment: Alignment.center,
              color: Theme.of(context).primaryColor,
              child: Platform.isIOS ? iOSMenu() : androidMenu(),
            )
          ],
        ),
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  CryptoCard({this.value, this.selectedCurrency, this.cryptoCurrency});

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Card(
        color: Theme.of(context).primaryColor,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 28,
          ),
          child: Center(
            child: Text(
              '1 $cryptoCurrency = $value $selectedCurrency',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const _urlAPIMoeda = "https://api.hgbrasil.com/finance?key=aff43f49";
Map<String, dynamic> _listamoedas = Map<String, dynamic>();
void main() async {
  runApp(MaterialApp(home: Home()));
}

Future<Map> getMoedas() async {
  //biblioteca terceiro - http: ^0.12.0+4
  http.Response response = await http.get(_urlAPIMoeda);
  Map<String, dynamic> retorno = json.decode(
          response.body.replaceAll("\"source\":\"BRL\"\,", ""))["results"]
      ["currencies"];
  return retorno;
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  @override
  void initState() {
    super.initState();
    getMoedas().then((data) {
      setState(() {
        _listamoedas = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(1, 16, 42, 1),
        // appBar: AppBar(
        //   title: Text("Moedas!"),
        //   backgroundColor: Color.fromRGBO(1, 16, 42, 1),
        //   centerTitle: true,
        // ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
              height: 100,
              child: Text(
                "Veja a cotação do dia",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height - 100,
                child: RefreshIndicator(
                  onRefresh: () async {
                    getMoedas().then((data) {
                      setState(() {
                        _listamoedas = data;
                      });
                    });
                  },
                  child: GridView.builder(
                    itemCount: _listamoedas.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return _moedaCard(context, index);
                    },
                  ),
                ))
          ],
        ));
  }
}

Widget _moedaCard(BuildContext context, int index) {
  String moeda = _listamoedas.keys.elementAt(index);
  var valor = _listamoedas.values.elementAt(index)["buy"];

  return Card(
    color: Color.fromRGBO(26, 40, 65, 1),
    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    elevation: 15,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //biblioteca terceiro - gradient_text: ^1.0.2
        GradientText("$moeda",
            gradient: LinearGradient(colors: [
              Colors.blue[100],
              Colors.blueAccent[200],
              Colors.lightBlue[300]
            ]),
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center),
        Divider(
          color: Color.fromRGBO(26, 40, 65, 1),
        ),
        Text(
          "Valor: R\$ $valor",
          style: TextStyle(color: Colors.white, fontSize: 15),
        )
      ],
    ),
  );
}

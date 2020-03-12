import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const _urlAPIMoeda = "https://api.hgbrasil.com/finance?key=aff43f49";
void main() async {
  runApp(MaterialApp(home: Home()));
  print(await getMoedas());
}

Future<Map> getMoedas() async {
  http.Response retorno = await http.get(_urlAPIMoeda);
  return json.decode(retorno.body)["results"]["currencies"];
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          title: Text("Moedas!"),
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: FutureBuilder(
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: Text(
                          "Carregando Dados",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      );
                    case ConnectionState.done:
                      dolar = snapshot.data["USD"]["buy"];
                      euro = snapshot.data["EUR"]["buy"];
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text("valor Dolar = $dolar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            Divider(),
                            Text("valor Euro = $euro",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            Divider(),
                            MeuTextField("Dolar", "US\$"),
                            Divider(),
                            MeuTextField("Dolar", "€"),
                            Container(
                              height: 40,
                              child: RaisedButton(
                                  child: Text(
                                    "Atualizar",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  color: Colors.purple,
                                  onPressed: () {
                                    setState(() {
                                      getMoedas();
                                    });
                                  }),
                            )
                          ],
                        ),

                        // child: Text(
                        //   "valor dolar = $dolar | valor euro = $euro",
                        //   style: TextStyle(color: Colors.white, fontSize: 20),
                        // ),
                      );

                      break;
                    default:
                      if (snapshot.error) {
                        return Center(
                          child: Text(
                            "Ocorreu algum erro! Tente novamente mais tarde",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        );
                      }
                  }
                },
                future: getMoedas(),
              ),
            )));
  }
}

Widget MeuTextField(String label, String prefix) {
  return TextField(
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(color: Colors.white, fontSize: 20));
}

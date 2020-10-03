import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
const request= 'https://api.hgbrasil.com/finance?key=a7579f85';

void main() async{
  await getData();
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        hintStyle: TextStyle(color: Colors.amber),
    )),)

  );
}
Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  double dolar;
  double euro;
  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }
  void _realChanged(String texto) {
    if(texto.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(texto);
    dolarController.text=(real/dolar).toStringAsFixed(2);
    euroController.text=(real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String texto) {
    if(texto.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(texto);
    realController.text=(dolar*this.dolar).toStringAsFixed(2);
    euroController.text=(dolar*this.dolar/euro).toStringAsFixed(2);
  }
  void _euroChanged(String texto) {
    if(texto.isEmpty) {
      _clearAll();
      return;
    }
    double euro=double.parse(texto);
    realController.text=(euro*this.euro).toStringAsFixed(2);
    dolarController.text=(euro*this.euro/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(" Coversor de Moedas"),
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context,snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados",
                  style: TextStyle(
                  color: Colors.amber,
                  fontSize: 30),
                textAlign:TextAlign.center,
              ));
              default:
                if(snapshot.hasError){
                  return Center(child: Text("Deu Erro :(",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 30),
                    textAlign:TextAlign.center,
                  ));
                }
                else{
                  dolar= snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro= snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding:EdgeInsets.all(20),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on_outlined, size:140,color: Colors.amber),
                        Divider(),
                          campodeTexto("Reais","R\$",realController,_realChanged),
                        Divider(),
                        campodeTexto("Dolares", "US\$",dolarController,_dolarChanged),
                        Divider(),
                        campodeTexto("Euros", "€",euroController,_euroChanged),
                      ],
                    ),
                  );
                }
          }
        },
      ),
    );
  }
}

Widget campodeTexto(String campo, String prefixo,TextEditingController c,Function f){

  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: campo,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefixo,
    ),
    onChanged:f,
    keyboardType: TextInputType.number,
  );

}


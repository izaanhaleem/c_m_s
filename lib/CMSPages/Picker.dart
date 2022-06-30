// ignore_for_file: file_names, unnecessary_new
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class Picker extends StatefulWidget {
   Picker({Key? key}) : super(key: key);


  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {

  @override
  void initState() {
    super.initState();
  }

  var i=1;
  var nb_num=49;
  var no_select=[];
  var no_a_select=5;

  List<Color> colorList = List<Color>.generate(49, (int index) => Colors.lightBlue);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: new AppBar(
          title: new Text('GRILLE DE LOTTO'),
        ),
        body:
        Center(
            child: Column(
                children: <Widget>[
                  Container(
                    width:400,
                    height:30,
                    margin: const EdgeInsets.only(top: 10.0),
                    child : new Text("Selectionnez 5 numéros",textAlign: TextAlign.center,style: TextStyle(fontSize: 30.0),),
                  ),
                  Container(
                    width:400,
                    height:300,
                    child: new GridView.count(
                      crossAxisCount: 9,
                      padding: const EdgeInsets.all(30.0),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      children: new List<Widget>.generate(49, (index) {
                        return new GestureDetector(
                          onTap: () {
                            setState(() {
                              if (colorList[index] == Colors.lightBlue) {
                                if (no_select.length<no_a_select) {
                                  colorList[index] = Colors.redAccent;
                                  no_select.add(index+1);
                                }
                                else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text("INFORMATION"),
                                          content: Text("Vous ne pouvez pas sélectionner plus de 5 numéros !!!"),
                                        );
                                      }
                                  );
                                }
                                print(no_select);
                              }
                              else {
                                colorList[index] = Colors.lightBlue;
                                no_select.remove(index+1);
                                print(no_select);
                              }
                            });
                          },
                          child: Container(
                            child: ClipOval(
                              child: Container(
                                color: colorList[index],
                                height: 20.0,
                                width: 20.0,
                                child: Center(
                                  child: new Text((index+1).toString(),
                                      style: TextStyle(color: Colors.white, fontSize: 24),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      ),
                    ),
                  ),
                  Container(
                    width:400,
                    height:30,
                    margin: const EdgeInsets.only(top: 10),
                    child : new Text("Vos Numéros",textAlign: TextAlign.center,style: TextStyle(fontSize: 30.0),),
                  ),
                  Container(
                      width:400,
                      height:80,
                      margin: const EdgeInsets.only(top: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.lightBlueAccent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                      getWidget()
                  ),
                  Container(
                    width:300,
                    height:45,
                    margin: const EdgeInsets.only(top: 10.0),
                    child:
                    RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                      child: Text('TIRAGE ALEATOIRE'),
                      onPressed: () {
                        Select_numbers();
                      },
                    ),
                  ),
                  Container(
                    width:300,
                    height:45,
                    margin: const EdgeInsets.only(top: 10.0),
                    child:
                    RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                      child: Text('VALIDER VOTRE GRILLE'),
                      onPressed: () {
                        Valide_grille();
                      },
                    ),
                  ),
                ]
            )
        ),
      ),
    );
  }

  getWidget() {
    if (no_select.length==0) {
      return Text("Pas de numéros");
    }
    else {
      return GridView.count(
          crossAxisCount: 5,
          padding: const EdgeInsets.all(10.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: new List<Widget>.generate(no_select.length, (index) {
            return  ClipOval(
              child: Container(
                color: Colors.red,
                height: 20.0,
                width: 20.0,
                child: Center(
                  child: new Text((no_select[index].toString()),
                      style: TextStyle(color: Colors.white, fontSize: 24),
                      textAlign: TextAlign.center),
                ),
              ),
            );
          }
          )
      );
    }
  }

  Select_numbers() {
    setState(() {
      var j = 1;
      var num_sel;
      var pos_sel;
      no_select=[];
      colorList=[];
      colorList=List<Color>.generate(49, (int index) => Colors.lightBlue);
      var rng = new Random();
      List tab=[];
      tab = List.generate(49, (int index) => index + 1);
      print (tab);
      while (j <= no_a_select) {
        pos_sel = rng.nextInt(tab.length-1);
        num_sel=tab[pos_sel];
        no_select.add(num_sel);
        colorList[num_sel-1] = Colors.redAccent;
        tab.remove(num_sel);
        print(tab);
        j++;
      }
      print(no_select);
    });
  }

  Future Valide_grille() async{
    // For CircularProgressIndicator.
    bool visible = false ;
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true ;
    });

    // SERVER LOGIN API URL
    var url = 'https://www.easytrafic.fr/game_app/valide_lotto.php';

    // Store all data with Param Name.
    var data = {'id_membre' 'result':no_select};

    print (data);

    var grille_encode=jsonEncode(data);

    print(grille_encode);

    // Starting Web API Call.
    var globals;
    var response = await http.post(Uri.parse(url), body: grille_encode,headers: {'content-type': 'application/json','accept': 'application/json','authorization': globals.token});

    print(response.body);

    // Getting Server response into variable.
    var message = json.decode(response.body);

    // If the Response Message is Matched.
    if(message == 'OK')
    {
      print('VALIDATION DE LA GRILLE OK');
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

    }else{
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(message),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
import 'dart:convert';

import 'package:combined/HomePage.dart';
import 'package:combined/Register.dart';
import 'package:flutter/material.dart';
import 'package:sql_conn/sql_conn.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController kullaniciAdiController = TextEditingController();
  TextEditingController sifreController = TextEditingController();
  String? kullaniciAdi;
  String? sifre;
  String? sifreVeritabani;

  void dispose() {
    kullaniciAdiController.dispose();
    sifreController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      connect(context);
    });
  }

  Future<void> sorgula() async {
    var result = await SqlConn.readData(
        "SELECT Sifre FROM Users WHERE Kullanici_Adi = '$kullaniciAdi'");
    debugPrint(result.toString());
    setState(() {
      sifreVeritabani = result.toString();
    });

    var data = json.decode(result);
    if (data.isNotEmpty) {
      var firstObject = data[0];
      sifreVeritabani = firstObject['Sifre'].toString();
    } else {
      sifreVeritabani = null;
    }
  }

  Future<void> connect(BuildContext ctx) async {
    debugPrint("Connecting...");
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("LOADING"),
            content: CircularProgressIndicator(),
          );
        },
      );
      await SqlConn.connect(
          ip: "89.252.135.34",
          port: "1433",
          databaseName: "ilk",
          username: "sa",
          password: "AliMertPau1");
      debugPrint("Connected!");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(child: Text('Giriş Yap')),
      ),
      bottomSheet: Container(
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kayıtlı değil misiniz?",
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
              child: Text(
                "Kayıt Ol.",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),
              ),
            )
          ],
        ),
      ),
      body: Container(
        color: Colors.purple[100],
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "COMBINED",
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 45,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: kullaniciAdiController,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: sifreController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.purple),
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: Text('Giriş Yap'),
                onPressed: () async {
                  setState(() {
                    kullaniciAdi = kullaniciAdiController.text;
                    sifre = sifreController.text;
                  });

                  await sorgula();

                  if (sifre == sifreVeritabani) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(kullaniciAdi: kullaniciAdi)),
                    );

                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Hata"),
                          content: Text("Kullanıcı adı veya şifre hatalı."),
                          actions: [
                            TextButton(
                              child: Text("Tamam"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

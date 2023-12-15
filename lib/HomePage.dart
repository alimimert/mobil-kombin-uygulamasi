import 'dart:convert';

import 'package:combined/sql_conn.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final String? kullaniciAdi;

  const HomePage({Key? key, required this.kullaniciAdi}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  String? selectedMekan;
  bool showOtherItems = false; // Ekstra öğeleri göstermek için bir bayrak
  late final String? kullaniciAdi;
  String? SevilenRenk = null;
  String? SecilenAksesuar = null;
  String? SecilenUst = null;
  String? SecilenAlt = null;

  String? linkAksesuar = null;
  String? linkUst = null;
  String? linkAlt = null;



  Future<void> sorgula() async {
    var result = await SqlConn.readData(
        "SELECT Sevilen_Renk FROM Users WHERE Kullanici_Adi = '${widget.kullaniciAdi}';");
    debugPrint(result.toString());
    setState(() {
      SevilenRenk = result.toString();
    });

    var data = json.decode(result);
    if (data.isNotEmpty) {
      var firstObject = data[0];
      SevilenRenk = firstObject['Sevilen_Renk'].toString();
    } else {
      SevilenRenk = null;
    }
  }
  Future<void> VeriGetirAksesuar() async {
    var result = await SqlConn.readData(
        "SELECT ${SevilenRenk}_Aksesuar FROM $selectedMekan WHERE ID = 1;");
    debugPrint(result.toString());
    setState(() {
      SecilenAksesuar = result.toString();
    });

    var data = json.decode(result);
    if (data.isNotEmpty) {
      var firstObject = data[0];
      SecilenAksesuar = firstObject['${SevilenRenk}_Aksesuar'].toString();
    } else {
      SecilenAksesuar = null;
    }
  }
  Future<void> VeriGetirUst() async {
    var result = await SqlConn.readData(
        "SELECT ${SevilenRenk}_Ust FROM $selectedMekan WHERE ID = 1;");
    debugPrint(result.toString());
    setState(() {
      SecilenUst = result.toString();
    });

    var data = json.decode(result);
    if (data.isNotEmpty) {
      var firstObject = data[0];
      SecilenUst = firstObject['${SevilenRenk}_Ust'].toString();
    } else {
      SecilenUst = null;
    }
  }
  Future<void> VeriGetirAlt() async {
    var result = await SqlConn.readData(
        "SELECT ${SevilenRenk}_Alt FROM $selectedMekan WHERE ID = 1;");
    debugPrint(result.toString());
    setState(() {
      SecilenAlt = result.toString();
    });

    var data = json.decode(result);
    if (data.isNotEmpty) {
      var firstObject = data[0];
      SecilenAlt = firstObject['${SevilenRenk}_Alt'].toString();
    } else {
      SecilenAlt = null;
    }
  }
  Future<void> AksesuarLink() async {
    var result = await SqlConn.readData(
        "SELECT ${SevilenRenk}_Aksesuar FROM $selectedMekan WHERE ID = 2;");
    debugPrint(result.toString());
    setState(() {
      linkAksesuar = result.toString();
    });

    var data = json.decode(result);
    if (data.isNotEmpty) {
      var firstObject = data[0];
      linkAksesuar = firstObject['${SevilenRenk}_Aksesuar'].toString();
    } else {
      linkAksesuar = null;
    }
  }
  Future<void> UstLink() async {
    var result = await SqlConn.readData(
        "SELECT ${SevilenRenk}_Ust FROM $selectedMekan WHERE ID = 2;");
    debugPrint(result.toString());
    setState(() {
      linkUst = result.toString();
    });

    var data = json.decode(result);
    if (data.isNotEmpty) {
      var firstObject = data[0];
      linkUst = firstObject['${SevilenRenk}_Ust'].toString();
    } else {
      linkUst = null;
    }
  }
  Future<void> AltLink() async {
    var result = await SqlConn.readData(
        "SELECT ${SevilenRenk}_Alt FROM $selectedMekan WHERE ID = 2;");
    debugPrint(result.toString());
    setState(() {
      linkAlt = result.toString();
    });

    var data = json.decode(result);
    if (data.isNotEmpty) {
      var firstObject = data[0];
      linkAlt = firstObject['${SevilenRenk}_Alt'].toString();
    } else {
      linkAlt = null;
    }
  }

  launchAksesuar() async {
    final Uri url = Uri.parse(linkAksesuar!);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch');
    }
  }
  launchUst() async {
    final Uri url2 = Uri.parse(linkUst!);
    if (!await launchUrl(url2)) {
      throw Exception('Could not launch');
    }
  }
  launchAlt() async {
    final Uri url3 = Uri.parse(linkAlt!);
    if (!await launchUrl(url3)) {
      throw Exception('Could not launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'COMBINED',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple, // Mor renk
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text(
              'Hoş geldiniz, ${widget.kullaniciAdi}!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.purple),
                  ),
                ],
              ),
            ),
            SizedBox(height: 9),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                value: selectedMekan,
                decoration: InputDecoration(
                  labelText: 'Mekan seçiniz...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'P',
                    child: Text('Parti'),
                  ),
                  DropdownMenuItem(
                    value: 'O',
                    child: Text('Ofis'),
                  ),
                  DropdownMenuItem(
                    value: 'T',
                    child: Text('Tatil'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedMekan = value;
                  });
                },
              ),
            ),
            SizedBox(height: 15),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.purple),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text('Onayla'),
              onPressed: () {
                sorgula();
                if (selectedMekan == null) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Hata'),
                        content: Text('Lütfen Mekan Seçiniz'),
                        actions: [
                          ElevatedButton(
                            child: Text('Tamam'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.purple),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text('Kıyafet getir.'),
              onPressed: () {
                VeriGetirAksesuar();
                VeriGetirUst();
                VeriGetirAlt();
                AksesuarLink();
                UstLink();
                AltLink();
                if (selectedMekan == null) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Hata'),
                        content: Text('Lütfen Mekan Seçiniz'),
                        actions: [
                          ElevatedButton(
                            child: Text('Tamam'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  setState(() {
                    showOtherItems = true; // Onayla butonuna basıldığında diğer öğeleri göster
                  });
                }
              },
            ),
            SizedBox(height: 15),
            if (showOtherItems) ...[
              Text(
                "Aksesuar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  launchAksesuar();
                },
                child: Container(
                  child: Image.network(SecilenAksesuar!),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  height: 200,
                  width: 180,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Üst",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  launchUst();
                },
                child: Container(
                  child: Image.network(SecilenUst!),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  height: 200,
                  width: 180,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Alt",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: (){
                  launchAlt();
                },
                child: Container(
                  child: Image.network(SecilenAlt!),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  height: 200,
                  width: 180,
                ),
              ),
              SizedBox(height: 15),
            ],
          ],
        ),
      ),
    );
  }
}
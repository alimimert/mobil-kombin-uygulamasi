import 'package:combined/HomePage.dart';
import 'package:combined/LoginPage.dart';
import 'package:combined/sql_conn.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController adController = TextEditingController();
  TextEditingController soyadController = TextEditingController();
  TextEditingController kullaniciAdiController = TextEditingController();
  TextEditingController sifreController = TextEditingController();

  String? selectedRenk;
  String? selectedTarz;
  String? Ad;
  String? Soyad;
  String? KullaniciAdi;
  String? Sifre;

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

  Future<void> Kaydolma() async {
    var gramaj = await SqlConn.readData(
        "INSERT INTO Users (Ad, Soyad, Kullanici_Adi, Sifre, Sevilen_Renk, Tarz) VALUES ('$Ad', '$Soyad', '$KullaniciAdi', '$Sifre', '$selectedRenk', '$selectedTarz')");
    debugPrint(gramaj.toString());
    setState(() {
      //KumasGramajData = gramaj.toString();
    });
  }

  @override
  void dispose() {
    adController.dispose();
    soyadController.dispose();
    kullaniciAdiController.dispose();
    sifreController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(
            child: Text('Kayıt Ol')
        ),
        automaticallyImplyLeading: false,

      ),
      backgroundColor: Colors.purple[100],
      bottomSheet: Container(
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Zaten üye misiniz?",
                style: TextStyle(
                    fontSize: 17
                ),),
              SizedBox(width: 10),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => LoginPage()));
                },
                child: Text("Giriş Yap.",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple
                  ),),
              )
            ],
          )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Text("COMBINED",
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 45,
                  fontWeight: FontWeight.bold
              ),),
            SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: adController,
                decoration: InputDecoration(
                  labelText: 'Ad:',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: soyadController,
                //obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Soyad:',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: kullaniciAdiController,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı:',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: sifreController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre:',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Hangi renk senin tarzını yansıtır ?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.purple
                  ),),
                ],
              ),
            ),
            SizedBox(height: 9),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                value: selectedRenk,
                decoration: InputDecoration(
                  labelText: 'Renk Seçiniz...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Koyu',
                    child: Text('Koyu Renkler'),
                  ),
                  DropdownMenuItem(
                    value: 'Canli',
                    child: Text('Canlı Renkler'),
                  ),
                  DropdownMenuItem(
                    value: 'Soft',
                    child: Text('Soft Renkler'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRenk = value;
                  });
                },
              ),
            ),

            SizedBox(height: 25.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text("Hangi Yaş Grubundasınız ?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.purple
                    ),),
                ],
              ),
            ),
            SizedBox(height: 9),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                value: selectedTarz,
                decoration: InputDecoration(
                  labelText: 'Yaşınızı Seçiniz...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Şık',
                    child: Text('18-23'),
                  ),
                  DropdownMenuItem(
                    value: 'Spor',
                    child: Text('23-26'),
                  ),
                  DropdownMenuItem(
                    value: 'Günlük',
                    child: Text('26-30'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedTarz = value;
                  });
                },
              ),
            ),

            SizedBox(height: 30.0),


            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text('Kayıt Ol'),
              onPressed: () {
                if (adController.text.isEmpty ||
                    soyadController.text.isEmpty ||
                    kullaniciAdiController.text.isEmpty ||
                    sifreController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Boş Geçilemez"),
                        content: Text("Lütfen tüm alanları doldurun."),
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
                } else {
                  setState(() {
                    Sifre = sifreController.text;
                    Ad = adController.text;
                    Soyad = soyadController.text;
                    KullaniciAdi = kullaniciAdiController.text;
                  });
                  Kaydolma();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Kayıt Başarılı"),
                        content: Text("Lütfen giriş yap."),
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
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}

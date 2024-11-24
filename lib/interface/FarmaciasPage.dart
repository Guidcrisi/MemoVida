import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:memovida/data/farmaciasService.dart';
import 'package:memovida/interface/EmergenciaPage.dart';
import 'package:memovida/interface/HomePage.dart';
import 'package:memovida/main.dart';
import 'package:url_launcher/url_launcher.dart';

class FarmaciasPage extends StatefulWidget {
  const FarmaciasPage({super.key});

  @override
  State<FarmaciasPage> createState() => _FarmaciasPageState();
}

class _FarmaciasPageState extends State<FarmaciasPage> {
  bool _isLoading = false;
  List farmacias = [];
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const EmergenciaPage(),
            ));
        break;
      default:
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    setState(() {
      _isLoading = true;
    });
    await FarmaciasService.getFarmacias().then((value) {
      setState(() {
        farmacias = value;
      });
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: App.primary,
        centerTitle: true,
        title: const Text(
          "Farmácias",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: App.primary, size: 65),
            )
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: farmacias.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            Clipboard.setData(ClipboardData(
                                text: farmacias[index]['contato']));
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Número de telefone copiado")));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                )
                              ],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: ListTile(
                              trailing: IconButton(
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse(
                                          "tel:${farmacias[index]['contato']}"),
                                    );
                                  },
                                  icon: const Icon(FontAwesomeIcons.phone)),
                              title: Text(
                                "Nome: ${farmacias[index]['nome']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  "Telefone: ${farmacias[index]['contato']}"),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: App.primary,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.pills),
            label: 'Medicamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidHospital),
            label: 'Farmácias',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.phone),
            label: 'Emergência',
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:memovida/interface/CadastroMedicamentoPage.dart';
import 'package:memovida/interface/EmergenciaPage.dart';
import 'package:memovida/interface/FarmaciasPage.dart';
import 'package:memovida/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Filters { tomou, remover }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  List<Map<String, String>> medicamentos = [];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 1:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FarmaciasPage(),
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
    await getMedicamentos();
    setState(() {
      _isLoading = false;
    });
  }

  getMedicamentos() async {
    setState(() {
      medicamentos = [];
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final String? recordsJson = prefs.getString('records');

    if (recordsJson != null) {
      // Decodifica o JSON para List<Map<String, String>>
      List<dynamic> decodedList = jsonDecode(recordsJson);
      setState(() {
        medicamentos = decodedList.map((item) {
          return Map<String, String>.from(item);
        }).toList();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveRecord() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('records', jsonEncode(medicamentos));
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
          "MemoVida",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: App.primary,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CadastroMedicamentoPage(),
              )).then((value) {
            getMedicamentos();
          });
        },
        child: const Icon(
          FontAwesomeIcons.plus,
          color: Colors.white,
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
                    medicamentos.isEmpty
                        ? const Center(
                            child: Text(
                              "Nenhum medicamento cadastrado. Você pode cadastrar um medicamento clicando no botão azul no canto inferior direito da sua tela",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: medicamentos.length,
                            itemBuilder: (context, index) {
                              final medicamento = medicamentos[index];
                              return Container(
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
                                  trailing: PopupMenuButton(
                                    tooltip: "Opções",
                                    icon: const Icon(
                                      FontAwesomeIcons.ellipsisVertical,
                                      color: Colors.black,
                                    ),
                                    itemBuilder: (context) =>
                                        <PopupMenuEntry<Filters>>[
                                      const PopupMenuItem<Filters>(
                                        value: Filters.tomou,
                                        child: Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.check,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Tomei o medicamento",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem<Filters>(
                                        value: Filters.remover,
                                        child: Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.trash,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Remover",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) async {
                                      if (value == Filters.tomou) {
                                        final agora = DateTime.now();

                                        final periodo = medicamento['periodo'];
                                        final partes = periodo?.split(':');
                                        final horas = int.parse(partes![0]);
                                        final minutos = int.parse(partes[1]);

                                        final novaHora = agora.add(Duration(
                                            hours: horas, minutes: minutos));

                                        medicamento['horario'] = novaHora
                                            .toString()
                                            .substring(11, 16);

                                        await _saveRecord();
                                      }

                                      if (value == Filters.remover) {
                                        setState(() {
                                          medicamentos.removeAt(index);
                                        });
                                        await _saveRecord();
                                        await getMedicamentos();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Medicamento removido com sucesso")));
                                      }
                                    },
                                  ),
                                  title: Text(
                                    "Medicamento: ${medicamento['nome']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      "${medicamento['quantidade']} vezes ao dia\ntomar de novo às ${medicamento['horario']}"),
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

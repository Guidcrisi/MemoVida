import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:memovida/main.dart';
import 'package:memovida/util/Masks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastroMedicamentoPage extends StatefulWidget {
  const CadastroMedicamentoPage({super.key});

  @override
  State<CadastroMedicamentoPage> createState() =>
      _CadastroMedicamentoPageState();
}

class _CadastroMedicamentoPageState extends State<CadastroMedicamentoPage> {
  final _nomeController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _horarioController = TextEditingController();
  final _periodoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int quantidade = 0;
  bool _isLoading = false;
  List medicamentos = [];

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
  }

  Future<void> _saveRecord() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    medicamentos.add({
      'nome': _nomeController.text,
      'quantidade': _quantidadeController.text,
      'horario': _horarioController.text,
      'periodo':
          _periodoController.text.isEmpty ? "24:00" : _periodoController.text,
    });
    await prefs.setString('records', jsonEncode(medicamentos));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Medicamento cadastrado com sucesso")));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: App.primary,
          centerTitle: true,
          title: const Text(
            "Cadastro de Medicamento",
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
                    margin: const EdgeInsets.all(15),
                    child: Container(
                      padding: const EdgeInsets.all(15),
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira aqui o nome do medicamento';
                                }
                                return null;
                              },
                              controller: _nomeController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  FontAwesomeIcons.pills,
                                ),
                                labelText: "Nome do Medicamento",
                                labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: App.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const Divider(
                              height: 20,
                              color: Colors.transparent,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira aqui a quantidade de vezes que você\ntoma este medicamento no mesmo dia';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              controller: _quantidadeController,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    quantidade = int.parse(value);
                                  });
                                } else {
                                  setState(() {
                                    quantidade = 0;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  FontAwesomeIcons.listOl,
                                ),
                                labelText:
                                    "Quantas vezes você toma o medicamento\nno mesmo dia?",
                                labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: App.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const Divider(
                              height: 20,
                              color: Colors.transparent,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.length < 5) {
                                  return 'Por favor, insira aqui o horário você toma o\nmedicamento pela primeira vez no dia';
                                }
                                return null;
                              },
                              controller: _horarioController,
                              inputFormatters: [Masks.horaFormatter],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  FontAwesomeIcons.clock,
                                ),
                                labelText:
                                    "Qual horário você toma o medicamento\npela primeira vez no dia?",
                                labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: App.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const Divider(
                              height: 20,
                              color: Colors.transparent,
                            ),
                            quantidade > 1
                                ? TextFormField(
                                    validator: (value) {
                                      if (quantidade > 1) {
                                        if (value == null || value.length < 5) {
                                          return 'Por favor, insira aqui de quantas em quantas\nhoras você toma o medicamento';
                                        }
                                        return null;
                                      }
                                    },
                                    inputFormatters: [Masks.horaFormatter],
                                    keyboardType: TextInputType.number,
                                    controller: _periodoController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        FontAwesomeIcons.listOl,
                                      ),
                                      labelText:
                                          "De quantas em quantas horas você\ntoma o medicamento?",
                                      labelStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: App.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      border: const OutlineInputBorder(),
                                    ),
                                  )
                                : const SizedBox(),
                            Divider(
                              height: quantidade > 1 ? 20 : 0,
                              color: Colors.transparent,
                            ),
                            SizedBox(
                              width: double.maxFinite,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: App.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Define a borda circular
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _saveRecord();
                                  }
                                },
                                child: Text(
                                  "Cadastrar Medicamento",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: App.fontSize,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))));
  }
}

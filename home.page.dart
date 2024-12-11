
import 'package:efact_mobile/modules/Chave.dart';

import 'package:efact_mobile/presentation/home/navigation_provider.dart';
import 'package:efact_mobile/presentation/home/widgets/CustomNavigationBar.dart';
import 'package:efact_mobile/presentation/home/widgets/FifthButton.widget.dart';
import 'package:efact_mobile/services/get_grupos_services.dart';
import 'package:efact_mobile/services/get_retrabalhos_services.dart';
import 'package:efact_mobile/services/get_unidades_services.dart';

import 'package:flutter/material.dart';
import 'package:efact_mobile/modules/TurnosAtivos.dart';
import 'package:efact_mobile/presentation/home/widgets/chart_line.widget.dart';
import 'package:efact_mobile/services/vg_unidades_services.dart';
import 'package:efact_mobile/utils/secureStorage.dart';
import 'package:efact_mobile/utils/utils_functions.dart';
import 'package:efact_mobile/utils/routes.dart';
import 'package:efact_mobile/modules/Unidades.dart';
import 'package:efact_mobile/services/turno_services.dart';

import '../login/login.page.dart';
import 'widgets/card_menu.widget.dart';
import 'widgets/gauge.widget.dart';

bool authorized = true;



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

List<String> listaDeNomesDeMesEAno = Calendar().Fate();
List<String> listaDeNomes1 = ["Geral"];
int a = 0;



List<int>? listaDeUnidadeIds = [];
List<String>? listaDeUnidadeDes = [];

List<int>? listaDeGruposIds = [];
List<String>? listaDeGruposDes = [];
List<int>? listaDeGrupoUnidadeIds = [];
List<Unidades>? exemplo;

class _HomePageState extends State<HomePage> {

  var isLoaded = false;
  var func = Calendar();

  @override
  void initState() {
    super.initState();
    getData();
  }

  var date1 = DateTime.now();


  Chave? chave;

  getData() async {
    await GetUnidadesServices().getTodasUnidades();
    await GetGruposServices().getTodosGrupos();
    await GetRetrabalhosServices().getRetrabalhos();


    if (authorized == false) {
      Navigator.pushNamed(context, Routes.login);
    }


    listaDeUnidadeIds = await retrieveTodasUnidadesIds();

    listaDeUnidadeDes = await retrieveTodasUnidadesDes();


    listaDeGruposIds = await retrieveTodosGruposIds();

    listaDeGruposDes = await retrieveTodosGruposDes();

    listaDeGrupoUnidadeIds = await retrieveTodosGruposUnidadeIds();

    String? dataDoFiltro = await retrieveData();
    int? escolhaDoTurno = await retrieveEscolhaDoTurno();


    List<TurnosAtivos>? listaDeTurnos = await TurnoServices().getTurnos();
    if (dataDoFiltro == null) {
      String mesCerto = func.acrescentarZeroNoMes(date1.month);
      String novaData = date1.year.toString() + mesCerto;

      exemplo =
      await VgUnidadesServices().getUnidades(novaData, escolhaDoTurno ?? 0);


      if (authorized == false) {
        Navigator.pushNamed(context, Routes.login);
      }


      if (empresa == null || empresa!.isEmpty) {
        Chave? chave = await retrieveChave();
        link = chave?.sEnderecoStatus;


        empresa = chave?.nome ?? "";
      }


      if (exemplo!.isEmpty) {
        var newDate = DateTime(date1.year, date1.month - 1);
        date1 = newDate;
        String novomesCertoCasoZero = func.acrescentarZeroNoMes(newDate.month);
        String novaDataCertaCasoZero = newDate.year.toString() +
            novomesCertoCasoZero;
        exemplo = await VgUnidadesServices().getUnidades(
            novaDataCertaCasoZero, escolhaDoTurno ?? 0);

        await storeData(novaDataCertaCasoZero);
      } else {
        await storeData(novaData);
      }
    } else {
      int year = int.parse(dataDoFiltro.substring(0, 4));
      int month = int.parse(dataDoFiltro.substring(4, 6));

      var newDate = DateTime(year, month);
      date1 = newDate;
      exemplo =
      await VgUnidadesServices().getUnidades(dataDoFiltro, escolhaDoTurno ?? 0);
    }

    List<int> listaDeInt = []; // Initialize an empty list

// Check if listaDeTurnos is not null
    if (listaDeTurnos != null) {
      // Add all turnoIds to listaDeInt
      for (var turno in listaDeTurnos) {
        listaDeInt.add(turno.turnoId);
      }
    }


    List<String> listaDeStrings = []; // Initialize an empty list

// Check if listaDeTurnos is not null
    if (listaDeTurnos != null) {
      // Add all descricoes to listaDeStrings
      for (var turno in listaDeTurnos) {
        listaDeStrings.add(turno.descricao);
      }
    }


    if (a == 0) {
      listaDeNomes1.addAll(listaDeStrings);
      a = 1;
    }

    await storeTurnoIds(listaDeInt);

    if (exemplo != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }


  List<CrossFadeState> listCrossFade = [
    CrossFadeState.showFirst,
    CrossFadeState.showSecond,
    CrossFadeState.showSecond
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    const title = "Unidade de Negocio";

    final navigationProvider = NavigationProvider.of(context);
    Duration animationDuration = const Duration(milliseconds: 1000);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Visibility(
            visible: isLoaded,
            replacement: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.rotate(
                          angle: -180 * 3.1415927 / 180, // Rotate by 180 degrees
                          child: IconButton(
                            icon: const Icon(Icons.logout),
                            color: Colors.red.shade200,
                            iconSize: 30,
                            onPressed: () => Navigator.pushNamed(context, Routes.login),
                          ),
                        ),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red.shade200,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
            child: AnimatedCrossFade(
              duration: animationDuration,
              firstChild: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Transform.rotate(
                            angle: -180 * 3.1415927 / 180, // Rotate by 180 degrees
                            child: IconButton(
                              icon: const Icon(Icons.logout),
                              color: Colors.red.shade200,
                              iconSize: 30,
                              onPressed: () => Navigator.pushNamed(context, Routes.login),
                            ),
                          ),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red.shade200,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        capitalizeFirstLetterOfEachWord(empresa ?? ""),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 2.5,
                          letterSpacing: -0.44,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (link != null) ...[
                            IconButton(
                              icon: const Icon(Icons.online_prediction),
                              color: const Color.fromRGBO(10, 31, 143, 0.3),
                              iconSize: 30,
                              onPressed: () => Navigator.pushNamed(context, Routes.statusmaquinaPage),
                            ),
                            const Text(
                              'Status',
                              style: TextStyle(
                                color: Color.fromRGBO(10, 31, 143, 0.3),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: -0.5,
                              ),
                            ),
                          ] else ...[
                            IconButton(
                              icon: const Icon(Icons.account_circle),
                              color: const Color.fromRGBO(10, 31, 143, 0.3),
                              iconSize: 30,
                              onPressed: () => Navigator.pushNamed(context, Routes.Perfil1Page),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(4),
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(18, 38, 170, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${Calendar.list1[date1.month - 1]} ${date1.year}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        FifthButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            Routes.PerfilPage,
                            arguments: "/home",
                          ),
                          text: 'Alterar',
                          color: const Color.fromRGBO(107, 218, 213, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Visibility(
                      visible: isLoaded,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        itemCount: exemplo?.length,
                        itemBuilder: _itemBuilder,
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                      ),
                    ),
                  ),
                ],
              ),
              secondChild: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  if (navigationProvider.selectedIndex == 1) ...[
                    const Text(
                      "Selecionar Unidade",
                      style: TextStyle(
                        fontSize: 21,
                        color: Color.fromRGBO(18, 38, 170, 0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listaDeUnidadeDes?.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                        itemBuilder: (context, index) {
                          return Container(
                            alignment: Alignment.bottomCenter,
                            height: 40,
                            decoration: BoxDecoration(
                              border: const Border(
                                bottom: BorderSide(color: Colors.grey, width: 2),
                                top: BorderSide(color: Colors.grey, width: 1),
                                right: BorderSide(color: Colors.grey, width: 1),
                                left: BorderSide(color: Colors.grey, width: 1),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: ListTile(
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      listaDeUnidadeDes![index],
                                      style: const TextStyle(color: Colors.black, fontSize: 14),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  await storeUnidadeId(listaDeUnidadeIds![index]);
                                  await storeUnidadeDes(listaDeUnidadeDes![index]);
                                  Navigator.pushNamed(context, Routes.group);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ] else if (navigationProvider.selectedIndex == 2) ...[
                    const Text(
                      "Selecionar Grupo",
                      style: TextStyle(
                        fontSize: 21,
                        color: Color.fromRGBO(18, 38, 170, 0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listaDeGruposDes?.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                        itemBuilder: (context, index) {
                          return Container(
                            alignment: Alignment.bottomCenter,
                            height: 40,
                            decoration: BoxDecoration(
                              border: const Border(
                                bottom: BorderSide(color: Colors.grey, width: 2),
                                top: BorderSide(color: Colors.grey, width: 1),
                                right: BorderSide(color: Colors.grey, width: 1),
                                left: BorderSide(color: Colors.grey, width: 1),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: ListTile(
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      listaDeGruposDes![index],
                                      style: const TextStyle(color: Colors.black, fontSize: 14),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  await storeGrupoId(listaDeGruposIds![index]);
                                  await storeGrupoDes(listaDeGruposDes![index]);
                                  await storeUnidadeId(listaDeGrupoUnidadeIds![index]);
                                  Navigator.pushNamed(context, Routes.maquina);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
              crossFadeState: isLoaded
                  ? (navigationProvider.selectedIndex == 0
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond)
                  : CrossFadeState.showFirst,
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: navigationProvider.selectedIndex,
        onItemSelected: navigationProvider.onItemTapped,
      ),
    );
  }



  Widget _itemBuilder(BuildContext context, int index) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final navigationProvider = NavigationProvider.of(context);
    double value1 = exemplo?[index].valorNg ?? 0;
    double value2 = exemplo?[index].valorN1 ?? 0;
    double value3 = exemplo?[index].valorN2 ?? 0;
    double value4 = exemplo?[index].valorN3 ?? 0;

    int valueMeta1 = exemplo?[index].faixaCorNg ?? 0;
    int valueMeta2 = exemplo?[index].faixaCorN1 ?? 0;
    int valueMeta3 = exemplo?[index].faixaCorN2 ?? 0;
    int valueMeta4 = exemplo?[index].faixaCorN3 ?? 0;

    String text = "Disponibilidade";
    String text1 = "Performance";
    String text2 = "Qualidade";

    if (valueMeta1 == 0) {
      if ((value1 >= 76.5) && (value1 < 84.5)) {
        valueMeta1 = 2;
      }

      if (value1 >= 84.5) {
        valueMeta1 = 3;
      }

      if (value1 < 76.5) {
        valueMeta1 = 1;
      }
    }

    if (valueMeta2 == 0) {
      if ((value2 >= 80.5) && (value2 < 89.5)) {
        valueMeta2 = 2;
      }

      if (value2 >= 89.5) {
        valueMeta2 = 3;
      }

      if (value2 < 80.5) {
        valueMeta2 = 1;
      }
    }

    if (valueMeta3 == 0) {
      if ((value3 >= 85.5) && (value3 < 94.5)) {
        valueMeta3 = 2;
      }

      if (value3 >= 94.5) {
        valueMeta3 = 3;
      }

      if (value3 < 85.5) {
        valueMeta3 = 1;
      }
    }

    if (valueMeta4 == 0) {
      if ((value4 >= 88.5) && (value4 < 98.5)) {
        valueMeta4 = 2;
      }

      if (value4 >= 98.5) {
        valueMeta4 = 3;
      }

      if (value4 < 88.5) {
        valueMeta4 = 1;
      }
    }

    if (value2 < 40) {
      text = "Disp";
    }
    if (value3 < 40) {
      text1 = "Perf";
    }
    if (value4 < 40) {
      text2 = "Quali";
    }

    return InkWell(
      child:

      Container(height: 237, margin: const EdgeInsets.symmetric(vertical: 15),   child:

      Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

       Row(mainAxisAlignment: MainAxisAlignment.start, children: [ Padding(padding: const EdgeInsets.only(left: 20), child:Text(capitalizeFirstLetterOfEachWord(exemplo![index].descricao), textAlign: TextAlign.left,  ) ,),],) ,
CardWidget(
        gauge: AnimatedRadialGauge1(context, value1, 50, 180, 10, valueMeta1),
        size: size,
        textTheme: textTheme,
        text: exemplo![index].descricao,
        unidade: exemplo![index],
        icon: Icon(Icons.factory, size: size.width * 0.1, color: Colors.lightBlue),
        lineN1: ChartLine(rate: (value2 / 100).clamp(0, 1), title: text, number: value2.round(), meta: valueMeta2, size: size),
        lineN2: ChartLine(rate: (value3 / 100).clamp(0, 1), title: text1, number: value3.round(), meta: valueMeta3, size: size),
        lineN3: ChartLine(rate: (value4 / 100).clamp(0, 1), title: text2, number: value4.round(), meta: valueMeta4, size: size),
        onTap: () async {
          await storeUnidadeId(exemplo![index].unidadeId);
          await storeUnidade(exemplo![index]);
          await storeUnidadeDes(exemplo![index].descricao);
          navigationProvider.selectedIndex = 1;

          Navigator.pushNamed(
            context,
            Routes.group,
            arguments: "/home",
          );
        },
      ),

      ],)

       ,)
    );
  }
}

String capitalizeFirstLetterOfEachWord(String input) {
  if (input.isEmpty) {
    return input;
  }

  return input.split(' ').map((word) {
    if (word.isEmpty) {
      return word;
    }
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}


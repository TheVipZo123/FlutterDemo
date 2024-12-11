


import 'package:efact_mobile/presentation/home/analiseGeral.dart';
import 'package:efact_mobile/presentation/home/analiseGrupo.dart';
import 'package:efact_mobile/presentation/home/analiseUnidade.dart';
import 'package:efact_mobile/presentation/home/maquina.page.dart';
import 'package:efact_mobile/presentation/home/navigation_provider.dart';

import 'package:efact_mobile/presentation/home/perfil1.page.dart';
import 'package:efact_mobile/presentation/home/status.page.dart';
import 'package:efact_mobile/utils/secureStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'presentation/account/account_phone_number.page.dart';


import 'presentation/home/group.page.dart';
import 'presentation/home/home.page.dart';

import 'presentation/home/perfil.page.dart';

import 'presentation/login/login.page.dart';
import 'presentation/splash/presentation/splash_screen.page.dart';
import 'themes/light.theme.dart';
import 'utils/routes.dart';

void main() async {

    WidgetsFlutterBinding.ensureInitialized();
     await clearSecureStorage();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NavigationProvider(child: MaterialApp(

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
       supportedLocales: const [
        Locale('pt', 'BR'),
      ],

       debugShowCheckedModeBanner: false,
      title: 'Efact',
      theme: lightTheme(context),
      initialRoute: Routes.splashScreen,
      routes: {
       // Routes.initialPage: (_) => const HomePage(),
        Routes.splashScreen: (_) => const SplashScreenPage(),
        Routes.login: (_) => const LoginPage(),
        Routes.accountPhoneNumber: (_) => const AccountPhoneNumberPage(),
        Routes.home: (_) => const HomePage(),

        Routes.group: (_) => const GroupPage(),
        Routes.PerfilPage: (_) => const PerfilPage(),
        Routes.Perfil1Page: (_) => const Perfil1Page(),
 
     

        Routes.maquina: (_) => const MaquinaPage(),

         Routes.statusmaquinaPage: (_) => const StatusPage(),
       
         

          Routes.analiseGeral: (_) => const AnaliseGeralPage(),
           Routes.analiseUnidade: (_) => const AnaliseUnidadePage(),
            Routes.analiseGrupo: (_) => const AnaliseGrupoPage(),

       



      },
    )
    
    ) ;
  }
}


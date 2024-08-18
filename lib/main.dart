import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/firebase_options.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/ManyChatConfirmation.dart';
import 'package:easebase/functions/agendaDataHorarios.dart';
import 'package:easebase/functions/createAccount.dart';
import 'package:easebase/functions/cupomProvider.dart';
import 'package:easebase/functions/horariosComuns.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/functions/providerFilterStrings.dart';
import 'package:easebase/functions/rankingProviderHome.dart';
import 'package:easebase/functions/stripe_subscriptions.dart';

import 'package:easebase/functions/userLogin.dart';
import 'package:easebase/managerHome/screen/home/homeScreen01.dart';
import 'package:easebase/managerHome/screen/manager/GraphicsAndSales/GraphicsScreenManager.dart';
import 'package:easebase/managerHome/screen/manager/GraphicsAndSales/screens/confirmationCreateCupom.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/components/atualizacaodePrecoManager.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/components/changeHourAndData.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/modalDeEdicao.dart';
import 'package:easebase/managerHome/screen/manager/principal/components/agendaDia/pricesandpercentages/priceEPorcentagemNewScreen.dart';
import 'package:easebase/managerHome/screen/profile/profileScreen.dart';
import 'package:easebase/normalUsersHome/screen/profile/profileScreen.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:easebase/normalUsersHome/screen/add/confirmscreen/ConfirmScreenCorte.dart';
import 'package:easebase/normalUsersHome/screen/home/homeScreen01.dart';
import 'package:easebase/normalUsersHome/screen/inicio/initialScreen.dart';
import 'package:easebase/normalUsersHome/screen/login/loginScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'normalUsersHome/screen/login/registerAccount.dart';
import 'rotas/verificationLogin.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Chame primeiro aqui ele inicia os widgets
  //so apos dar o start, ele inicia o firebase, aqui o app ja esta carregado e funcionando
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    Stripe.publishableKey =
        "pk_live_51PhN0AJbuFc8lkJcbRa8cs7RwiwCSYLDN9t0fYZBDzPljS3IZdjsjLnXdfySp6ag69vuah4kvBkEvrwaVpqvgi1700YJEUalH6";
    Stripe.merchantIdentifier = 'merchant.easecorte';
    Stripe.urlScheme = 'flutterstripe';
    await Stripe.instance.applySettings();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MyProfileScreenFunctions(),
        ),
        ChangeNotifierProvider(
          create: (_) => CreateAccount(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserLoginApp(),
        ),
        ChangeNotifierProvider(
          create: (_) => CorteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RankingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ManagerScreenFunctions(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProviderFilterManager(),
        ),
        ChangeNotifierProvider(
          create: (_) => ManyChatConfirmation(),
        ),
        ChangeNotifierProvider(
          create: (_) => HorariosComuns(),
        ),
        ChangeNotifierProvider(
          create: (_) => CupomProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StripeSubscriptions(),
        ),
      ],

      //TESTE DO REPOSITORIO
      child: MaterialApp(
        supportedLocales: const [
          Locale('pt', 'BR'), // Português do Brasil
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            cancelButtonStyle: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            confirmButtonStyle: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: Estabelecimento.nomeLocal,
        routes: {
          AppRoutesApp.VerificationLoginScreen01: (ctx) =>
              const VerificationLoginScreen01(),
          AppRoutesApp.InitialScreenApp: (ctx) => const InitialScreenApp(),
          AppRoutesApp.LoginScreen01: (ctx) => const LoginScreen01(),
          AppRoutesApp.HomeScreen01: (ctx) => const HomeScreen01(
                selectedIndex: 0,
                cupomIsAcitve: false,
              ),
          AppRoutesApp.RegisterAccountScreen: (ctx) =>
              const RegisterAccountScreen(),
          AppRoutesApp.ConfirmScreenCorte: (ctx) => const ConfirmScreenCorte(),
          AppRoutesApp.HomeScreen01WithBoolManager: (ctx) =>
              const HomeScreen01WithBoolManager(
                selectedIndex: 0,
              ),
          AppRoutesApp.ProfileScreen: (ctx) => const ProfileScreen(),
          AppRoutesApp.ProfileScreenManagerWithScafol: (ctx) =>
              const ProfileScreenManagerWithScafol(),
          AppRoutesApp.PricesAndPercentages: (ctx) =>
              const PriceEporcentagemNewPrice(), // mudei testando layout novo
          AppRoutesApp.GraphicsManagerScreen: (ctx) =>
              const GraphicsManagerScreen(
                mesSelecionado: "Clique",
              ),
          AppRoutesApp.ModalDeEdicao: (ctx) => const ModalDeEdicao(),
          AppRoutesApp.ChangeHourAndData: (ctx) => ChangeHourAndData(
                corteWidget: CorteClass(
                  feitoporassinatura: false,
                  pagoComCreditos: false,
                  pagoComCupom: false,
                  easepoints: 0,
                  apenasBarba: false,
                  detalheDoProcedimento: "",
                  isActive: false,
                  DiaDoCorte: 0,
                  clientName: "",
                  totalValue: 0,
                  NomeMes: "NomeMes",
                  id: "id",
                  numeroContato: "numeroContato",
                  profissionalSelect: "profissionalSelect",
                  diaCorte: DateTime.now(),
                  horarioCorte: "horarioCorte",
                  barba: false,
                  ramdomCode: 0,
                  dateCreateAgendamento: DateTime.now(),
                  horariosExtra: [],
                ),
              ),
        },
      ),
    );
  }
}

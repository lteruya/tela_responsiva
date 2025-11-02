import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // 1. IMPORTE ISSO
import 'package:window_manager/window_manager.dart'; // Seu import
// ... outros imports

Future<void> main() async {
  // 1. Garante que os bindings do Flutter estão prontos (isso é seguro)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. VERIFICA A PLATAFORMA
  // Só execute o código de 'window_manager' se NÃO for web
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = const WindowOptions(
        size: Size(1200, 800),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal,
        title: "Meu Título de Janela Personalizado",
      );

      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }

  // 3. O runApp() fica FORA do 'if' e roda em todas as plataformas
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Responsivo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // Fundo escuro, texto claro
      ),
      home: const ResponsiveHomeScreen(),
    );
  }
}

class ResponsiveHomeScreen extends StatelessWidget {
  const ResponsiveHomeScreen({super.key});

  // --- Breakpoints ---
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layouts Diferentes')),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // 1. Lógica de decisão baseada na largura
          if (constraints.maxWidth < mobileBreakpoint) {
            // Se for menor que 600 (Celular), retorna o layout móvel
            return _buildMobileLayout(context);
          } else if (constraints.maxWidth < tabletBreakpoint) {
            // Se for entre 600 e 1200 (Tablet), retorna o layout de tablet
            return _buildTabletLayout(context);
          } else {
            // Se for maior que 1200 (Desktop), retorna o layout de desktop
            return _buildDesktopLayout(context);
          }
        },
      ),
    );
  }

  // --- WIDGETS DE LAYOUT SEPARADOS ---

  /// Layout para Celular (Verde)
  /// Uma simples ListView.
  Widget _buildMobileLayout(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Layout Celular (Verde)',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: Text('Item $index'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Layout para Tablet (Amarelo)
  /// Duas colunas: um menu à esquerda e conteúdo à direita.
  Widget _buildTabletLayout(BuildContext context) {
    // Tema de texto específico para o fundo amarelo (texto preto)
    final textTheme = Theme.of(
      context,
    ).textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black);

    return Container(
      color: Colors.yellow,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Layout Tablet (Amarelo)',
              style: textTheme.headlineMedium,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // Coluna 1: Menu (30% da largura)
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(
                          Icons.tablet_mac,
                          color: Colors.black54,
                        ),
                        title: Text('Menu $index', style: textTheme.bodyLarge),
                      );
                    },
                  ),
                ),
                // Coluna 2: Conteúdo (70% da largura)
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.black.withOpacity(0.1),
                    child: Center(
                      child: Text(
                        'Área de Conteúdo',
                        style: textTheme.headlineSmall,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Layout para Desktop (Azul)
  /// Um menu lateral (NavigationRail) e uma área de conteúdo.
  Widget _buildDesktopLayout(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Row(
        children: [
          // Coluna 1: Menu Lateral Fixo
          NavigationRail(
            selectedIndex: 0, // Apenas para visualização
            backgroundColor: Colors.blue.shade900,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.explore),
                label: Text('Explorar'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Config.'),
              ),
            ],
          ),

          // Separador visual
          const VerticalDivider(thickness: 1, width: 1),

          // Coluna 2: Conteúdo Principal (expande)
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Layout Desktop (Azul)',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Conteúdo Principal do Desktop',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

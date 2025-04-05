import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
  Widget build(BuildContext context){

 return ChangeNotifierProvider(
  create: (context) => MyAppState(),
  child: MaterialApp(
    title: 'Namer App',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(3, 12, 146, 199))
    ),
    home: MyHomePage(),
  ),
 );
} 
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext(){
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

void toggleFavorite() {
  if(favorites.contains(current)) {
    favorites.remove(current);
  }else{
    favorites.add(current);
  }
  notifyListeners();
}

}


// Widget for hompage | this class will represent layout for entire screen 
class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  Widget page;
  switch (selectedIndex) {
    case 0 :
    page = GeneratorPage();
    break;
    case 1 :
    page = FavoritePage();
    break;
    default :
    throw UnimplementedError('no widget for $selectedIndex');
  }

   return LayoutBuilder( // Layout builder automaticly update all the element tree and adjust all the element with it 
     builder: (context, constraints) {
       return Scaffold(
       
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home), 
                    label: Text('Home')
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorite')
                      ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  
                  setState( () {
                    selectedIndex = value;
                  });
       
                },
              ),
            ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
              ),
            ),
          ],
        ),
       );
     }
   );
  }
}

class GeneratorPage extends StatelessWidget {


@override
Widget build(BuildContext context) {
  
  var appState = context.watch<MyAppState>();
  var pair = appState.current;

  IconData icon;
  if(appState.favorites.contains(pair)) {
    icon = Icons.favorite;
  } else {
    icon = Icons.favorite_border;
  } 

return Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height: 10),
      BigCard(pair: pair),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              appState.toggleFavorite();
            },
              icon: Icon(icon),
             label: Text('Like')
             ),
             SizedBox(width: 10),
             ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Next'))
        ],)
    ],
  ),);

}

}

// Task

class FavoritePage extends StatelessWidget {


@override
Widget build(BuildContext context) {
var state = context.watch<MyAppState>();

  if(state.favorites.isEmpty) {
    return Center(
      child: Text('No favorites yet!'),
    );
  }

  return ListView(
    children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: Text('You have '
        '${state.favorites.length} favorites: '),
        ),

        for(var pair in state.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase)
          ),
    ],
  );

 }
}

  class BigCard extends StatelessWidget {
    const BigCard({
      super.key,
      required this.pair,
    });

    final WordPair pair;

    @override
    Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.surface,
    );

      return Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
                      pair.asLowerCase, 
                      style: style,
                      semanticsLabel: "${pair.first} ${pair.second}",
                      ),
        ),
      );
    }
  }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//FLUTTER = FRONT-END ORIENTADO A WIDGETS, TUDO É UM WIDGET ALTERADO

void main() {
  //Iniciar o app (runApp)
  runApp(MyWidget());
}

//Widget que ficará com tudo
class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,);
  }
}

//Widget pagina principal
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;

  void decrement() {
    //Atualizar a tela - setState
      setState(() {
        count--;
      });
    print(count);
  }

  void increment() {
    setState(() {
      count++;
    });
    print(count);
  }

  bool get isEmpty => count == 0 ;
  bool get isFull => count >= 20 ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text('Contador'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fundo.jpg'),
            fit: BoxFit.cover
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
             Text(
              isFull ? 'Lotado' : 'Pode entrar',
              style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            //Maneira de colocar espaçamento - const SizedBox(height: 32)
             Padding(
              //.all para alterar todos, porém é possivel utilizar espaçamentos especificos
              padding: const EdgeInsets.all(32),
              child: Text(
                count.toString(),
                style: const TextStyle(
                    fontSize: 100,
                    color: Colors.white),
              ),
            ),
            Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children:    [
                TextButton(
                  onPressed: isEmpty ? null : decrement,
                  style: TextButton.styleFrom(
                      backgroundColor: isEmpty? Colors.white.withOpacity(0.2) : Colors.white,
                      fixedSize: const Size(80,80),
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        //side: BorderSide(color: Colors.green, width: 5),
                        borderRadius: BorderRadius.circular(16),
                      )
                    //Usar padding - padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                  ),
                  child: const Text("Saiu", style: TextStyle(
                      color: Colors.black,
                      fontSize: 16
                  ),
                  ),
                ),
                const SizedBox(width: 28),
                TextButton(
                    onPressed: isFull? null : increment,
                    style: TextButton.styleFrom(
                        backgroundColor: isFull? Colors.white.withOpacity(0.2) : Colors.white,
                        fixedSize: const Size(80,80),
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          //side: BorderSide(color: Colors.green, width: 5),
                          borderRadius: BorderRadius.circular(16),
                        )
                      //Usar padding - padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                    ),
                    child: const Text("Entrou", style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                    ),))
              ],
            )
          ],
        ),
      ),
      //Criar Drawer - drawer: Drawer(),
    );

    /*
    return Container(
      //Passar somente os parametros que serão utilizados
      color: Colors.black,
      alignment: Alignment.center,
      child: Text('Olá mundo !!'),);
     */
  }
}

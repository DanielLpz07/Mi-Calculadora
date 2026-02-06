import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF05061C),
          brightness: Brightness.dark,
        ),
      ),
      home: const Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String display = '';
  final List<String> operadores = ['+', '-', '*', '/'];

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        display = '';
      } else if (value == '=') {
        calcularResultado();
      } else if (operadores.contains(value)) {
        if (display.isNotEmpty && !operadores.contains(display.characters.last)) {
          display += value;
        }
      } else {
        display += value;
      }
    });
  }

  void calcularResultado() {
    if (display.isEmpty) return;
    try {
      if (display.contains('/0')) {
        setState(() => display = 'Error: Div/0');
        return;
      }
      Parser p = Parser();
      Expression exp = p.parse(display);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        display = (eval % 1 == 0) ? eval.toInt().toString() : eval.toString();
      });
    } catch (e) {
      setState(() => display = 'Error');
    }
  }

  Widget boton(String text) {
    bool isSpecial = operadores.contains(text) || text == "=" || text == "C" || text == "(" || text == ")";
    
    return ElevatedButton(
      onPressed: () => onButtonPressed(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSpecial ? const Color(0xFF1E2147) : const Color(0xFF0A0C24),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.zero,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildDisplay({bool isHorizontal = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.bottomRight,
      height: isHorizontal ? null : 150,
      child: Text(
        display.isEmpty ? '0' : display,
        style: TextStyle(fontSize: isHorizontal ? 40 : 50, fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget gridBotonesV() {
    return Expanded(
      flex: 6,
      child: GridView.count(
        padding: const EdgeInsets.all(10),
        crossAxisCount: 4,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        children: [
          boton("7"), boton("8"), boton("9"), boton("+"),
          boton("4"), boton("5"), boton("6"), boton("-"),
          boton("1"), boton("2"), boton("3"), boton("*"),
          boton("0"), boton("C"), boton("="), boton("/"),
          boton("("), boton(")"), // Estos quedan abajo sin mover los de arriba
        ],
      ),
    );
  }

  Widget gridBotonesH() {
    return Expanded(
      flex: 6,
      child: GridView.count(
        padding: const EdgeInsets.all(5),
        crossAxisCount: 8,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.2,
        children: [
          boton("1"), boton("2"), boton("3"), boton("4"),
          boton("5"), boton("6"), boton("7"), boton("8"),
          boton("9"), boton("0"), boton("+"), boton("-"),
          boton("*"), boton("/"), boton("C"), boton("="),
          boton("("), boton(")"), // Estos quedan en una fila nueva
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05061C),
      appBar: AppBar(
        title: const Text("Calculadora"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.landscape
              ? Column(children: [buildDisplay(isHorizontal: true), gridBotonesH()])
              : Column(children: [buildDisplay(), gridBotonesV()]);
        },
      ),
    );
  }
}
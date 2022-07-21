import 'dart:isolate';

void main() async {
  final receivePort = ReceivePort();

  await Isolate.spawn(workerIsolate, receivePort.sendPort);
}

void workerIsolate(SendPort sendPort) async {
  final resposta = await Future.delayed(Duration(seconds: 4), () => 'Conteudo');
  Isolate.exit(sendPort, resposta);
}

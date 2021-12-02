import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
/*

// MEUS INCLUDES LASER METER
#include "BluetoothSerial.h"
#include <ADS1115_WE.h>
#include <Wire.h>
#include <Preferences.h>
Preferences pref;
//Preferences preferences; // deve ser inicializado no setup
// DEFINIÇÕES de bluetooth // preferences e a biblioteca utilizada para salvar de forma nao volatil
// Referencia >> https://microcontrollerslab.com/save-data-esp32-flash-permanently-preferences-library/#Preferences.h-Example-1:-Save/Read-key:-value-pairs

#define I2C_ADDRESS 0x48
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

// Definindo Variaveis                  ************* APÓS RESET AS VARIAVEIS ASSUMIRÃO ESTES VALORES ************************
double sensibilidade = 1;
double intervalomax = 3;
double intervalomin = 1;
double leiturapulso = 0;
double leituratemp = 0;
double modoperation = 0;
bool savefile = false;
bool lemreset = false;

int i = 0;
char valorRecebido;
String btmsg;
double Voltage = 0;
BluetoothSerial SerialBT;
char sendBuf[256];

//const int analogIn = 34;
//int RawValue= 0;
//double tempC = 0;
//double tempF = 0;
// EXEMPLOS
/* There are several ways to create your ADS1115_WE object:
 * ADS1115_WE adc = ADS1115_WE()             -> uses Wire / I2C Address = 0x48
 * ADS1115_WE adc = ADS1115_WE(I2C_ADDRESS)  -> uses Wire / I2C_ADDRESS
 * ADS1115_WE adc = ADS1115_WE(&wire2)       -> uses the TwoWire object wire2 / I2C_ADDRESS
 * ADS1115_WE adc = ADS1115_WE(&wire2, I2C_ADDRESS) -> all together
 * Successfully tested with two I2C busses on an ESP32
 */

ADS1115_WE adc = ADS1115_WE(I2C_ADDRESS);
// *********************************************** DEFININDO LEITURA COMUNICAÇÃO I2C

// ******************************************************************************************SETANDO INICIO DO ESP*************************************************

/* EXEMPLO DE UMA ESTRUTURA
struct car { char *make; char *model; int year; }; // declares the struct type
    // declares and initializes an object of a previously-declared struct type
    struct car c = {.year=1923, .make="Nash", .model="48 Sports Touring Car"};
    printf("car: %d %s %s\n", c.year, c.make, c.model);
*/
struct LaserMeter
{
  double sensibilidade;
  double intervalomax;
  double intervalomin;
  double leiturapulso;
  double leituratemp;
  double modoperation;
  bool savefile;
  bool lemreset;
};

double readChannel(ADS1115_MUX channel)
{
  double voltage = 0.0;

  adc.setCompareChannels(channel);
  adc.startSingleMeasurement();
  // while(adc.isBusy()){
  //Serial.println("ADC Ocupado!!!");
  //
  //   }
  voltage = adc.getResult_mV(); // alternative: getResult_mV for Millivolt
  return voltage / 10;
}
void setup()
{
  // referencia para estrutura https://www.tutorialspoint.com/structs-in-arduino-program

  pref.begin("meusdados", false); // rodar o setup inicial com falso
  // SET UP COMUNICAÇÃO BLUETOOTH SERIAL
  Serial.begin(115200);
  SerialBT.begin("LEM 0.1 Vs Alpha");
  Serial.println("O dispositivo já pode ser pareado!");
  pinMode(14, OUTPUT);
  //pinMode(34, INPUT);

  /********************************************************************************** DEFININDO TABELA CSV ***********************************************************/

  //***************************************************************** SET UP DO ADS1115 A MAGICA ACONTECE AQUI******************************************************

  Wire.begin();
  if (!adc.init())
  {
    Serial.println("ADS1115 not connected!");
  }

  /* Set the voltage range of the ADC to adjust the gain
   * Please note that you must not apply more than VDD + 0.3V to the input pins!
   * 
   * ADS1115_RANGE_6144  ->  +/- 6144 mV
   * ADS1115_RANGE_4096  ->  +/- 4096 mV
   * ADS1115_RANGE_2048  ->  +/- 2048 mV (default)
   * ADS1115_RANGE_1024  ->  +/- 1024 mV
   * ADS1115_RANGE_0512  ->  +/- 512 mV
   * ADS1115_RANGE_0256  ->  +/- 256 mV
   */
  adc.setVoltageRange_mV(ADS1115_RANGE_6144); //comment line/change parameter to change range

  /* Set the inputs to be compared
   *  
   *  ADS1115_COMP_0_1    ->  compares 0 with 1       (default)
   *  ADS1115_COMP_0_3    ->  compares 0 with 3
   *  ADS1115_COMP_1_3    ->  compares 1 with 3
   *  ADS1115_COMP_2_3    ->  compares 2 with 3
   *  ADS1115_COMP_0_GND  ->  compares 0 with GND
   *  ADS1115_COMP_1_GND  ->  compares 1 with GND
   *  ADS1115_COMP_2_GND  ->  compares 2 with GND
   *  ADS1115_COMP_3_GND  ->  compares 3 with GND
   */
  adc.setCompareChannels(ADS1115_COMP_2_GND); //uncomment if you want to change the default

  /* Set number of conversions after which the alert pin will assert
   * - or you can disable the alert 
   *  
   *  ADS1115_ASSERT_AFTER_1  -> after 1 conversion
   *  ADS1115_ASSERT_AFTER_2  -> after 2 conversions
   *  ADS1115_ASSERT_AFTER_4  -> after 4 conversions
   *  ADS1115_DISABLE_ALERT   -> disable comparator / alert pin (default) 
   */
  //adc.setAlertPinMode(ADS1115_ASSERT_AFTER_1); //uncomment if you want to change the default

  /* Set the conversion rate in SPS (samples per second)
   * Options should be self-explaining: 
   * 
   *  ADS1115_8_SPS 
   *  ADS1115_16_SPS  
   *  ADS1115_32_SPS 
   *  ADS1115_64_SPS  
   *  ADS1115_128_SPS (default)
   *  ADS1115_250_SPS 
   *  ADS1115_475_SPS 
   *  ADS1115_860_SPS 
   */
  adc.setConvRate(ADS1115_860_SPS); //uncomment if you want to change the default

  /* Set continuous or single shot mode:
   * 
   *  ADS1115_CONTINUOUS  ->  continuous mode
   *  ADS1115_SINGLE     ->  single shot mode (default)
   */
  //adc.setMeasureMode(ADS1115_SINGLE); //uncomment if you want to change the default

  /* Choose maximum limit or maximum and minimum alert limit (window) in volts - alert pin will 
   *  assert when measured values are beyond the maximum limit or outside the window 
   *  Upper limit first: setAlertLimit_V(MODE, maximum, minimum)
   *  In max limit mode the minimum value is the limit where the alert pin assertion will be 
   *  be cleared (if not latched)  
   * 
   *  ADS1115_MAX_LIMIT
   *  ADS1115_WINDOW
   * 
   */
  //adc.setAlertModeAndLimit_V(ADS1115_MAX_LIMIT, 3.0, 1.5); //uncomment if you want to change the default

  /* Enable or disable latch. If latch is enabled the alert pin will assert until the
   * conversion register is read (getResult functions). If disabled the alert pin assertion
   * will be cleared with next value within limits. 
   *  
   *  ADS1115_LATCH_DISABLED (default)
   *  ADS1115_LATCH_ENABLED
   */
  //adc.setAlertLatch(ADS1115_LATCH_ENABLED); //uncomment if you want to change the default

  /* Sets the alert pin polarity if active:
   *  
   * ADS1115_ACT_LOW  ->  active low (default)   
   * ADS1115_ACT_HIGH ->  active high
   */
  //adc.setAlertPol(ADS1115_ACT_LOW); //uncomment if you want to change the default

  /* With this function the alert pin will assert, when a conversion is ready.
   * In order to deactivate, use the setAlertLimit_V function  
   */
  //adc.setAlertPinToConversionReady(); //uncomment if you want to change the default

  Serial.println("ADS1115 Example Sketch - Single Shot Mode");
  Serial.println("Channel / Voltage [V]: ");
  Serial.println();
}
/****************************************************************** FIM DO SETUP DO ADC **************************************************************************/

LaserMeter DeFabrica{
    sensibilidade = 1.0,
    intervalomax = 3.0,
    intervalomin = 0.0,
    leiturapulso = 0.0,
    leituratemp = 0.0,
    modoperation = 0.0,
    savefile = false,
    lemreset = false,
};

LaserMeter dataframe{
    sensibilidade = 666.66,
    intervalomax = 3.0,
    intervalomin = 1.0,
    leiturapulso = 0.0,
    leituratemp = 0.0,
    modoperation = 1.0,
    savefile = false,
    lemreset = false,
};

String Bluemsg()
{
  btmsg = "";
  while (SerialBT.available())
  {
    delay(3);
    char c = SerialBT.read();
    btmsg += c;
  }
  return btmsg;
}
void loop()
{

  /* Remontando String recebido via Bluetooth*/

  String bluemsg;
  bluemsg = Bluemsg();
  Serial.println(bluemsg);
  /* AJUSTE DE SENSIBILIDADE*/
  /*
    * ADS1115_RANGE_6144  ->  +/- 6144 mV
   * ADS1115_RANGE_4096  ->  +/-  4096 mV
   * ADS1115_RANGE_2048  ->  +/-  2048 mV 
   * ADS1115_RANGE_1024  ->  +/-  1024 mV
   * ADS1115_RANGE_0512  ->  +/-  512 mV
   * ADS1115_RANGE_0256  ->  +/-  256 mV
   */
  //adc.setVoltageRange_mV(ADS1115_RANGE_6144);
  
  if (bluemsg == "sensibilidade256 mv")
  {
    Serial.println("Ajuste de sensibilidade");
    Serial.println("Digite o valor da sensibilidade");
    
    adc.setVoltageRange_mV(ADS1115_RANGE_0256);
    Serial.println(sensibilidade);
  }
  if (bluemsg == "sensibilidade512 mv")
  {
    Serial.println("Ajuste de sensibilidade");
    Serial.println("Digite o valor da sensibilidade");
    
    adc.setVoltageRange_mV(ADS1115_RANGE_0512);
    Serial.println(sensibilidade);
  }
  if (bluemsg == "sensibilidade1024 mv")
  {
    Serial.println("Ajuste de sensibilidade");
    Serial.println("Digite o valor da sensibilidade");
    
    adc.setVoltageRange_mV(ADS1115_RANGE_1024);
    Serial.println(sensibilidade);
  }
  if (bluemsg == "sensibilidade2048 mv")
  {
    Serial.println("Ajuste de sensibilidade");
    Serial.println("Digite o valor da sensibilidade");
    
    adc.setVoltageRange_mV(ADS1115_RANGE_2048);
    Serial.println(sensibilidade);
  }
  if (bluemsg == "sensibilidade4096 mv")
  {
    Serial.println("Ajuste de sensibilidade");
    Serial.println("Digite o valor da sensibilidade");
    
    adc.setVoltageRange_mV(ADS1115_RANGE_4096);
    Serial.println(sensibilidade);
  }
  if (bluemsg == "sensibilidade6144 mv")
  {
    Serial.println("Ajuste de sensibilidade");
    Serial.println("Digite o valor da sensibilidade");
    
    adc.setVoltageRange_mV(ADS1115_RANGE_6144);
    Serial.println(sensibilidade);
  }
  /* INTERVALO DE LEITURA, DEVE MIN E MAX*/
  
  /* COEFICIENTE DE CALIBRAÇÃO */
  /* LEITURA DE PULSO */
  /* LEITURA DE TEMPERATURA */
  /* MODO DE OPERAÇÃO --- SINGLE PULSE OU CONTINUOS READING */
  /* SAVE --- SALVANDO DE FORMA NÃO VOLATIL */
  /* RESTORE VALUES-- TODAS AS VARIAVEIS SETADAS NO PREFERENCE SERÃO APAGADAS*/
  /* READ ALL VALUES-- LE TODOS OS VALORES E ENVIA PARA BT */

  double voltage = 0.0;
  Serial.print("Leitura do canal 2(A2) : ");
  voltage = readChannel(ADS1115_COMP_2_GND);
  dataframe.leiturapulso = readChannel();
  dataframe.leituratemp = voltage;
  Serial.println(voltage);
  Serial.println(dataframe.leituratemp);
  Serial.println(dataframe.leiturapulso);

  if (SerialBT.available())
  {

    Serial.println(valorRecebido);

    if (valorRecebido == '3')
    {
      SerialBT.println("LED 2 ligado:");
      digitalWrite(14, HIGH);
    }
    if (valorRecebido == '4')
    {
      SerialBT.println("LED 2 desligado");
      digitalWrite(14, LOW);
    }
  }

  /*Prepara para envio*/
  delay(1000);
  SerialBT.println(voltage);
  SerialBT.print("voltage");
  delay(200);
  SerialBT.print(dataframe.sensibilidade);
  SerialBT.println("sensibilidade");
  delay(200);
  SerialBT.print(dataframe.intervalomax);
  SerialBT.println("intermax");
  delay(200);
  SerialBT.print(dataframe.intervalomin);
  SerialBT.println("intermin");
  delay(200);
  SerialBT.print(dataframe.leiturapulso);
  SerialBT.println("pulso");
  delay(200);
  SerialBT.print(dataframe.leituratemp);
  SerialBT.println("temp");
  //  delay(50);
  // SerialBT.print(dataframe.modoperation);
  // SerialBT.println("modop");
  //  delay(50);
  // SerialBT.print(dataframe.savefile);
  // Serial.println(dataframe.savefile);
  // SerialBT.println("sfile");
  //  delay(50);
  // SerialBT.print(dataframe.lemreset);
  // SerialBT.println("lemrst");

  // SerialBT.println("fim");
  // char buffer[100];
  // sprintf(buffer, "Sensibilidade =  %f intervalo max,min %f degrees F", DeFabrica.sensibilidade, DeFabrica.intervalomax);
  // Serial.println(buffer);
  //  char buffer [50];
  //   i=snprintf (buffer, "sensibilidade = %d intervalo maximo =  %d  intervalo minimo =  %d",
  //   DeFabrica.sensibilidade,
  //   DeFabrica.intervalomax
  //   //DeFabrica.intervalomin
  //   );
  //  for(int l= 0; l<=i; l++)
  //  Serial.print(buffer[l]);
  //Serial.println(DeFabrica);
  // referencia https://github.com/rickkas7/serial_tutorial/blob/master/example1.md
  // snprintf(sendBuf, sizeof(sendBuf), "sensibilidade %d,%d,%d,%d,%d,%d,%d,%d\n",
  //     DeFabrica.sensibilidade,
  //     DeFabrica.intervalomax ,
  //     DeFabrica.intervalomin,
  //     DeFabrica.leiturapulso,
  //     DeFabrica.leituratemp,
  //     DeFabrica.modoperation,
  //     DeFabrica.savefile,
  //     DeFabrica.lemreset
  //     );
  // SerialBT.println(sendBuf);
  // Serial.println(sendBuf);

  //SerialBT.write(DeFabrica.sensibilidade);
  //Serial.write(DeFabrica);
  //Serial.println(tempC);
}
*/*/
import 'package:syncfusion_flutter_charts/charts.dart';

import 'Meublue/datamap.dart';
import 'Meublue/getcontrol.dart';
import 'Meublue/todo.dart';

@override
class Connected extends StatefulWidget {
  Connected({Key? key, required this.device}) : super(key: key);
  BluetoothDevice device;

  @override
  _ConnectedState createState() => _ConnectedState(device: device);
}

class _ConnectedState extends State<Connected> {
  late BluetoothConnection connection;

  late bool isConnecting;

  late bool isDisconnecting;

  List<double> leitura = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ];

  _ConnectedState({required this.device});
  BluetoothDevice device;
  _getBTConnection() {
    BluetoothConnection.toAddress(device.address).then((_connection) {
      connection = _connection;
      isConnecting = false;
      isDisconnecting = false;
      setState(() {});
      connection.input?.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          Get.defaultDialog(
            title: 'disconnected',
            content: const Text('disonnected!'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        } else {
          Get.defaultDialog(
            title: 'Disonnected',
            content: const Text('Remotly disconnected!'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        }
        if (mounted) {
          setState(() {});
        }
        Navigator.of(context).pop();
      });
    }).catchError((error) {
      Navigator.of(context).pop();
    });
  }

  String voltage = '0.0';
  String sensibilidade = '0.0';
  String intermax = '0.0';
  String intermin = '0.0';
  String pulso = '0.0';
  String temp = '0.0';
  String modop = '0.0';
  String sfile = '0.0';
  String lemrst = '0.0';
  String fim = '0.0';
  String message = '0.0';
  String msg = '0.00';
  String msgj = '0.0 mJ';
  @override
  initState() {
    super.initState();
    _getBTConnection();
  }

  void _onDataReceived(Uint8List data) {
    if (data.isNotEmpty) {
      String dataStr = ascii.decode(data);
      message += dataStr;

      setState(() {
        if (dataStr.contains('voltage')) {
          voltage = message.replaceAll('voltage', '');
          voltage = voltage.replaceAll('\n', '');
          print('voltage: $voltage');
          message = '';
        }
        if (dataStr.contains('sensibilidade')) {
          sensibilidade = message.replaceAll('sensibilidade', '');
          sensibilidade = sensibilidade.replaceAll('\n', '');
          print('sensibilidade: $sensibilidade');
          message = '';
        }
        if (dataStr.contains('intermax')) {
          intermax = message.replaceAll('intermax', '');
          intermax = intermax.replaceAll('\n', '');
          print('intermax: $intermax');
          message = '';
        }
        if (dataStr.contains('intermin')) {
          intermin = message.replaceAll('intermin', '');
          intermin = intermin.replaceAll('\n', '');
          print('intermin: $intermin');
          message = '';
        }
        if (dataStr.contains('pulso')) {
          pulso = message.replaceAll('pulso', '');
          pulso = pulso.replaceAll('\n', '');
          print('pulso: $pulso');
          message = '';
        }

        if (dataStr.contains('modop')) {
          modop = message.replaceAll('modop', '');
          modop = modop.replaceAll('\n', '');
          print('modop: $modop');
          message = '';
        }
        if (dataStr.contains('sfile')) {
          sfile = message.replaceAll('sfile', '');
          sfile = sfile.replaceAll('\n', '');
          print('sfile: $sfile');
          message = '';
        }
        if (dataStr.contains('lemrst')) {
          lemrst = message.replaceAll('lemrst', '');
          lemrst = lemrst.replaceAll('\n', '');
          print('lemrst: $lemrst');
          message = '';
        }
        if (dataStr.contains('fim')) {
          fim = message.replaceAll('fim', '');
          fim = fim.replaceAll('\n', '');
          print('fim: $fim');
          message = '';
        }

        // if (dataStr.contains('pulso')) {
        //   pulso = message.replaceAll('pulso', '');
        //   pulso = pulso.replaceAll('\n', '');
        //   print("pulso armazenado$pulso");
        //   message = '';
        // }

        if (dataStr.contains('temp')) {
          msg = message.replaceAll('temp', '');
          msgj = msg.replaceAll('\n', 'mJ');
          print(msgj);
          var doublemsg = double.parse(msg).toDouble();

          leitura.add(doublemsg);

          message = ''; //clear buffer to accept new string
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF410000),
        title: const Text('Conectado'),
      ),
      backgroundColor: const Color(0xFF24948E),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: const Color(0xD5FFFFFF),
                child: SfCartesianChart(
                    title: ChartTitle(
                        text: 'ADS READINGS',
                        borderWidth: 2,
                        alignment: ChartAlignment.center,
                        textStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        )),
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
                      LineSeries<Readings, String>(
                          dataSource: [
                            // Bind data source

                            Readings(leitura.length - 20,
                                leitura[leitura.length - 20]),
                            Readings(leitura.length - 19,
                                leitura[leitura.length - 19]),
                            Readings(leitura.length - 18,
                                leitura[leitura.length - 18]),
                            Readings(leitura.length - 17,
                                leitura[leitura.length - 17]),
                            Readings(leitura.length - 16,
                                leitura[leitura.length - 16]),
                            Readings(leitura.length - 15,
                                leitura[leitura.length - 15]),
                            Readings(leitura.length - 14,
                                leitura[leitura.length - 14]),
                            Readings(leitura.length - 13,
                                leitura[leitura.length - 13]),
                            Readings(leitura.length - 12,
                                leitura[leitura.length - 12]),
                            Readings(leitura.length - 11,
                                leitura[leitura.length - 11]),
                            Readings(leitura.length - 10,
                                leitura[leitura.length - 10]),
                            Readings(leitura.length - 9,
                                leitura[leitura.length - 9]),
                            Readings(leitura.length - 8,
                                leitura[leitura.length - 8]),
                            Readings(leitura.length - 7,
                                leitura[leitura.length - 7]),
                            Readings(leitura.length - 6,
                                leitura[leitura.length - 6]),
                            Readings(leitura.length - 5,
                                leitura[leitura.length - 5]),
                            Readings(leitura.length - 4,
                                leitura[leitura.length - 4]),
                            Readings(leitura.length - 3,
                                leitura[leitura.length - 3]),
                            Readings(leitura.length - 2,
                                leitura[leitura.length - 2]),
                            Readings(leitura.length - 1,
                                leitura[leitura.length - 1]),

                            Readings(leitura.length, leitura.last),
                          ],
                          xValueMapper: (Readings sales, _) =>
                              sales.x.toString(),
                          yValueMapper: (Readings sales, _) => sales.y)
                    ]),
              ),
              Text("Last Value:" + leitura.last.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                  )),
              ...todos.map(
                (todos) => Functions(
                  nameFunction: todos.function,
                  functionArg: todos.argfunction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Readings {
  Readings(this.x, this.y);
  final int x;
  final double? y;
}


# Ads1x15 Control.

Ads Control is an flutter app, wich comunicates with esp-32 via Bluetooth Serial.

## To do list
```
Implemento it with BLE -
Implement IOS code, actualy I could not test on Iphone
Implement WebApplication
Implement TODO new Functions, this is an idea to make a TODO so you can 
implement a new function with yours argumments
The ESP Code is not good yet, Im working on it, will be ready very soon
```

# Dependencies 

``` 
flutter_bluetooth_serial: 

Install - $ flutter pub add flutter_bluetooth_serial
import - import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

GetX.

Install - flutter pub add get
import - import 'package:get/get.dart';

another_carousel_pro: // well, this one is up to you... just to have a little fun 🐿️
Install - flutter pub add carousel_slider
Import - import 'package:carousel_slider/carousel_slider.dart';

Syncfusion_flutter_charts: ^19.3.54.
Install - flutter pub add syncfusion_flutter_charts
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

```



![image](https://user-images.githubusercontent.com/42210628/143667468-3599ca71-126b-489f-85bb-cd7d2e7d3c17.png)

## The functions implemented are in the datamap.dart, you can find more about this functions in ADS1115_WE.h
```
final List<Todo> todos = [
  Todo(function: "setVoltageRange_mV", argfunction: <String>[
    '256 mv',
    '512 mv',
    '1024 mv',
    '2048 mv',
    '4096 mv',
    '6144 mv'
  ]),
  Todo(function: "ADS1115_RANGE_6144", argfunction: <String>[
    'ADS1115_RANGE_0256',
    'ADS1115_RANGE_0512',
    'ADS1115_RANGE_1024',
    'ADS1115_RANGE_2048',
    'ADS1115_RANGE_4096',
    'ADS1115_RANGE_6144',
  ]),
  Todo(function: "setCompareChannels", argfunction: <String>[
    'ADS1115_COMP_0_1',
    'ADS1115_COMP_0_3',
    'ADS1115_COMP_1_3',
    'ADS1115_COMP_2_3',
    'ADS1115_COMP_0_GND',
    'ADS1115_COMP_1_GND',
    'ADS1115_COMP_2_GND',
    'ADS1115_COMP_3_GND',
  ]),
  Todo(function: "setAlertPinMode", argfunction: <String>[
    'ADS1115_ALERT_HIGH',
    'ADS1115_ALERT_LOW',
    'ADS1115_ALERT_DISABLE',
  ]),
  Todo(function: "setConvRate", argfunction: <String>[
    'ADS1115_CONV_RATE_8',
    'ADS1115_CONV_RATE_16',
    'ADS1115_CONV_RATE_32',
    'ADS1115_CONV_RATE_64',
    'ADS1115_CONV_RATE_128',
    'ADS1115_CONV_RATE_250',
    'ADS1115_CONV_RATE_475',
    'ADS1115_CONV_RATE_860',
  ]),
  Todo(function: "setMeasureMode", argfunction: <String>[
    'ADS1115_MODE_CONTINUOUS',
    'ADS1115_MODE_SINGLE',
  ]),
  Todo(function: "setAlertLimit_V", argfunction: <String>[
    'ADS1115_MAX_LIMIT',
    'ADS1115_WINDOW',
  ]),
  Todo(function: "setLatchMode", argfunction: <String>[
    'ADS1115_LATCH_DISABLED',
    'ADS1115_LATCH_ENABLED',
  ]),
  Todo(function: "setAlertPolarity", argfunction: <String>[
    'ADS1115_ACT_LOW',
    'ADS1115_ACT_HIGH',
  ]),
  Todo(function: "setAlertPinToConversionReady", argfunction: <String>[
    'yes',
    'no',
  ]),
];
```
![image](https://user-images.githubusercontent.com/42210628/177357011-f846fa93-9d0a-475f-a098-62aa06381085.png)


For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)

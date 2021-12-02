class Todo {
  String Function;
  List<String> argfunction;

  Todo({required this.Function, required this.argfunction});
}

final List<Todo> todos = [
  Todo(Function: "setVoltageRange_mV", argfunction: <String>[
    '256 mv',
    '512 mv',
    '1024 mv',
    '2048 mv',
    '4096 mv',
    '6144 mv'
  ]),
  Todo(Function: "ADS1115_RANGE_6144", argfunction: <String>[
    'ADS1115_RANGE_0256',
    'ADS1115_RANGE_0512',
    'ADS1115_RANGE_1024',
    'ADS1115_RANGE_2048',
    'ADS1115_RANGE_4096',
    'ADS1115_RANGE_6144',
  ]),
  Todo(Function: "setCompareChannels", argfunction: <String>[
    'ADS1115_COMP_0_1',
    'ADS1115_COMP_0_3',
    'ADS1115_COMP_1_3',
    'ADS1115_COMP_2_3',
    'ADS1115_COMP_0_GND',
    'ADS1115_COMP_1_GND',
    'ADS1115_COMP_2_GND',
    'ADS1115_COMP_3_GND',
  ]),
  Todo(Function: "setAlertPinMode", argfunction: <String>[
    'ADS1115_ALERT_HIGH',
    'ADS1115_ALERT_LOW',
    'ADS1115_ALERT_DISABLE',
  ]),
  Todo(Function: "setConvRate", argfunction: <String>[
    'ADS1115_CONV_RATE_8',
    'ADS1115_CONV_RATE_16',
    'ADS1115_CONV_RATE_32',
    'ADS1115_CONV_RATE_64',
    'ADS1115_CONV_RATE_128',
    'ADS1115_CONV_RATE_250',
    'ADS1115_CONV_RATE_475',
    'ADS1115_CONV_RATE_860',
  ]),
  Todo(Function: "setMeasureMode", argfunction: <String>[
    'ADS1115_MODE_CONTINUOUS',
    'ADS1115_MODE_SINGLE',
  ]),
  Todo(Function: "setAlertLimit_V", argfunction: <String>[
    'ADS1115_MAX_LIMIT',
    'ADS1115_WINDOW',
  ]),
  Todo(Function: "setLatchMode", argfunction: <String>[
    'ADS1115_LATCH_DISABLED',
    'ADS1115_LATCH_ENABLED',
  ]),
  Todo(Function: "setAlertPolarity", argfunction: <String>[
    'ADS1115_ACT_LOW',
    'ADS1115_ACT_HIGH',
  ]),
  Todo(Function: "setAlertPinToConversionReady", argfunction: <String>[
    'yes',
    'no',
  ]),
];

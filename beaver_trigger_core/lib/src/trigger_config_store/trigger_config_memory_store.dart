import 'dart:async';

import '../base.dart';

final Map<String, TriggerConfig> _config = {};

class TriggerConfigMemoryStore implements TriggerConfigStore {
  const TriggerConfigMemoryStore();

  @override
  Future<TriggerConfig> load(String id) async {
    if (!_config.containsKey(id)) {
      throw new Exception('TriggerConfig for \'${id}\' does not exist.');
    }

    return _config[id];
  }

  @override
  Future<bool> save(TriggerConfig triggerConfig) async {
    _config[triggerConfig.id] = triggerConfig;
    return true;
  }
}

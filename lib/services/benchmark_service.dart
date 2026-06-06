import 'dart:convert';

import 'package:another_iptv_player/models/benchmark_result_model.dart';
import 'package:another_iptv_player/services/performance_service.dart';

class BenchmarkService {
  final List<BenchmarkResultModel> _results = [];

  List<BenchmarkResultModel> get results => List.unmodifiable(_results);

  Future<T> measure<T>(
    String category,
    Future<T> Function() action, {
    String device = BenchmarkResultModel.pendingRealDeviceTesting,
    String notes = BenchmarkResultModel.pendingRealDeviceTesting,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      return await PerformanceService.track('benchmark_$category', action);
    } finally {
      stopwatch.stop();
      _results.add(
        BenchmarkResultModel(
          id: '${category}_${DateTime.now().microsecondsSinceEpoch}',
          category: category,
          capturedAt: DateTime.now(),
          duration: stopwatch.elapsed,
          device: device,
          notes: notes,
        ),
      );
    }
  }

  void addPendingHook(String category) {
    _results.add(
      BenchmarkResultModel(
        id: '${category}_${DateTime.now().microsecondsSinceEpoch}',
        category: category,
        capturedAt: DateTime.now(),
      ),
    );
  }

  String exportJson() {
    return const JsonEncoder.withIndent('  ')
        .convert(_results.map((result) => result.toJson()).toList());
  }

  void clear() {
    _results.clear();
  }
}

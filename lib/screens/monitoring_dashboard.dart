import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/performance_service.dart';

class MonitoringDashboard extends StatefulWidget {
  const MonitoringDashboard({Key? key}) : super(key: key);

  @override
  State<MonitoringDashboard> createState() => _MonitoringDashboardState();
}

class _MonitoringDashboardState extends State<MonitoringDashboard> {
  Map<String, dynamic> performanceSummary = {};
  List<Map<String, dynamic>> performanceIssues = [];
  Map<String, dynamic> memoryUsage = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMonitoringData();
  }

  Future<void> _loadMonitoringData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final summary = PerformanceService().getPerformanceSummary();
      final issues = PerformanceService().detectPerformanceIssues();
      final memory = await PerformanceService().getMemoryUsage();

      setState(() {
        performanceSummary = summary;
        performanceIssues = issues;
        memoryUsage = memory;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading monitoring data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Monitor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMonitoringData,
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'export':
                  await _exportPerformanceData();
                  break;
                case 'clear':
                  await _clearPerformanceData();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Export Data'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear),
                    SizedBox(width: 8),
                    Text('Clear Data'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMonitoringData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverviewCard(),
                    const SizedBox(height: 16),
                    _buildMemoryUsageCard(),
                    const SizedBox(height: 16),
                    _buildPerformanceMetricsCard(),
                    const SizedBox(height: 16),
                    _buildPerformanceIssuesCard(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOverviewCard() {
    final metricsMap = performanceSummary['metrics_summary'] as Map? ?? {};
    final totalOperations = performanceSummary['total_operations'] ?? 0;
    final monitoringActive = performanceSummary['monitoring_active'] ?? false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  monitoringActive ? Icons.monitor_heart : Icons.heart_broken,
                  color: monitoringActive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Performance Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    'Total Operations',
                    totalOperations.toString(),
                    Icons.analytics,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildMetricTile(
                    'Metric Types',
                    metricsMap.length.toString(),
                    Icons.category,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    'Issues Found',
                    performanceIssues.length.toString(),
                    Icons.warning,
                    performanceIssues.isEmpty ? Colors.green : Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildMetricTile(
                    'Monitoring',
                    monitoringActive ? 'Active' : 'Inactive',
                    monitoringActive ? Icons.check_circle : Icons.cancel,
                    monitoringActive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryUsageCard() {
    final usedMemory = memoryUsage['used_memory_mb'] ?? 0;
    final totalMemory = memoryUsage['total_memory_mb'] ?? 0;
    final memoryPressure = memoryUsage['memory_pressure'] ?? 'unknown';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.memory, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  'Memory Usage',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (totalMemory > 0) ...[
              LinearProgressIndicator(
                value: usedMemory / totalMemory,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getMemoryPressureColor(memoryPressure),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$usedMemory MB / $totalMemory MB',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ] else ...[
              const Text('Memory information not available'),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  _getMemoryPressureIcon(memoryPressure),
                  color: _getMemoryPressureColor(memoryPressure),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Pressure: ${memoryPressure.toUpperCase()}',
                  style: TextStyle(
                    color: _getMemoryPressureColor(memoryPressure),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetricsCard() {
    final metricsMap = performanceSummary['metrics_summary'] as Map? ?? {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.speed, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Performance Metrics',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (metricsMap.isEmpty) ...[
              const Text('No performance metrics available yet'),
            ] else ...[
              ...metricsMap.entries.map((entry) {
                final metricName = entry.key;
                final metricData = entry.value as Map<String, dynamic>;
                return _buildMetricRow(metricName, metricData);
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceIssuesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  performanceIssues.isEmpty
                      ? Icons.check_circle
                      : Icons.warning,
                  color: performanceIssues.isEmpty
                      ? Colors.green
                      : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Performance Issues',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (performanceIssues.isEmpty) ...[
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text('No performance issues detected!'),
                ],
              ),
            ] else ...[
              ...performanceIssues
                  .map((issue) => _buildIssueCard(issue))
                  .toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String metricName, Map<String, dynamic> metricData) {
    final average = (metricData['average'] as num).toStringAsFixed(1);
    final count = metricData['count'];
    final min = metricData['min'];
    final max = metricData['max'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metricName.replaceAll('_', ' ').toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Avg: ${average}ms'), Text('Count: $count')],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Min: ${min}ms'), Text('Max: ${max}ms')],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIssueCard(Map<String, dynamic> issue) {
    final operation = issue['operation'] as String;
    final averageDuration = (issue['average_duration'] as num).toStringAsFixed(
      1,
    );
    final threshold = issue['threshold'];
    final severity = issue['severity'] as String;
    final suggestion = issue['suggestion'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getSeverityColor(severity).withOpacity(0.1),
        border: Border.all(color: _getSeverityColor(severity)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getSeverityIcon(severity),
                color: _getSeverityColor(severity),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  operation.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getSeverityColor(severity),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getSeverityColor(severity),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  severity.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Average: ${averageDuration}ms (Threshold: ${threshold}ms)'),
          const SizedBox(height: 8),
          Text(
            suggestion,
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getMemoryPressureColor(String pressure) {
    switch (pressure.toLowerCase()) {
      case 'low':
      case 'normal':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'high':
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getMemoryPressureIcon(String pressure) {
    switch (pressure.toLowerCase()) {
      case 'low':
      case 'normal':
        return Icons.check_circle;
      case 'moderate':
        return Icons.warning;
      case 'high':
      case 'critical':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return Colors.yellow[700]!;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return Icons.info;
      case 'medium':
        return Icons.warning;
      case 'high':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  Future<void> _exportPerformanceData() async {
    try {
      final data = {
        'performance_summary': performanceSummary,
        'performance_issues': performanceIssues,
        'memory_usage': memoryUsage,
        'export_timestamp': DateTime.now().toIso8601String(),
      };

      // In a real app, this would export to a file or share
      await Clipboard.setData(ClipboardData(text: data.toString()));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Performance data copied to clipboard')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  Future<void> _clearPerformanceData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Performance Data'),
        content: const Text(
          'Are you sure you want to clear all performance data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      PerformanceService().clearPerformanceData();
      await _loadMonitoringData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Performance data cleared')),
        );
      }
    }
  }
}

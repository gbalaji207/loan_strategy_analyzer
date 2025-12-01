import 'dart:convert';
import 'dart:html' as html;
import 'dart:async';
import '../../presentation/cubit/loan_input_state.dart';
import '../../domain/models/payment_plan_config.dart';

/// Service for exporting and importing configuration
/// Handles both LoanInputState and PaymentPlanConfig separately
class StorageService {
  static const String _exportFileName = 'loan_configuration.json';

  // ============================================================================
  // COMBINED EXPORT (Both states in one file)
  // ============================================================================

  /// Export both loan input state and payment plan config to JSON file
  Future<void> exportConfiguration({
    required LoanInputState loanInputState,
    required PaymentPlanConfig paymentPlanConfig,
  }) async {
    try {
      // Convert both states to JSON
      final exportData = {
        'version': '1.0.0',
        'exportedAt': DateTime.now().toIso8601String(),
        'appName': 'Loan Strategy Analyzer',
        'data': {
          'loanInput': loanInputState.toJson(),
          'paymentPlan': paymentPlanConfig.toJson(),
        },
      };

      // Create pretty-printed JSON string
      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

      // Create blob and download
      final bytes = utf8.encode(jsonString);
      final blob = html.Blob([bytes], 'application/json');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create and trigger download
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', _exportFileName)
        ..click();

      // Clean up
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      throw StorageException('Failed to export configuration: $e');
    }
  }

  // ============================================================================
  // COMBINED IMPORT (Both states from one file)
  // ============================================================================

  /// Import both loan input state and payment plan config from JSON file
  Future<ImportedConfiguration?> importConfiguration() async {
    try {
      // Create file input element
      final input = html.FileUploadInputElement()..accept = '.json';

      // Wait for file selection
      final completer = Completer<ImportedConfiguration?>();

      input.onChange.listen((event) async {
        final files = input.files;
        if (files == null || files.isEmpty) {
          completer.complete(null);
          return;
        }

        final file = files[0];
        final reader = html.FileReader();

        reader.onLoadEnd.listen((event) {
          try {
            final result = reader.result as String;
            final jsonMap = jsonDecode(result) as Map<String, dynamic>;

            // Extract data section
            final data = jsonMap['data'] as Map<String, dynamic>?;
            if (data == null) {
              throw StorageException('Invalid file format: missing data section');
            }

            // Parse loan input state
            final loanInputJson = data['loanInput'] as Map<String, dynamic>?;
            if (loanInputJson == null) {
              throw StorageException('Invalid file format: missing loanInput');
            }
            final loanInputState = LoanInputState.fromJson(loanInputJson);

            // Parse payment plan config
            final paymentPlanJson = data['paymentPlan'] as Map<String, dynamic>?;
            if (paymentPlanJson == null) {
              throw StorageException('Invalid file format: missing paymentPlan');
            }
            final paymentPlanConfig = PaymentPlanConfig.fromJson(paymentPlanJson);

            // Return both
            completer.complete(
              ImportedConfiguration(
                loanInputState: loanInputState,
                paymentPlanConfig: paymentPlanConfig,
              ),
            );
          } catch (e) {
            completer.completeError(
              StorageException('Failed to parse JSON file: $e'),
            );
          }
        });

        reader.onError.listen((event) {
          completer.completeError(
            StorageException('Failed to read file'),
          );
        });

        reader.readAsText(file);
      });

      // Trigger file picker
      input.click();

      return completer.future;
    } catch (e) {
      throw StorageException('Failed to import configuration: $e');
    }
  }
}

/// Container for imported configuration data
class ImportedConfiguration {
  final LoanInputState loanInputState;
  final PaymentPlanConfig paymentPlanConfig;

  ImportedConfiguration({
    required this.loanInputState,
    required this.paymentPlanConfig,
  });
}

/// Custom exception for storage operations
class StorageException implements Exception {
  final String message;

  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:momentum/core/backup/backup_service.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({
    required this.service,
    required this.onRestore,
    super.key,
  });
  final BackupService service;
  final Future<void> Function(PreparedBackup) onRestore;

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _busy = false;
  String? _message;
  bool _isError = false;

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _message = null;
      _isError = false;
    });
    try {
      await action();
    } catch (error) {
      if (mounted) {
        setState(() {
          _isError = true;
          _message =
              error is BackupException
                  ? error.message
                  : 'Die Datei konnte nicht verarbeitet werden. Bitte Speicherort und freien Speicher prüfen und erneut versuchen.';
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export() => _run(() async {
    final bytes = await widget.service.export();
    final stamp =
        DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Sicherung speichern',
      fileName: 'momentum-$stamp.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: bytes,
    );
    if (path == null) return;
    // The mobile picker writes the bytes through the system document provider;
    // desktop implementations return a path for the caller to write.
    if (!Platform.isAndroid && !Platform.isIOS) {
      await File(path).writeAsBytes(bytes, flush: true);
    }
    if (mounted) {
      setState(
        () =>
            _message =
                'Sicherung gespeichert. Bewahre eine Kopie auch außerhalb dieses Handys auf.',
      );
    }
  });

  Future<void> _import() => _run(() async {
    final selection = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: false,
    );
    if (selection == null) return;
    final file = selection.files.single;
    if (file.size > BackupService.maxFileBytes) {
      throw const BackupException('Die Sicherungsdatei ist größer als 50 MB.');
    }
    final bytes = await file.xFile.readAsBytes();
    final backup = await widget.service.prepare(bytes);
    if (!mounted) return;
    final date = backup.createdAt.toLocal();
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Gesamten Bestand ersetzen?'),
            content: Text(
              'Sicherung vom ${date.day}.${date.month}.${date.year}, '
              '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}\n'
              '${backup.taskCount} Aufgaben/Habits · ${backup.entryCount} Einträge\n\n'
              'Alle aktuellen Daten werden durch diese Sicherung ersetzt. '
              'Seitdem neu erfasste Daten gehen dabei verloren. '
              'Exportiere bei Bedarf zuerst deinen aktuellen Stand. '
              'Danach öffnet sich die Startseite.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Abbrechen'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Bestand ersetzen'),
              ),
            ],
          ),
    );
    if (confirmed != true) return;
    await widget.onRestore(backup);
    if (mounted) setState(() => _message = 'Sicherung wiederhergestellt.');
  });

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Import & Export'),
        automaticallyImplyLeading: !_busy,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Deine Datensicherung',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          const Text(
            'Eine Datei für deinen vollständigen Momentum-Bestand – inklusive Einträgen, Historie, Projekten und Papierkorb.',
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _busy ? null : _export,
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text('Sicherung exportieren'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _busy ? null : _import,
            icon: const Icon(Icons.restore_outlined),
            label: const Text('Sicherung importieren'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Die Datei ist unverschlüsselt. Speichere sie an einem Ort, auf den nur berechtigte Personen Zugriff haben. Ein Import ersetzt den gesamten Bestand; es werden keine Daten zusammengeführt.',
          ),
          if (_busy)
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: LinearProgressIndicator(),
            ),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _message!,
                  style: TextStyle(
                    color:
                        _isError ? Theme.of(context).colorScheme.error : null,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

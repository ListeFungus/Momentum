import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/backup/backup_service.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/core/settings/card_display_repository.dart';
import 'package:momentum/core/settings/card_display_scope.dart';
import 'package:momentum/features/aufgaben/data/aufgaben_repository.dart';
import 'package:momentum/features/projekte/data/project_repository.dart';
import 'package:momentum/landing_page.dart';

void main() {
  testWidgets('welcome message opens the main page', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = AufgabenRepository(database);
    final projectRepository = ProjectRepository(database);

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [cardDisplayRouteObserver],
        builder:
            (_, child) => CardDisplayHost(
              repository: CardDisplayRepository(database),
              child: child!,
            ),
        home: WelcomePage(
          aufgabenRepository: repository,
          projectRepository: projectRepository,
          backupService: BackupService(database),
          onRestore: BackupService(database).restore,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Willkommen bei Momentum'), findsOneWidget);
    expect(find.text('Deine Aufgaben'), findsNothing);

    await tester.tap(find.text('Willkommen bei Momentum'));
    await tester.pumpAndSettle();

    expect(find.text('Deine Aufgaben'), findsOneWidget);
    expect(find.text('Aufgaben'), findsOneWidget);
    expect(find.text('Projekte'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(
      tester
          .widget<IconButton>(
            find.widgetWithIcon(IconButton, Icons.chevron_right),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    final picker = tester.widget<DatePickerDialog>(
      find.byType(DatePickerDialog),
    );
    final now = DateTime.now();
    expect(picker.lastDate, DateTime(now.year, now.month, now.day));
    await tester.tap(find.text('Abbrechen'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Import & Export'));
    await tester.pumpAndSettle();
    expect(find.text('Sicherung exportieren'), findsOneWidget);
    expect(find.text('Sicherung importieren'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Optionen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kartenanzeige'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nur eine Karte gleichzeitig aufklappen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aufgeklappt starten'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).onChanged,
      isNull,
    );
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      true,
    );
    await tester.tap(find.text('Letzten Zustand merken'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).onChanged,
      isNotNull,
    );
    final display = await tester.runAsync(
      () => CardDisplayRepository(database).load(),
    );
    expect(display!.mode, CardDisplayMode.remember);
    expect(display.singleOpen, true);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Freie Erstellung'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();

    expect(find.text('Freie Erstellung'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Projekte'));
    await tester.pumpAndSettle();

    expect(find.text('Noch keine Projekte vorhanden.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Projekt hinzufügen'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.create_new_folder));
    await tester.pumpAndSettle();

    expect(find.text('Projekt hinzufügen'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(database.close);
  });
}

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/core/database/app_database.dart';
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
        home: WelcomePage(
          aufgabenRepository: repository,
          projectRepository: projectRepository,
        ),
      ),
    );

    expect(find.text('Willkommen bei Momentum'), findsOneWidget);
    expect(find.text('Deine Aufgaben'), findsNothing);

    await tester.tap(find.text('Willkommen bei Momentum'));
    await tester.pumpAndSettle();

    expect(find.text('Deine Aufgaben'), findsOneWidget);
    expect(find.text('Aufgaben'), findsOneWidget);
    expect(find.text('Projekte'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

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

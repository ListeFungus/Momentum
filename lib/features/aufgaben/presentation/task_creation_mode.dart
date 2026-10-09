enum TaskCreationMode {
  task,
  habit,
  advanced;

  String get title {
    switch (this) {
      case TaskCreationMode.task:
        return 'Aufgabe erstellen';
      case TaskCreationMode.habit:
        return 'Gewohnheit tracken';
      case TaskCreationMode.advanced:
        return 'Freie Erstellung';
    }
  }

  String get saveLabel {
    switch (this) {
      case TaskCreationMode.task:
        return 'Aufgabe speichern';
      case TaskCreationMode.habit:
        return 'Habit speichern';
      case TaskCreationMode.advanced:
        return 'Eintrag speichern';
    }
  }

  String get introText {
    switch (this) {
      case TaskCreationMode.task:
        return 'Für Dinge, die erledigt werden sollen. Wiederholungen sind möglich, die Aufgabe bleibt aber in der Aufgaben-Ansicht.';
      case TaskCreationMode.habit:
        return 'Für Dinge, die regelmäßig beobachtet oder aufgebaut werden sollen. Habits erscheinen in der Habit-Ansicht.';
      case TaskCreationMode.advanced:
        return 'Für freie Kombinationen aus Aufgabenart, Rhythmus, Ziel und später weiteren Regeln.';
    }
  }
}

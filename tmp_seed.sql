PRAGMA foreign_keys = ON;
INSERT OR REPLACE INTO projects (id, name, description, color_hex, sort_order) VALUES
('seed_project_health', 'Gesundheit', 'Habits rund um Gesundheit', '#3C9B78', 0),
('seed_project_training', 'Training', 'Sport und Bewegung', '#E56B4A', 1),
('seed_project_work', 'Arbeit', 'Aufgaben und Fokus', '#527FC7', 2);
INSERT OR REPLACE INTO aufgaben (id, project_id, name, beschreibung, erfassungsmodus, task_type, question_text, success_value, active_weekdays, recurrence, start_date, end_date, due_date, is_active) VALUES
('seed_habit_water', 'seed_project_health', 'Wasser trinken', 'Mindestens bewusst genug trinken', 'checkbox', 'habit', 'Heute genug Wasser getrunken?', 1, '1,2,3,4,5,6,7', 'daily', 1781560800, NULL, NULL, 1),
('seed_habit_no_sugar', 'seed_project_health', 'Kein Zucker', 'Erfolg ist Nein, wenn Zucker gegessen wurde.', 'checkbox', 'habit', 'Heute Zucker gegessen?', 0, '1,2,3,4,5,6,7', 'daily', 1781560800, NULL, NULL, 1),
('seed_habit_training', 'seed_project_training', 'Training', 'Kurzes Workout oder Spaziergang', 'checkbox', 'habit', 'Heute trainiert?', 1, '1,2,3,4,5,6,7', 'daily', 1781560800, NULL, NULL, 1),
('seed_task_today', 'seed_project_work', 'Konzeptnotizen sortieren', 'Heute als normale Aufgabe fällig.', 'checkbox', 'task', '', 1, '1,2,3,4,5,6,7', 'none', 1781560800, NULL, 1781560800, 1),
('seed_task_tomorrow', 'seed_project_work', 'Morgen testen', 'Soll nicht in Heute erscheinen, aber in Dringlichkeit.', 'checkbox', 'task', '', 1, '1,2,3,4,5,6,7', 'none', 1781560800, NULL, 1781647200, 1),
('seed_task_no_due', NULL, 'Idee ohne Zeitdruck', 'Soll nur in Dringlichkeit ohne Fälligkeit erscheinen.', 'checkbox', 'task', '', 1, '1,2,3,4,5,6,7', 'none', 1781560800, NULL, NULL, 1);
INSERT OR REPLACE INTO task_entries (id, task_id, scheduled_date, status, completed_at, updated_at, checkbox_value, number_value, note) VALUES
('seed_habit_water:1781560800', 'seed_habit_water', 1781560800, 'completed', 1781626457, 1781626457, 1, NULL, 'Testnotiz: klappt heute.'),
('seed_habit_no_sugar:1781560800', 'seed_habit_no_sugar', 1781560800, 'pending', NULL, 1781626457, NULL, NULL, ''),
('seed_habit_training:1781560800', 'seed_habit_training', 1781560800, 'pending', NULL, 1781626457, 0, NULL, ''),
('seed_task_today:1781560800', 'seed_task_today', 1781560800, 'pending', NULL, 1781626457, NULL, NULL, ''),
('seed_task_tomorrow:1781647200', 'seed_task_tomorrow', 1781647200, 'pending', NULL, 1781626457, NULL, NULL, '');

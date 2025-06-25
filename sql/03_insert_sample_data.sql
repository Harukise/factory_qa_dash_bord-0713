-- ペットボトル成型工程管理システム サンプルデータ投入
USE factory_qa;

-- 1. 樹脂供給監視のサンプルデータ
INSERT INTO resin_checks (datetime, tank_number, status, checker, amount, supplier, notes) VALUES
('2024-06-20 08:00:00', 'TANK-001', 'OK', '田中太郎', NULL, NULL, '残量十分'),
('2024-06-20 09:30:00', 'TANK-002', 'NG', '佐藤花子', 500.00, '佐藤花子', '残量不足のため補充実施'),
('2024-06-20 11:00:00', 'TANK-003', 'OK', '鈴木一郎', NULL, NULL, '残量確認済み'),
('2024-06-20 13:15:00', 'TANK-001', 'NG', '田中太郎', 750.50, '山田次郎', '定期補充'),
('2024-06-20 15:45:00', 'TANK-002', 'OK', '佐藤花子', NULL, NULL, '補充後残量確認');

-- 2. 温度・基準管理のサンプルデータ
INSERT INTO temperature_records (datetime, lot_number, set_temp, actual_temp, checker, notes) VALUES
('2024-06-20 08:15:00', '250614-GT01', 280.0, 278.5, '田中太郎', '緑茶ボトル成型'),
('2024-06-20 09:45:00', '250614-HT01', 285.0, 287.2, '佐藤花子', 'ほうじ茶ボトル成型'),
('2024-06-20 11:30:00', '250614-BT01', 275.0, 276.8, '鈴木一郎', '紅茶ボトル成型'),
('2024-06-20 13:00:00', '250614-GT01', 280.0, 291.5, '田中太郎', '温度上昇異常検出'),
('2024-06-20 14:30:00', '250614-XX01', 280.0, 279.1, '山田次郎', 'その他製品');

-- 3. プリフォーム品質確認のサンプルデータ
INSERT INTO preform_quality_checks (datetime, sample_number, weight, shape_eval, inspector, notes) VALUES
('2024-06-20 08:30:00', 'SAMPLE-001', 23.4, '良好', '田中太郎', '基準値内'),
('2024-06-20 10:00:00', 'SAMPLE-002', 23.8, '軽微な変形', '佐藤花子', '軽微な変形あるが使用可能'),
('2024-06-20 11:45:00', 'SAMPLE-003', 22.8, '要再加工', '鈴木一郎', '重量不足'),
('2024-06-20 13:30:00', 'SAMPLE-004', 24.2, '廃棄', '田中太郎', '重量超過・形状不良'),
('2024-06-20 15:00:00', 'SAMPLE-005', 23.6, '良好', '山田次郎', '良好な品質');

-- 4. 成型工程モニタのサンプルデータ
INSERT INTO molding_inspections (datetime, product_number, thickness, shape_eval, inspector, notes) VALUES
('2024-06-20 09:00:00', 'BOTTLE-001', 0.28, '正常', '田中太郎', '基準値内の良好な成型'),
('2024-06-20 10:30:00', 'BOTTLE-002', 0.32, '軽微な歪み', '佐藤花子', '軽微な歪みあり'),
('2024-06-20 12:00:00', 'BOTTLE-003', 0.22, '要調整', '鈴木一郎', '厚み不足'),
('2024-06-20 14:00:00', 'BOTTLE-004', 0.38, '不良', '田中太郎', '厚み超過'),
('2024-06-20 16:00:00', 'BOTTLE-005', 0.30, '正常', '山田次郎', '正常な成型品');

-- 5. 冷却時間ログのサンプルデータ
INSERT INTO cooling_records (datetime, lot_number, start_time, end_time, operator, notes) VALUES
('2024-06-20 09:15:00', 'LOT-20240620-001', '2024-06-20 09:15:00', '2024-06-20 09:45:00', '田中太郎', '標準冷却時間'),
('2024-06-20 11:00:00', 'LOT-20240620-002', '2024-06-20 11:00:00', '2024-06-20 11:25:00', '佐藤花子', '冷却時間正常'),
('2024-06-20 13:45:00', 'LOT-20240620-003', '2024-06-20 13:45:00', '2024-06-20 14:50:00', '鈴木一郎', '冷却時間過長'),
('2024-06-20 15:30:00', 'LOT-20240620-004', '2024-06-20 15:30:00', '2024-06-20 15:40:00', '田中太郎', '冷却時間不足'),
('2024-06-20 17:00:00', 'LOT-20240620-005', '2024-06-20 17:00:00', '2024-06-20 17:35:00', '山田次郎', '適切な冷却');

-- 6. 検査工程のサンプルデータ
INSERT INTO final_inspections (datetime, inspection_id, visual_check, dimension_check, pressure_check, inspector, notes) VALUES
('2024-06-20 10:00:00', 'INS-20240620-001', '合格', '合格', '合格', '田中太郎', 'すべての検査項目合格'),
('2024-06-20 11:30:00', 'INS-20240620-002', '合格', '不合格', '合格', '佐藤花子', '寸法検査で不合格'),
('2024-06-20 13:00:00', 'INS-20240620-003', '不合格', '合格', '合格', '鈴木一郎', '目視検査で不合格'),
('2024-06-20 14:45:00', 'INS-20240620-004', '合格', '合格', '不合格', '田中太郎', '耐圧検査で不合格'),
('2024-06-20 16:15:00', 'INS-20240620-005', '合格', '合格', '合格', '山田次郎', 'すべて合格');

-- 7. トレーサビリティデータの自動生成（トリガーで実装予定）
-- 手動でサンプルデータを投入
INSERT INTO process_traceability (lot_number, process_step, datetime, operator, result, details, reference_table, reference_id) VALUES
('250614-GT01', '樹脂供給', '2024-06-20 08:00:00', '田中太郎', 'OK', '{"tank": "TANK-001", "status": "OK"}', 'resin_checks', 1),
('250614-GT01', '温度管理', '2024-06-20 08:15:00', '田中太郎', 'OK', '{"set_temp": 280.0, "actual_temp": 278.5}', 'temperature_records', 1),
('250614-HT01', '樹脂供給', '2024-06-20 09:30:00', '佐藤花子', 'NG', '{"tank": "TANK-002", "status": "NG", "action": "補充実施"}', 'resin_checks', 2),
('250614-HT01', '温度管理', '2024-06-20 09:45:00', '佐藤花子', 'OK', '{"set_temp": 285.0, "actual_temp": 287.2}', 'temperature_records', 2);

-- データ投入完了確認
SELECT '樹脂供給監視' as テーブル名, COUNT(*) as レコード数 FROM resin_checks
UNION ALL
SELECT '温度・基準管理', COUNT(*) FROM temperature_records
UNION ALL
SELECT 'プリフォーム品質', COUNT(*) FROM preform_quality_checks
UNION ALL
SELECT '成型工程監視', COUNT(*) FROM molding_inspections
UNION ALL
SELECT '冷却時間ログ', COUNT(*) FROM cooling_records
UNION ALL
SELECT '検査工程', COUNT(*) FROM final_inspections
UNION ALL
SELECT 'トレーサビリティ', COUNT(*) FROM process_traceability;

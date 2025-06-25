-- ペットボトル成型工程管理システム テーブル作成
USE factory_qa;

-- 1. 樹脂供給監視テーブル
CREATE TABLE resin_checks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tank_number VARCHAR(20) NOT NULL COMMENT 'タンク番号',
    status ENUM('OK', 'NG') NOT NULL COMMENT '残量状況',
    checker VARCHAR(50) NOT NULL COMMENT '確認者',
    amount DECIMAL(8,2) NULL COMMENT '補充量(kg)',
    supplier VARCHAR(50) NULL COMMENT '補充者',
    notes TEXT NULL COMMENT '備考',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_datetime (datetime),
    INDEX idx_tank_number (tank_number),
    INDEX idx_status (status)
) ENGINE=InnoDB COMMENT='樹脂供給監視記録';

-- 2. 温度・基準管理テーブル
CREATE TABLE temperature_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lot_number VARCHAR(50) NOT NULL COMMENT 'ロット番号',
    set_temp DECIMAL(5,2) NOT NULL COMMENT '設定温度(°C)',
    actual_temp DECIMAL(5,2) NOT NULL COMMENT '実測温度(°C)',
    difference DECIMAL(5,2) GENERATED ALWAYS AS (actual_temp - set_temp) STORED COMMENT '温度差',
    judgment ENUM('OK', 'NG') AS (
        CASE 
            WHEN ABS(actual_temp - set_temp) <= 5.0 THEN 'OK'
            ELSE 'NG'
        END
    ) STORED COMMENT '判定結果',
    checker VARCHAR(50) NOT NULL COMMENT '測定者',
    notes TEXT NULL COMMENT '備考',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_datetime (datetime),
    INDEX idx_lot_number (lot_number),
    INDEX idx_judgment (judgment)
) ENGINE=InnoDB COMMENT='温度・基準管理記録';

-- 3. プリフォーム品質確認テーブル
CREATE TABLE preform_quality_checks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sample_number VARCHAR(50) NOT NULL COMMENT 'サンプル番号',
    weight DECIMAL(6,2) NOT NULL COMMENT '重量(g)',
    weight_judgment ENUM('OK', 'NG') AS (
        CASE 
            WHEN weight BETWEEN 23.0 AND 24.0 THEN 'OK'
            ELSE 'NG'
        END
    ) STORED COMMENT '重量判定',
    shape_eval ENUM('良好', '軽微な変形', '要再加工', '廃棄') NOT NULL COMMENT '形状評価',
    overall_judgment ENUM('合格', '不合格') AS (
        CASE 
            WHEN weight_judgment = 'OK' AND shape_eval IN ('良好', '軽微な変形') THEN '合格'
            ELSE '不合格'
        END
    ) STORED COMMENT '総合判定',
    inspector VARCHAR(50) NOT NULL COMMENT '検査者',
    photo_path VARCHAR(255) NULL COMMENT '写真パス',
    recommended_action VARCHAR(100) NULL COMMENT '推奨処理',
    notes TEXT NULL COMMENT '備考',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_datetime (datetime),
    INDEX idx_sample_number (sample_number),
    INDEX idx_overall_judgment (overall_judgment)
) ENGINE=InnoDB COMMENT='プリフォーム品質確認記録';

-- 4. 成型工程モニタテーブル
CREATE TABLE molding_inspections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    product_number VARCHAR(50) NOT NULL COMMENT '製品番号',
    thickness DECIMAL(5,3) NOT NULL COMMENT '厚み(mm)',
    thickness_judgment ENUM('OK', 'NG') AS (
        CASE 
            WHEN thickness BETWEEN 0.25 AND 0.35 THEN 'OK'
            ELSE 'NG'
        END
    ) STORED COMMENT '厚み判定',
    shape_eval ENUM('正常', '軽微な歪み', '要調整', '不良') NOT NULL COMMENT '形状評価',
    overall_judgment ENUM('合格', '不合格') AS (
        CASE 
            WHEN thickness_judgment = 'OK' AND shape_eval IN ('正常', '軽微な歪み') THEN '合格'
            ELSE '不合格'
        END
    ) STORED COMMENT '総合判定',
    inspector VARCHAR(50) NOT NULL COMMENT '検査者',
    recommended_action VARCHAR(100) NULL COMMENT '推奨処理',
    notes TEXT NULL COMMENT '備考',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_datetime (datetime),
    INDEX idx_product_number (product_number),
    INDEX idx_overall_judgment (overall_judgment)
) ENGINE=InnoDB COMMENT='成型工程監視記録';

-- 5. 冷却時間ログテーブル
CREATE TABLE cooling_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lot_number VARCHAR(50) NOT NULL COMMENT 'ロット番号',
    start_time DATETIME NOT NULL COMMENT '冷却開始時刻',
    end_time DATETIME NOT NULL COMMENT '冷却終了時刻',
    cooling_time_minutes INT GENERATED ALWAYS AS (TIMESTAMPDIFF(MINUTE, start_time, end_time)) STORED COMMENT '冷却時間(分)',
    judgment ENUM('OK', 'NG') AS (
        CASE 
            WHEN TIMESTAMPDIFF(MINUTE, start_time, end_time) BETWEEN 15 AND 45 THEN 'OK'
            ELSE 'NG'
        END
    ) STORED COMMENT '判定結果',
    operator VARCHAR(50) NOT NULL COMMENT '担当者',
    notes TEXT NULL COMMENT '備考',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_datetime (datetime),
    INDEX idx_lot_number (lot_number),
    INDEX idx_judgment (judgment)
) ENGINE=InnoDB COMMENT='冷却時間ログ記録';

-- 6. 検査工程テーブル
CREATE TABLE final_inspections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    inspection_id VARCHAR(50) NOT NULL COMMENT '検査対象ID',
    visual_check ENUM('合格', '不合格') NOT NULL COMMENT '目視検査',
    dimension_check ENUM('合格', '不合格') NOT NULL COMMENT '寸法検査',
    pressure_check ENUM('合格', '不合格') NOT NULL COMMENT '耐圧検査',
    overall_judgment ENUM('合格', '不合格') AS (
        CASE 
            WHEN visual_check = '合格' AND dimension_check = '合格' AND pressure_check = '合格' THEN '合格'
            ELSE '不合格'
        END
    ) STORED COMMENT '総合判定',
    inspector VARCHAR(50) NOT NULL COMMENT '検査者',
    photo_path VARCHAR(255) NULL COMMENT '検査画像パス',
    recommended_action VARCHAR(100) NULL COMMENT '推奨処理',
    notes TEXT NULL COMMENT '備考',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_datetime (datetime),
    INDEX idx_inspection_id (inspection_id),
    INDEX idx_overall_judgment (overall_judgment)
) ENGINE=InnoDB COMMENT='最終検査記録';

-- 7. トレーサビリティ統合ビュー用テーブル
CREATE TABLE process_traceability (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lot_number VARCHAR(50) NOT NULL COMMENT 'ロット番号',
    process_step ENUM('樹脂供給', '温度管理', 'プリフォーム', '成型', '冷却', '検査') NOT NULL COMMENT '工程段階',
    datetime DATETIME NOT NULL COMMENT '処理日時',
    operator VARCHAR(50) NOT NULL COMMENT '作業者',
    result ENUM('OK', 'NG', '合格', '不合格') NOT NULL COMMENT '結果',
    details JSON NULL COMMENT '詳細データ',
    reference_table VARCHAR(50) NOT NULL COMMENT '参照テーブル名',
    reference_id INT NOT NULL COMMENT '参照レコードID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_lot_number (lot_number),
    INDEX idx_process_step (process_step),
    INDEX idx_datetime (datetime)
) ENGINE=InnoDB COMMENT='工程トレーサビリティ統合記録';

-- テーブル作成完了メッセージ
SELECT 'すべてのテーブルが正常に作成されました' AS status;

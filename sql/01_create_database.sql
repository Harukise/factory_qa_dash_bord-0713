-- ペットボトル成型工程管理システム データベース作成
-- MySQLデータベースとユーザーの作成

-- データベースの作成
CREATE DATABASE IF NOT EXISTS factory_qa 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- ユーザーの作成と権限付与
CREATE USER IF NOT EXISTS 'qa_user'@'localhost' IDENTIFIED BY '4875';
GRANT ALL PRIVILEGES ON factory_qa.* TO 'qa_user'@'localhost';
FLUSH PRIVILEGES;

-- データベースの使用
USE factory_qa;

-- データベース確認
SELECT 'データベース factory_qa が正常に作成されました' AS status;

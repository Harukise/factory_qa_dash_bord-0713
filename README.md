# 🏭 Factory QA Dashbord

「Factory QA Dashbord」は、工場の品質管理業務を支援する Webアプリケーションです。  
このリポジトリには、HTMLフロントエンド、Node.js（Express）によるバックエンド、MySQLデータベース、および初期データ構築用のSQLファイルが含まれています。

---

## 📸 スクリーンショット

![フロントエンド画面](images/frontend_UI.png)

> ※ `/images/preview.png` に画面キャプチャを保存してください。

---

## 🎯 運用目的と利用シーン

本アプリは、特に**樹脂成形工程における品質保証（QA）業務の効率化**を目的としています。  
紙ベースの点検記録をデジタル化し、以下のような業務をサポートします：

- 成形ラインにおける **樹脂タンクの残量チェック**
- 定期的な **検査結果の記録**
- 複数ラインに渡る **品質管理状況の可視化**

---

## ⚠️ 現在の機能と制限事項（実装状況）

2025年6月時点での実装範囲は以下の通りです：

- ✅ 「**樹脂供給監視**」タブ内の「**残量チェック**」は **MySQLデータベースに正しく記録**されます。
- 🚫 同タブ内の「**補充完了**」ボタンは **まだデータベースと連携されていません**。
- 🚫 その他のタブ（目視確認、寸法検査など）の記録操作も **現時点では未接続**です。

今後のアップデートで、全タブからのデータベース記録、APIルーティング、記録履歴の表示機能などを順次実装予定です。

---

## 🛠 セットアップ手順（ローカル環境）

1. このリポジトリをクローン

```bash
git clone https://github.com/harukise/factoryqa-dashbord.git
cd factoryqa-dashbord


2. 必要なパッケージのインストール（Node.js）
npm install


3.MySQL データベースの初期化
MySQLに接続し、以下の SQL ファイルを順番に実行してください：
source sql/01_create_database.sql;
source sql/02_create_tables.sql;
source sql/03_insert_sample_data.sql;

//適切にインポートできない場合は各sqlファイルを参照して
  sqlファイルに記載された各クエリを入力して実行してみてください


4.サーバーを起動
node server.js


5. アプリにアクセス
http://localhost:3000/index2.html


📁 ディレクトリ構成
factory_qa_dashbord-0625/
├── frontend/
│   └── index2.html
├── backend/
│   └── factory_qa_server/
│       ├── server.js
│       ├── package.json
│       ├── package-lock.json
│       └── node_modules/
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   └── 03_insert_sample_data.sql  
├── .gitignore
├── README.md


🏢 運用方針（社内限定）

本アプリは、外部サーバーにデプロイせず、工場内や社内ネットワーク上に限定して運用することを想定しています。  
Node.js + MySQL をイントラネット上のマシンで起動し、各クライアントはそのIPにアクセスすることでアプリを利用できます。

例：`http://192.168.0.100:3000/index2.html`


📄 ライセンス
MIT License


🙋 作者
GitHub: @harukise

開発・改善のご提案お待ちしています！








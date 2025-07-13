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







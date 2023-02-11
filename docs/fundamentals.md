# Workflow

-   `.github/workflows`内に定義
-   1 つ以上の Job を含む

### Skip Workflow

on: push または on: pull_request 時に
コミットメッセージに以下を入れて commit するとワークフローがスキップされます

-   [skip ci]
-   [ci skip]
-   [no ci]
-   [skip actions]
-   [actions skip]

https://docs.github.com/ja/actions/managing-workflow-runs/skipping-workflow-runs

## Jobs

-   runner を定義する
-   デフォルトでは並列処理をする
-   1 つ以上の Step を含む
-   条件分岐もできる

### Job Artifacts

GitHub が提供している Action です<br>
成果物という意味でワークフロー終了後にデータを保存したりジョブ間でデータを共有したりするときに使えます

-   該当するファイル/フォルダを GitHub 上にアップロード

```
    - name: upload artifact
    　uses: actions/upload-artifact@v3
    　with:
        # 名前は任意
        # 以下のファイル/フォルダがアップロードされる
        name: dist-files
        # アップロードしたいファイル/フォルダのパス
        # 複数指定可
        path: |
        　application/dist
        　application/package.json
```

https://github.com/actions/upload-artifact

## Steps

-   Step 内で Action もしくはシェルコマンドなどを実行
-   Step は順番に実行される(並列では実行されない)
-   条件分岐もできる

## Event

ワークフローが実行されるタイミング
| イベント | 説明 |
|-----|-----|
| workflow_dispatch | ワークフローを手動で実行できるよう設定 |
| push | リポジトリへ push されたとき |
| pull_request | プルリクエスト関連 |
| schedule | 特定の時間に実行できるよう設定 |

などなど

下記のように設定する

```yml:.github/workflows/workflow.yml
on: push
```

また、

```yml:.github/workflows/workflow.yml
on: [push, workflow_dispatch]
```

のように`[]`内に入れて複数定義することもできる

詳しくは下記を参照

https://docs.github.com/ja/actions/using-workflows/events-that-trigger-workflows

### Activity Type

push などのイベントによっては複数のアクティビティの種類があります
例えば pull_request には

-   opened
-   synchronized
-   reopened

などイベントを実行する際の条件(トリガー)を指定することができます<br>
(pull_request のデフォルトのアクティビティタイプは上記の 3 つのトリガー)

以下のようにアクティビィタイプを指定します

```
on:
  pull_request:
    types:
     - opened
```

複数の Event を指定するときは以下の通りにします
各 Event のインデントは揃えましょう

```
on:
  pull_request:
    types:
     - opened
  workflow_dispatch:
```

### Event Filters

イベントを実行する際のブランチなどを絞り込むことができます

Event Filters の詳細は以下の通りです

https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#filter-pattern-cheat-sheet

#### branches

特定のブランチでのみワークフローを実行

```
on:
  push:
    branches:
      - main
      # 全ての`feature/`ブランチ
      - "feature/**"
```

#### branches-ignore

特定のブランチ以外ワークフローを実行
(指定したブランチでワークフローを実行しない)

```
on:
  push:
    branches-ignore:
      # 全ての`doc/`ブランチ
      - "release/**
      - "doc/**"
```

## Actions

ワークフロー内で複雑な処理を簡単に実行できるためのアプリケーション
GitHub Actions の Marketplace から使用したい Action を自由に使用できる

## Runner

下記の README.md にサポートしているパッケージの一覧が記載されています<br>
よく使われているのが`ubuntu`です

```
jobs:
  test:
    runs-on: ubuntu-latest
```

https://github.com/actions/runner-images/tree/main/images/linux

## Cache

Cache を使ってパッケージのインストール時間を短縮できます

```
    - name: Cache Dependencies
      uses: actions/cache@v3
      with:
        path: '**/node_modules'
        # 一意である必要がある
        key: node-modules-${{ hashFiles('**/package-lock.json') }}
```

### setup-node を使うとき

```
     - name: Install NodeJS
       uses: actions/setup-node@v3
       with:
        node-version: 16
        cache: 'npm'
        cache-dependency-path: '**/package-lock.json'
```

hashFiles 関数を使うことで()内のファイル/フォルダが変更されるたびに key 作成時に新しいハッシュが発行されます

hashFiles 関数についての詳細は以下の url を参照

https://docs.github.com/ja/actions/learn-github-actions/expressions#hashfiles

```
'**/node_modules'
'**/package-lock.json'
```

という風に`**/`と記載することでディレクトリ構成関係なく該当するファイル/フォルダを取得できます

Cache の詳細は以下を参照してください

https://github.com/actions/cache

## Environment Variables

```
env:
  MYSQL_USER: test
```

上記のように定義することで workflow 内に環境変数を定義することができます
また、環境変数を Step ごとに定義することもできます
GitHub Actions が提供している環境変数です

https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables

秘匿情報を環境変数として使用する場合は secrets を使用します

## Operator

演算子のことです<br>

-   <
-   !
-   &&
-   ||

などなど

以下を参照

https://docs.github.com/ja/actions/learn-github-actions/expressions

## Status Check Function

if condition を使用するときに Workflow のステータスを確認できます

-   success
-   always
-   cancelled
-   failure

などなど

以下を参照

https://docs.github.com/en/actions/learn-github-actions/expressions#status-check-functions

## Matrix

同じワークフローを複数の

-   パッケージ
-   ランナー OS
-   言語

のバージョンで実行できる仕組み
全てのバージョンを並列で実行できる
Matrix を使用するとき一つの Jobs が失敗すると他の Jobs が実行されません
(continue-on-error を追加した場合は除く)

```
jobs:
  build:
    # 実行したいバッケージ等のバージョンを配列内にstrategyとmatrixに指定
    strategy:
      matrix:
        node-version: [12, 14, 16]
        os: [ubuntu-latest, ubuntu-20.04]
    runs-on: ${{ matrix.os }}
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Install NodeJS
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
          cache-dependency-path: '**/package-lock.json'
```

## workflow_call

一つのワークフローを別のワークフローで使い回すときに使用

reusable.yml(今回他のワークフローでも使い回すワークフロー)

```
name: Reusable Deploy

# workflow_callを必ず定義する
on:
  workflow_call:
    inputs:
      # このワークフローを呼ぶ際に変数を使用できるようにする
      artifact-name:
        description: The name of the artifact files
        # falseにすると定義したinputsであるartifact-nameを任意項目にできる
        required: false
        # デフォルト値を指定
        default: dist
        # 型を指定
        type: string
    # secretsを変数として使用することもできる
    # secrets:
      # some-secret:
        # required: false

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Output Information
        run: echo "Deploying & uploading..."
```

use-reuse.yml(reusable.yml 内の jobs を使用するワークフロー)

```
  deploy:
    needs: build
    # reusable.yml内のJobsを参照させる
    # 絶対パスを以下のように指定
    uses: ./.github/workflows/reusable.yml
    with:
      artifact-name: dist-files
    # secretsを利用することもできます
    # secrets:
      # sone-secret: ${{ secrets.sone-secret }}
```

## Context

https://docs.github.com/ja/actions/learn-github-actions/contexts

## Expression

https://docs.github.com/ja/actions/learn-github-actions/expressions

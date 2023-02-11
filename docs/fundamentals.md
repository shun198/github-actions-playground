# Workflow

-   `.github/workflows`内に定義
-   1 つ以上の Job を含む

## Jobs

-   runner を定義する
-   デフォルトでは並列処理をする
-   1 つ以上の Step を含む
-   条件分岐もできる

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

のように[]内に入れて複数定義することもできる

詳しくは下記を参照

https://docs.github.com/ja/actions/using-workflows/events-that-trigger-workflows

### Activity Type

push などのイベントによっては複数のアクティビティの種類があります
例えば pull_request には

-   opened
-   synchronized
-   reopened

などイベントを実行する際の条件(トリガー)を指定することができます
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
      - "doc/**"
```

## Actions

ワークフロー内で複雑な処理を簡単に実行できるためのアプリケーション
GitHub Actions の Marketplace から使用したい Action を自由に使用できる

## Runner

下記の README.md にサポートしているパッケージの一覧が記載されている

https://github.com/actions/runner-images/tree/main/images/linux

## Context

https://docs.github.com/ja/actions/learn-github-actions/contexts

## Expression

https://docs.github.com/ja/actions/learn-github-actions/expressions

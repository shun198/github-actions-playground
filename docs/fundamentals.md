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

## Actions

ワークフロー内で複雑な処理を簡単に実行できるためのアプリケーション
GitHub Actions の Marketplace から使用したい Action を自由に使用できる

## Runner

下記の README.md にサポートしているパッケージの一覧が記載されている

https://github.com/actions/runner-images/tree/main/images/linux

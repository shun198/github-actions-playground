# Workflow

- `.github/workflows`内に定義
- 1 つ以上の Job を含む

### Skip Workflow

on: push または on: pull_request 時に
コミットメッセージに以下を入れて commit するとワークフローがスキップされます

- [skip ci]
- [ci skip]
- [no ci]
- [skip actions]
- [actions skip]

https://docs.github.com/ja/actions/managing-workflow-runs/skipping-workflow-runs

## Jobs

- runner を定義する
- デフォルトでは並列処理をする
- 1 つ以上の Step を含む
- 条件分岐もできる

### Job Artifacts

GitHub が提供している Action です<br>
成果物という意味でワークフロー終了後にデータを保存したりジョブ間でデータを共有したりするときに使えます

- 該当するファイル/フォルダを GitHub 上にアップロード

```yml
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

- Step 内で Action もしくはシェルコマンドなどを実行
- Step は順番に実行される(並列では実行されない)
- 条件分岐もできる

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

```yml
on: push
```

また、

```yml
on: [push, workflow_dispatch]
```

のように`[]`内に入れて複数定義することもできる

詳しくは下記を参照

https://docs.github.com/ja/actions/using-workflows/events-that-trigger-workflows

### Activity Type

push などのイベントによっては複数のアクティビティの種類があります
例えば pull_request には

- opened
- synchronized
- reopened

などイベントを実行する際の条件(トリガー)を指定することができます<br>
(pull_request のデフォルトのアクティビティタイプは上記の 3 つのトリガー)

以下のようにアクティビィタイプを指定します

```yml
on:
  pull_request:
    types:
      - opened
```

複数の Event を指定するときは以下の通りにします
各 Event のインデントは揃えましょう

```yml
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

```yml
on:
  push:
    branches:
      - main
      # 全ての`feature/`ブランチ
      - 'feature/**'
```

#### branches-ignore

特定のブランチ以外ワークフローを実行
(指定したブランチでワークフローを実行しない)

```yml
on:
  push:
    branches-ignore:
      # 全ての`doc/`ブランチ
      - 'doc/**'
```

## Actions

ワークフロー内で複雑な処理を簡単に実行できるためのアプリケーション
GitHub Actions の Marketplace から使用したい Action を自由に使用できる

## Runner

下記の README.md にサポートしているパッケージの一覧が記載されています<br>
よく使われているのが`ubuntu`です

```yml
jobs:
  test:
    runs-on: ubuntu-latest
```

https://github.com/actions/runner-images/tree/main/images/linux

## Cache

Cache を使ってパッケージのインストール時間を短縮できます

```yml
- name: Cache Dependencies
  uses: actions/cache@v3
  with:
    path: '**/node_modules'
    # 一意である必要がある
    key: node-modules-${{ hashFiles('**/package-lock.json') }}
```

### setup-node を使うとき

```yml
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

```yml
'**/node_modules'
'**/package-lock.json'
```

という風に`**/`と記載することでディレクトリ構成関係なく該当するファイル/フォルダを取得できます

Cache の詳細は以下を参照してください

https://github.com/actions/cache

## Environment Variables

```yml
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

- <
- !
- &&
- ||

などなど

以下を参照

https://docs.github.com/ja/actions/learn-github-actions/expressions

## Status Check Function

if condition を使用するときに Workflow のステータスを確認できます

- success
- always
- cancelled
- failure

などなど

以下を参照

https://docs.github.com/en/actions/learn-github-actions/expressions#status-check-functions

## Matrix

同じワークフローを複数の

- パッケージ
- ランナー OS
- 言語

のバージョンで実行できる仕組み
全てのバージョンを並列で実行できる
Matrix を使用するとき一つの Jobs が失敗すると他の Jobs が実行されません
(continue-on-error を追加した場合は除く)

```yml
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

```yml
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
    # 出力用
    outputs:
      result:
        description: The result of the deployment operation
        # deployジョブ内のoutputs.outcomeを出力する
        value: ${{ jobs.deploy.outputs.outcome }}

jobs:
  deploy:
    outputs:
      outcome: ${{ steps.set-result.outputs.step-result }}
    runs-on: ubuntu-latest
    steps:
      - name: Get build artifacts
        uses: actions/download-artifact@v3
        with:
          name: ${{ inputs.artifact-name }}
      - name: List files
        run: ls -la
      - name: Output Information
        run: echo "Deploying & uploading..."
      - name: Set result output
        id: set-result
        run: echo "step-result=success" >> $GITHUB_OUTPUT
```

use-reuse.yml(reusable.yml 内の jobs を使用するワークフロー)

```yml
deploy:
  # jobsはデフォルトで並列になってしまう
  # ビルドが成功したときのみデプロイを実行させたい場合はneedsを追加する
  needs: build
  # reusable.yml内のJobsを参照させる
  uses: ./.github/workflows/reusable.yml
  with:
    artifact-name: dist-files
print-deploy-result:
  needs: deploy
  runs-on: ubuntu-latest
  steps:
    - name: Print deploy output
      run: echo "${{ needs.deploy.outputs.result }}"
```

## Custom Actions

カスタムアクションを作成するには action.yml に必要な設定を記載する必要があります
今回は Cache を使う処理を共通化したいので以下のようなリポジトリ構成にします

```
└── .github
    └── actions
        └──cache
            └──action.yml
    └── workflows
            └──custom-action.yml
```

action.yml に以下のように共通化したい処理を記載します
今回は npm の Cache を使う処理を共通化します

```yml
name: 'Get & Cache Dependencies'
# onはいらない
description: 'Get the dependencies via npm and cache node modules'
runs:
  # compositeが必須
  using: 'composite'
  steps:
    - name: Cache dependencies
      id: cache
      uses: actions/cache@v3
      with:
        path: '**/node_modules'
        key: node-modules-${{ hashFiles('**/package-lock.json') }}
    - name: Install dependencies
      if: steps.cache.outputs.cache-hit != 'true'
      run: npm ci
      # shellは必須
      shell: bash
```

custom-action.yml に以下のように作成した action.yml の絶対パスを指定します

```yml
- name: Load and cache dependencies
  uses: ./.github/actions/cache
```

## Context

https://docs.github.com/ja/actions/learn-github-actions/contexts

## Expression

https://docs.github.com/ja/actions/learn-github-actions/expressions

## Security

### Script Injection

ユーザに入力させたい値などは env を使うことを強く推奨します

### Permission

たとえば issues のみ権限を付与しないなど、特定の権限を付与したい場合は permissions を使う

```yml
permissions:
  issues: write
```

詳細は以下の通りです

https://docs.github.com/ja/actions/using-jobs/assigning-permissions-to-jobs

https://docs.github.com/ja/actions/security-guides/automatic-token-authentication

### OpenID connect

GitHub Actions を使う際に secrets に秘匿情報を入れずに IAM で認証できるようにする仕組みです

https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect

### Link

詳細は以下のリンクを参照

https://docs.github.com/ja/actions/security-guides/security-hardening-for-github-actions

https://docs.github.com/ja/actions/security-guides/encrypted-secrets

https://docs.github.com/ja/actions/security-guides/automatic-token-authentication

https://securitylab.github.com/research/github-actions-preventing-pwn-requests/

https://docs.github.com/ja/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect

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

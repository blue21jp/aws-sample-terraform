# Terraformサンプル

## 必要環境

- localstack
- awscli
- tfenv(terraform)
- tflint
- make
- aws ec2 キーペア(sandbox)

## Files

| path                           | desc                             |
|--------------------------------|----------------------------------|
| Makefile                       | コマンド操作ヘルパー             |
| global/backend.tf              | 共通のバックエンド設定           |
| global/providers_aws.tf        | 共通のプロバイダ設定(aws)        |
| global/providers_localstack.tf | 共通のプロバイダ設定(localstack) |
| global/locals.tf               | 共通の変数                       |
| global/versions.tf             | 共通のバージョン設定             |
| global/ip.sh                   | 自分PC(mac or linux)のIP取得     |
| modules/                       | 自作モジュール                   |
| stacks_base/                   | 共通基盤のリソース               |
| stacks_demo/                   | demo用のリソース                 |
| stacks_template/               | stacksのテンプレート             |

## Setup

tfenvでterraformインストール

```
$ tfenv install 1.3.6
$ tfenv use 1.3.6
```

aws-cliの設定。プロファイル作成

```
$ aws configure
```

terraformに、aws-cliのプロファイルとリージョンを指定

```
$ vi stacks_base/common_dev.tfvars
$ vi stacks_base/common_prd.tfvars
```

## AWS環境の構築(localstack)

ENVを省略するとdev(localstack)になります。

一括
```
$ make plan [ENV=dev] -C stacks_base
$ make apply [ENV=dev] -C stacks_base
$ make destroy [ENV=dev] -C stacks_base
```

個別
```
$ make plan [ENV=dev] -C stacks_base/01_network
$ make apply [ENV=dev] -C stacks_base/01_network
$ make destroy [ENV=dev] -C stacks_base/01_network
```

## AWS環境の構築(aws)

一括
```
$ make plan ENV=prd -C stacks_base
$ make apply ENV=prd -C stacks_base
$ make destroy ENV=prd -C stacks_base
```

個別
```
$ make plan ENV=prd -C stacks_base/01_network
$ make apply ENV=prd -C stacks_base/01_network
$ make destroy ENV=prd -C stacks_base/01_network
```

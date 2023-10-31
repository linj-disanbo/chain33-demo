# 积分智能合约的使用

指集成于chain33 公链的 token 合约

## 配置

```
[exec.sub.token]
tokenApprs = [
        "0x2cb1656b4cc952975b5cd4efdaead4e3a68003c4",
        "1Q8hGLfoGe63efeWa8fJ4Pnukhkngt6poK",
]
```

配置token合约的管理员. 使用管理员地址发行token. 


## 测试脚本需要配置

```
MAIN_HTTP="" # 服务器地址
tokenAddr="1Q8hGLfoGe63efeWa8fJ4Pnukhkngt6poK" # 对应配置文件中的管理员地址
superManager="0xc34b5d9d44ac7b754806f761d3d4d2c4fe5214f6b074c19f069c4f5c2a29c8cc" # 对应配置文件中的管理员的私钥
```


## 积分的发行

```
    token_preCreate 申请积分发行
    token_getPreCreated 查询申请发行

    token_finish  审核通过积分发行
    token_getFinishCreated 查询发行的积分
```

## 积分转账

可以用于积分的发放

token_transfer

## 查询积分

 可以用于积分显示

 token_balance


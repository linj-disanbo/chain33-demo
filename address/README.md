$ go test . -v
=== RUN   TestNewMnemonic
    address_test.go:18: 狱 集 不 位 黎 谱 缸 婚 卖 妇 然 句 爬 暗 壳
--- PASS: TestNewMnemonic (0.00s)
=== RUN   TestMnemonicToPrivateKey
    address_test.go:33: 私钥：0x0445b197b935d99feaac690a567fb7e84ded0940bc046248213a211dd912285e
    address_test.go:34: 公钥：0x03f9031501ccfc7aeac0a158177ddde9d2da0efe3ef1e732ec80c99f871b8042a2
--- PASS: TestMnemonicToPrivateKey (0.03s)
=== RUN   TestPrivateKeyToPublicKey
--- PASS: TestPrivateKeyToPublicKey (0.04s)
=== RUN   TestPublicKeyToAddress
    address_test.go:59: 地址：1Cw81xtpSArHLxoMpv4KPBmqQPeA4cXwEB
--- PASS: TestPublicKeyToAddress (0.00s)
=== RUN   TestSignatureAndVerify
    address_test.go:80: 签名结果：0x3045022100bf75d0eb72ce9da5564334ee7f3ff022aff4e7811bfac74ca434cb7e958389da022009ac74c14209c1dee32a1cf71dbe5ef144f1ebb40b964d02163df09338aa06ff
    address_test.go:88: 验签结果：true
--- PASS: TestSignatureAndVerify (0.00s)
PASS
ok  	address	0.088s

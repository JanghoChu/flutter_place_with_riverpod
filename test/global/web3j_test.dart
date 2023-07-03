import 'package:test/test.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_place_with_riverpod/global/web3j.dart';

void main() {
  const rpcUrl = 'https://rpc-mumbai.maticvigil.com';

  const from = '0x1bff4704528f437836fe410bc1f5e7092bda333b';
  const to = '0xca05B369aD9ca38F73867a094743a1341698aE3c';

  final chainId = BigInt.from(80001);
  final value = EtherAmount.fromInt(EtherUnit.gwei, 100000);

  // 1. web3j().createMessage()만 돌려서(sendTx()는 주석처리) message를 확인함(sha3 되지 않은 message)
  // 2. h3-server에서 AssetMovement.of 의 raxTx를 message로 변경
  // 3. parties(hot, cold), devices 각각 실행
  // 4. h3-server에서 moveAsset.feature를 실행
  // 5. moveAsset.feature의 message(sha3적용)와 uuid를 변경하고 "채원 join" 시나리오 실행
  // 6. 서명 후 얻은 r, s, v 값을 붙여넣기
  // 7. 생성된 address를 네트워크에서 검색해서 정상적으로 tx 전송됨을 확인

  group('web3j_test', () {
    test('createMessage create message and send raw transaction', () async {
      final res = await Web3j().createMessage(
        rpcUrl: rpcUrl,
        chainId: chainId,
        from: from,
        to: to,
        value: value,
      );

      // mpe

      print(await Web3j().sendTx(
        rpcUrl: rpcUrl,
        chainId: chainId,
        tx: res['tx'] as Transaction,
        r: "14be204dea51b032ebf4514497ce21d6494ca88d7063bc93fe978bb35260a85a",
        s: "4e24e8026384f8f75e9f2a09c18dea994aa37a393fd9030d065a4a04e25ea288",
        v: "1",
      ));
    });
  });
}

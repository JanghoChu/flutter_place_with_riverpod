import 'dart:typed_data';

import 'package:http/http.dart';

import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/src/utils/rlp.dart' as rlp;
import 'package:web3dart/src/utils/length_tracking_byte_sink.dart' as ltb;
import 'package:web3dart/src/utils/typed_data.dart' as td;

class Web3j {
  static final Web3j _instance = Web3j._internal();

  factory Web3j() => _instance;

  Web3j._internal();

  Future<Map<String, Object>> createMessage({
    required String rpcUrl,
    required BigInt chainId,
    required String from,
    required String to,
    required EtherAmount value,
  }) async {
    final client = Web3Client(rpcUrl, Client());

    // 1. getBlockInfo
    final blockInfo = await client.getBlockInformation();

    // 2. setMakeFeePerGas 현재 싯가 가스비에 최대 두배 + maxPriorityFeePerGas(팁) 까지 가능
    final maxPriorityFeePerGas = EtherAmount.fromInt(EtherUnit.wei, 1500000000);
    final maxFeePerGas = (blockInfo.baseFeePerGas!.getInWei * BigInt.two) +
        maxPriorityFeePerGas.getInWei;

    // 3. createTx
    // value: EtherAmount.fromInt(EtherUnit.gwei, 100000), //보내는 값
    Transaction tx = Transaction(
      from: EthereumAddress.fromHex(from),
      to: EthereumAddress.fromHex(to),
      value: value,
      maxPriorityFeePerGas: maxPriorityFeePerGas, // tip
      maxFeePerGas: EtherAmount.fromBigInt(EtherUnit.wei, maxFeePerGas),
      data: Uint8List(0),
    );

    // 4. getNonce
    final nonce = await getNonce(client, tx);

    // 5. getMaxGas
    final maxGas = await getMaxGas(client, tx);

    // 6. newTx
    final newTx = tx.copyWith(nonce: nonce, maxGas: maxGas);

    // 6. makeMessage
    final message = makeMessage(newTx, chainId);

    // 7. convert sha3
    keccak256(hexToBytes(message));

    return {'tx': newTx, 'message': message};
  }

  Future<String> sendTx({
    required String rpcUrl,
    required BigInt chainId,
    required Transaction tx,
    required String r,
    required String s,
    required String v,
  }) async {
    final client = Web3Client(rpcUrl, Client());

    // 1. MsgSignature
    final msgSignature = MsgSignature(
      BigInt.parse(r, radix: 16),
      BigInt.parse(s, radix: 16),
      int.parse(v),
    );

    // 2. Sign
    final signed = td.uint8ListFromList(
      rlp.encode(
        _encodeEIP1559ToRlp(
          tx,
          msgSignature,
          chainId,
        ),
      ),
    );
    // 3. prependTransactionTypeui
    final prependSigned = prependTransactionType(0x02, signed);

    // 4. sendRawTx
    final result = await client.sendRawTransaction(prependSigned);

    return result;
  }

  Future<int> getNonce(Web3Client client, Transaction tx) async =>
      await client.getTransactionCount(tx.to!);

  Future<int> getMaxGas(Web3Client client, Transaction tx) async => await client
      .estimateGas(
        sender: tx.from,
        to: tx.to,
        value: tx.value,
        gasPrice: tx.gasPrice,
      )
      .then((bigInt) => bigInt.toInt());

  String makeMessage(Transaction tx, BigInt chainId) {
    final encodedTx = ltb.LengthTrackingByteSink();
    encodedTx.addByte(0x02);
    encodedTx.add(
      rlp.encode(_encodeEIP1559ToRlp(
        tx,
        null,
        chainId,
      )),
    );
    return bytesToHex(encodedTx.asBytes());
  }

  List<dynamic> _encodeEIP1559ToRlp(
    Transaction transaction,
    MsgSignature? signature,
    BigInt chainId,
  ) {
    final list = [
      chainId,
      transaction.nonce,
      transaction.maxPriorityFeePerGas!.getInWei,
      transaction.maxFeePerGas!.getInWei,
      transaction.maxGas,
    ];

    if (transaction.to != null) {
      list.add(transaction.to!.addressBytes);
    } else {
      list.add('');
    }

    list
      ..add(transaction.value?.getInWei)
      ..add(transaction.data);

    list.add([]); // access list

    if (signature != null) {
      list
        ..add(signature.v)
        ..add(signature.r)
        ..add(signature.s);
    }
    return list;
  }
}

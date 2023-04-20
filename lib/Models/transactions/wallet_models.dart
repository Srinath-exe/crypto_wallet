var walletStatus = {
  "code": 200, // 200 for success; others are error codes
  "msg": "", // error message
  "snapshotVos": [
    {
      "data": {
        "balances": [
          {"asset": "BTC", "free": "0.09905021", "locked": "0.00000000"},
          {"asset": "USDT", "free": "1.89109409", "locked": "0.00000000"}
        ],
        "totalAssetOfBtc": "0.09942700"
      },
      "type": "spot",
      "updateTime": 1576281599000
    }
  ]
};

var fullWalletDetails = {
  "coin": "BTC",
  "depositAllEnable": true,
  "free": "0.08074558",
  "freeze": "0.00000000",
  "ipoable": "0.00000000",
  "ipoing": "0.00000000",
  "isLegalMoney": false,
  "locked": "0.00000000",
  "name": "Bitcoin",
  "networkList": [
    {
      "addressRegex": "^(bnb1)[0-9a-z]{38}\$",
      "coin": "BTC",
      "depositDesc":
          "Wallet Maintenance, Deposit Suspended", // shown only when "depositEnable" is false.
      "depositEnable": false,
      "isDefault": false,
      "memoRegex": "^[0-9A-Za-z\\-_]{1,120}\$",
      "minConfirm": 1, // min number for balance confirmation
      "name": "BEP2",
      "network": "BNB",
      "resetAddressStatus": false,
      "specialTips":
          "Both a MEMO and an Address are required to successfully deposit your BEP2-BTCB tokens to Binance.",
      "unLockConfirm": 0, // confirmation number for balance unlock
      "withdrawDesc":
          "Wallet Maintenance, Withdrawal Suspended", // shown only when "withdrawEnable" is false.
      "withdrawEnable": false,
      "withdrawFee": "0.00000220",
      "withdrawIntegerMultiple": "0.00000001",
      "withdrawMax": "9999999999.99999999",
      "withdrawMin": "0.00000440",
      "sameAddress": true, // If the coin needs to provide memo to withdraw
      "estimatedArrivalTime": 25,
      "busy": false
    },
    {
      "addressRegex":
          "^[13][a-km-zA-HJ-NP-Z1-9]{25,34}\$|^(bc1)[0-9A-Za-z]{39,59}\$",
      "coin": "BTC",
      "depositEnable": true,
      "isDefault": true,
      "memoRegex": "",
      "minConfirm": 1,
      "name": "BTC",
      "network": "BTC",
      "resetAddressStatus": false,
      "specialTips": "",
      "unLockConfirm": 2,
      "withdrawEnable": true,
      "withdrawFee": "0.00050000",
      "withdrawIntegerMultiple": "0.00000001",
      "withdrawMax": "750",
      "withdrawMin": "0.00100000",
      "sameAddress": false,
      "estimatedArrivalTime": 25,
      "busy": false
    }
  ],
  "storage": "0.00000000",
  "trading": true,
  "withdrawAllEnable": true,
  "withdrawing": "0.00000000"
};

// send

var send = {
  "address": "1HPn8Rx2y6nNSfagQBKy27GB99Vbzg89wv",
  "coin": "BTC",
  "tag": "",
  "url": "https://btc.com/1HPn8Rx2y6nNSfagQBKy27GB99Vbzg89wv"
};

enum PaymentType {
  paid('paid'),
  requested('requested'),
  denied('denied');

  const PaymentType(this.type);
  final String type;
}

Map<String, PaymentType> paymentTypetoString = {
  'paid': PaymentType.paid,
  'requested': PaymentType.requested,
  'denied': PaymentType.denied,
};

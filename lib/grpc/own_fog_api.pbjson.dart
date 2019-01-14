///
//  Generated code. Do not modify.
//  source: own_fog_api.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const EnumStatus$json = const {
  '1': 'EnumStatus',
  '2': const [
    const {'1': 'SUCCESS', '2': 0},
    const {'1': 'CHECK_FAIL', '2': 1},
    const {'1': 'OTHER_FAIL', '2': 2},
  ],
};

const TransFileInfo$json = const {
  '1': 'TransFileInfo',
  '2': const [
    const {'1': 'fileName', '3': 1, '4': 1, '5': 9, '10': 'fileName'},
    const {'1': 'fileLen', '3': 2, '4': 1, '5': 5, '10': 'fileLen'},
    const {'1': 'md5', '3': 3, '4': 1, '5': 9, '10': 'md5'},
  ],
};

const CurrentTransInfo$json = const {
  '1': 'CurrentTransInfo',
  '2': const [
    const {'1': 'page_total', '3': 1, '4': 1, '5': 5, '10': 'pageTotal'},
    const {'1': 'page_idx', '3': 2, '4': 1, '5': 5, '10': 'pageIdx'},
    const {'1': 'tranLen', '3': 3, '4': 1, '5': 5, '10': 'tranLen'},
  ],
};

const DeviceInfo$json = const {
  '1': 'DeviceInfo',
  '2': const [
    const {'1': 'deviceName', '3': 1, '4': 1, '5': 9, '10': 'deviceName'},
  ],
};

const uploadFileRequest$json = const {
  '1': 'uploadFileRequest',
  '2': const [
    const {'1': 'timestamp', '3': 1, '4': 1, '5': 9, '10': 'timestamp'},
    const {'1': 'deviceInfo', '3': 2, '4': 1, '5': 11, '6': '.fileUpload.DeviceInfo', '10': 'deviceInfo'},
    const {'1': 'fileInfo', '3': 3, '4': 1, '5': 11, '6': '.fileUpload.TransFileInfo', '10': 'fileInfo'},
    const {'1': 'transInfo', '3': 4, '4': 1, '5': 11, '6': '.fileUpload.CurrentTransInfo', '10': 'transInfo'},
    const {'1': 'fileContent', '3': 5, '4': 1, '5': 12, '10': 'fileContent'},
  ],
};

const ReceivedFileInfo$json = const {
  '1': 'ReceivedFileInfo',
  '2': const [
    const {'1': 'fileInfo', '3': 1, '4': 1, '5': 11, '6': '.fileUpload.TransFileInfo', '10': 'fileInfo'},
    const {'1': 'receivedLen', '3': 2, '4': 1, '5': 5, '10': 'receivedLen'},
  ],
};

const uploadFileResponse$json = const {
  '1': 'uploadFileResponse',
  '2': const [
    const {'1': 'timestamp', '3': 1, '4': 1, '5': 9, '10': 'timestamp'},
    const {'1': 'receivedFileInfo', '3': 2, '4': 1, '5': 11, '6': '.fileUpload.ReceivedFileInfo', '10': 'receivedFileInfo'},
    const {'1': 'isFinished', '3': 3, '4': 1, '5': 8, '10': 'isFinished'},
    const {'1': 'status', '3': 4, '4': 1, '5': 14, '6': '.fileUpload.EnumStatus', '10': 'status'},
    const {'1': 'statusDesc', '3': 5, '4': 1, '5': 9, '10': 'statusDesc'},
  ],
};


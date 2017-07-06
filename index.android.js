import React from 'react-native';

const ReactNativeFoxitPdf = React.NativeModules.ReactNativeFoxitPdf;

export default {
  init: (sn, key, onSuccess, onFailure) => {
    return ReactNativeFoxitPdf.init(sn, key, onSuccess, onFailure)
  },

  openPdf: (uri, onSuccess, onFailure) => {
    return ReactNativeFoxitPdf.openPdf(uri, onSuccess, onFailure);
  }
};

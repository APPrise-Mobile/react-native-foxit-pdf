import React from 'react-native';

const ReactNativeFoxitPdf = React.NativeModules.ReactNativeFoxitPdf;

export default {
  init: (sn, key, onSuccess, onFailure) => {
    return ReactNativeFoxitPdf.init(sn, key, onSuccess, onFailure)
  },

  openPdf: (uri, options, onSuccess, onFailure) => {
    return ReactNativeFoxitPdf.openPdf(uri, !options.isReadOnly, onSuccess, onFailure);
  }
};

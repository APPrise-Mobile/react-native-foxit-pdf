import React from 'react-native';

const ReactNativeFoxitPdf = React.NativeModules.ReactNativeFoxitPdf;

export default {
  init: (sn, key, onSuccess, onFailure) => {
    return ReactNativeFoxitPdf.init(sn, key, () => {})
  },

  openPdf: (uri, options) => {
    return ReactNativeFoxitPdf.openPdf(uri, options, () => {});
  }
};

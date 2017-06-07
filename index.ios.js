import React from 'react-native';

const ReactNativeFoxitPdf = React.NativeModules.ReactNativeFoxitPdf;

export default {
  openPdf: (uri, title, options) => {
    return ReactNativeFoxitPdf.openPdf(uri, title, options, () => {});
  }
};

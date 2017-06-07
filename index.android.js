import React from 'react-native';

const ReactNativeFoxitPdf = React.NativeModules.ReactNativeFoxitPdf;

export default {
  openPdf: (onSuccess, onFailure) => {
    return ReactNativeFoxitPdf.openPdf(onSuccess, onFailure);
  },
};

import { Platform, NativeModules } from 'react-native'

const ReactNativeFoxitPdf = React.NativeModules.ReactNativeFoxitPdf;

export default {
  init: (sn, key, onSuccess, onFailure) => {
    const os = Platform.OS.toLowerCase()
    if (os === 'ios') {
      return ReactNativeFoxitPdf.init(sn, key, () => {})
    } else if (os === 'android') {
      return ReactNativeFoxitPdf.init(sn, key, onSuccess, onFailure)
    } else {
      throw new Error('unsupported os: ' + os)
    }
  },

  openPdf: (uri, options) => {
    const os = Platform.OS.toLowerCase()
    if (os === 'ios') {
      return ReactNativeFoxitPdf.openPdf(uri, options, () => {});
    } else if (os === 'android') {
      return ReactNativeFoxitPdf.openPdf(uri, !options.isReadOnly, onSuccess, onFailure);
    } else {
      throw new Error('unsupported os: ' + os)
    }
  }
};

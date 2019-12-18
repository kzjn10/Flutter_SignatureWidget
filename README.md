## Signature Widget library

Signature widget library

[![pub package](https://img.shields.io/pub/v/flutter_signature_view)](https://pub.dev/packages/flutter_signature_view)

![Preview](https://github.com/kzjn10/Flutter_SignatureWidget/blob/master/graphic/Simulator%20Screen%20Shot%20-%20iPhone%2011%20Pro%20Max%20-%202019-11-20%20at%2014.36.07.png?raw=true)

**Installing**

You should add the following to your `pubspec.yaml` file:


    dependencies:
       flutter_signature_view: ^1.1.1

Note: If you're using the Flutter `master` channel, if you encounter build issues, or want to try the latest and greatest then you should use the `master` branch and not a specific release version. To do so, use the following configuration in your `pubspec.yaml`:

    dependencies:
      flutter_signature_view:
        git:
          url: git://github.com:kzjn10/Flutter_SignatureWidget.git
      
After adding the dependency to your `pubspec.yaml` you can run: flutter packages get or update your packages using your IDE.

**Usage**

  Simple init `SignatureView`
  

      SignatureView _signatureView = SignatureView();

Init with optional params

       SignatureView _signatureView = SignatureView(  
          backgroundColor: Colors.yellow,  
          penStyle: Paint()  
            ..color = Colors.blue  
          ..strokeCap = StrokeCap.round  
          ..strokeWidth = 5.0,  
          onSigned: (data) {  
            print("On change $data");  
          },  
        );

**Params**
 - `backgroundColor` - Color. Canvas background color
 - `data` - String. Init your signature view with default data (it will generate after your signed from callback function `onSigned`
 - `penStyle` - Paint. Custom your Paint style
 - `onSigned` - Function(String). Response list offset as String value. You can use it for `data` to render default signature view

 **Access data**

 - Get list offset as string value `_signatureView.exportListOffsetToString()`
 - Get data as `Bytes` `_signatureView.exportBytes()` -> `async` function
 - Get base64 String ` _signatureView.exportBase64Image()` -> `async` function
 - Check empty `_signatureView.isEmpty`
 - Clear current signature `_signatureView.clear()`

**References**

- [Signature](https://pub.dev/packages/signature#)  
- [Signature View And Custom Painter Implementation](https://www.youtube.com/watch?v=zu-do2luSAo)



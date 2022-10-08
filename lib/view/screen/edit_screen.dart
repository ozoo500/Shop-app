import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/product.dart';
import 'package:shop/view/widgets/app_drawer.dart';

import '../../provider/products.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);
  static const routeName = '/EditScreen';

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _editProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  var _initialValue = {
    'title': '',
    'description': '',
    'price': 0,
    'imageUrl': ''
  };
  final _Init = true;
  var _isLoading = false;
  @override
  initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_Init) {
      var productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initialValue = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price,
          'imageUrl': ''
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product '),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _initialValue['title'] as String,
                  decoration: const InputDecoration(
                    label:  Text('Title'),
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_){
                    Focus.of(context).requestFocus(_priceFocusNode);
                  },
                ),
              ],
            )),
          ),
    );
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http')) &&
              (!_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png')) ||
          (!_imageUrlController.text.endsWith('.jpg')) ||
          (!_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id!, _editProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("An Error Occurred"),
            content: const Text("SomeThing went Wrong "),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Okey'))
            ],
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
    Navigator.of(context).pop();
  }
}

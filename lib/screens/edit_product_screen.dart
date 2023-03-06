import 'package:e_shop/provider/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const id = 'edit_prod_screen';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURlFocusNode = FocusNode();
  // final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: '',
      title: '',
      description: '',
      price: 0.0,
      imageUrl: '',
      isFavorite: false

  );
  bool _isInit = true;
  var _initialValue = {
      'id': '',
        'title': '',
        'price': '',
        'description': '',
        'imageUrl': '',
          };

  @override
  void initState() {
    _imageURlFocusNode.addListener(addFocusNodeListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit) {
      final prodID = ModalRoute.of(context)!.settings.arguments as String;
      if (prodID.isNotEmpty) {
        final product = Provider.of<Products>(context, listen: false).findById(
            prodID);
        _initialValue = {
          'id': product.id,
          'title': product.title,
          'price': product.price.toString(),
          'description': product.description,
          'ímageUrl': product.imageUrl,
        };
        _imageUrlController.text = product.imageUrl;
      }
      super.didChangeDependencies();
    }
    _isInit = false;
  }

  void addFocusNodeListener() {
    if(_imageUrlController.text.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageURlFocusNode.dispose();
    super.dispose();
  }

  
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {

    final prodProv = Provider.of<Products>(context, listen: false);

    final prodID = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
        actions: [
          IconButton(
            //save item to shop
                icon: const Icon(
                Icons.save
                ),
              onPressed: () async {
                bool valid = _form.currentState!.validate();
                if (valid== false) {
                  return;
                } else {
                  _form.currentState?.save();
                }
                setState((){
                  _isLoading = true;
                });
                //update item to shop
                try{
                  if (prodID.isNotEmpty) {
                    await prodProv.updateProduct(_editedProduct.id, _editedProduct);
                    setState((){
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                    return;
                  }
                } catch(e){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: const Text('An error occurred'),
                      content: const Text('Something went wrong'),
                      actions: [
                        TextButton(onPressed: (){
                          setState((){
                            _isLoading = false;
                          });
                          Navigator.of(context).pop();
                        },
                            child: const Text('Okay')),
                      ],
                    );
                  });
                }
                //add item to shop
                try{
                 await prodProv.addProduct(_editedProduct);
                 Navigator.of(context).pop();
                }
                catch (e){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: const Text('An error occurred'),
                      content: const Text('Something went wrong'),
                      actions: [
                        TextButton(onPressed: (){
                          setState((){
                            _isLoading = false;
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('Okay')),
                    ],
                    );
                  });
                }
                setState((){
                  _isLoading = false;
                });
                },
    ),

        ],
      ),
      body: Form(
        key: _form,
        child: _isLoading ? const
        Center(
          child: CircularProgressIndicator(),
        )
            :Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initialValue['title'],
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      title: value!,
                      id: '',
                    isFavorite: _editedProduct.isFavorite
                  );
                },
                validator: (value){
                  if (value!.isEmpty ){
                   return  'enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initialValue['price'],
                decoration: const InputDecoration(
                  label: Text('Price'),
                ),
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      description: _editedProduct.description,
                      price: double.parse(value!),
                      imageUrl: _editedProduct.imageUrl,
                      title: _editedProduct.title,
                      id: prodID,
                      isFavorite: _editedProduct.isFavorite
                  );
                },
                validator: (value){
                  if (value!.isEmpty) {
                    return 'enter a value';
                  }
                  if (double.tryParse(value) == null) {
                    return 'enter a valid number';
                  }
                  if (double.parse(value) < 1){
                    return 'enter a number greater than zero';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initialValue['description'],
                decoration: const InputDecoration(
                  label: Text('Description'),
                ),
                maxLines: 3,
                autocorrect: true,
                textInputAction: TextInputAction.newline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                      description: value!,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      title: _editedProduct.title,
                      id: prodID,

                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'enter a description.';
                  }
                  if (value.length < 5) {
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
                },
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                // textBaseline:TextBaseline.ideographic,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty ?
                    const Text(
                      'Image URl',
                      )
                  :
                  FittedBox(
                    child: Image.network(
                        _imageUrlController.text,
                      fit: BoxFit.cover,
                    ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      // initialValue: _initialValue['imageUrl'],
                      decoration: const InputDecoration(
                        label: Text('Enter an image Url'),
                      ),
                      focusNode: _imageURlFocusNode,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_){
                        FocusScope.of(context).requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                              _editedProduct = Product(
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: value!,
                              title: _editedProduct.title,
                              id: prodID
                          );
                        },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

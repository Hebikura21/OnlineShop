import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:online_shop/navbar.dart';
import 'bloc/product_models.dart';

class UpdateProductPage extends StatefulWidget {
  final Product product;

  const UpdateProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _categoryId = TextEditingController();
  String _status = '';

  File? _image;

  @override
  void initState() {
    super.initState();
    _categoryId.text = widget.product.category!.id.toString();
    _nameController.text = widget.product.name!;
    _descriptionController.text = widget.product.description!;
    _priceController.text = widget.product.price.toString();
    _skuController.text = widget.product.sku!;
    _status = widget.product.status!;
  }

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProduct() async {
    final String apiUrl =
        'https://api.hiocoding.com/api/product/${widget.product.id}';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final Map<String, dynamic> productData = {
      'name': _nameController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'category_id': _categoryId.text,
      'sku': _skuController.text,
      'status': _status,
    };

     final http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(headers);

    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    final Map<String, String> productDataString =
        productData.map((key, value) => MapEntry(key, value.toString()));
    request.fields.addAll(productDataString);

    final response = await request.send();

    
    print(response.statusCode);
    if (response.statusCode == 200) {
      // Produk berhasil diupdate
      Navigator.pop(context, true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavBar()),
      );
    } else {
      // Terjadi kesalahan saat mengupdate produk
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to update product.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
        title: const Text('Update Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _selectImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _image != null
                      ? Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.product.image!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Name',
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Price',
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _categoryId,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Category ID',
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _skuController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'SKU',
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextFormField(
                  initialValue: _status,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Status',
                    hintText: 'Active or Inactive',
                    contentPadding: EdgeInsets.all(8),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _status = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Description',
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateProduct,
        child: Icon(Icons.save),
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
      ),
    );
  }
}

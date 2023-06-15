import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:online_shop/navbar.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryIdController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  String _status = '';

  File? _image;
  
  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _createProduct() async {
    final String apiUrl = 'https://api.hiocoding.com/api/product';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> productData = {
      'name': _nameController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'category_id': _categoryIdController.text,
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

    final http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      // Produk berhasil dibuat
      Navigator.pop(context, true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NavBar()), // Ganti dengan halaman daftar produk yang sesuai
      );
    } else {
      // Terjadi kesalahan saat membuat produk
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to create product.'),
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
        title: const Text('Create Product'),
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
                      : const Icon(Icons.add_a_photo),
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
                  controller: _categoryIdController,
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
        onPressed: _createProduct,
        child: Icon(Icons.save),
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
      ),
    );
  }
}

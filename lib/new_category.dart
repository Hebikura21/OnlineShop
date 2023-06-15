import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/bloc/category_bloc.dart';
import 'package:online_shop/bloc/category_models.dart';

class NewCategoryPage extends StatefulWidget {
  const NewCategoryPage({Key? key}) : super(key: key);

  @override
  _NewCategoryPageState createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  late CategoryBloc _categoryBloc;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  String _selectedStatus = 'active'; // Set a default value here

  @override
  void initState() {
    super.initState();
    _categoryBloc = BlocProvider.of<CategoryBloc>(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 47, 163),
        title: const Text('New Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Status',
                ),
                value: _selectedStatus,
                items: <String>[
                  'active',
                  'inactive',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newCategory = Category(
                          id: 0,
                          name: _nameController.text,
                          status: _selectedStatus,
                          createAt: '',
                          updateAt: '',
                        );
                        _categoryBloc.add(CreateCategory(newCategory));
                        Navigator.pop(context);
                        _categoryBloc
                            .add(FetchCategories()); // Update category list
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 1, 47,
                          163), // Ubah warna latar belakang menjadi biru tua
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/bloc/category_bloc.dart';
import 'package:online_shop/bloc/category_models.dart';

class UpdateCategoryPage extends StatefulWidget {
  final Category category;

  const UpdateCategoryPage({Key? key, required this.category})
      : super(key: key);

  @override
  _UpdateCategoryPageState createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage> {
  late CategoryBloc _categoryBloc;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _categoryBloc = BlocProvider.of<CategoryBloc>(context);
    _nameController.text = widget.category.name;
    _selectedStatus = widget.category.status;
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
        title: const Text('Update Category'),
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
              const SizedBox(height: 16),
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedCategory = Category(
                          id: widget.category.id,
                          name: _nameController.text,
                          status: _selectedStatus,
                          createAt: widget.category.createAt,
                          updateAt: '',
                        );
                        _categoryBloc.add(UpdateCategoryEvent(updatedCategory));
                        Navigator.pop(context);
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

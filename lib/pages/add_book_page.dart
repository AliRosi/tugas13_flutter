import 'package:flutter/material.dart';
import 'package:tugas13_flutter/database/database_helper.dart';
import 'package:tugas13_flutter/model/buku_model.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _saveBook() async {
    if (_formKey.currentState!.validate()) {
      final book = BookModel(
        title: _titleController.text,
        author: _authorController.text,
        description: _descriptionController.text,
      );

      await DatabaseHelper.instance.insertBook(book);

      if (mounted) {
        final snackBar = SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.teal.shade900),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Buku berhasil ditambahkan',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.teal.shade50,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            // ignore: deprecated_member_use
            side: BorderSide(color: Colors.teal.withOpacity(0.5)),
          ),
          margin: EdgeInsets.all(12),
          elevation: 1.0,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tambah Buku Baru',
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Card(
              elevation: 1.5,
              // ignore: deprecated_member_use
              shadowColor: Colors.teal.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Detail Buku',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),

                    TextFormField(
                      controller: _titleController,
                      decoration: _buildInputDecoration(
                        labelText: 'Judul Buku',
                        icon: Icons.title_rounded,
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Judul tidak boleh kosong'
                                  : null,
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _authorController,
                      decoration: _buildInputDecoration(
                        labelText: 'Nama Penulis',
                        icon: Icons.person_outline_rounded,
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Penulis tidak boleh kosong'
                                  : null,
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: _buildInputDecoration(
                        labelText: 'Deskripsi (Opsional)',
                        icon: Icons.description_outlined,
                      ),
                    ),
                    SizedBox(height: 32),

                    ElevatedButton.icon(
                      onPressed: _saveBook,
                      icon: Icon(Icons.save_alt_rounded),
                      label: Text('Simpan Buku'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 52),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: Colors.grey.shade600),
      labelStyle: TextStyle(color: Colors.grey.shade600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.teal, width: 2.0),
      ),
    );
  }
}

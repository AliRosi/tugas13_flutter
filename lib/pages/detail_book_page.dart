import 'package:flutter/material.dart';
import 'package:tugas13_flutter/database/database_helper.dart';
import 'package:tugas13_flutter/model/buku_model.dart';
import 'package:tugas13_flutter/pages/edit_buku_page.dart';

class DetailBookPage extends StatefulWidget {
  final BookModel book;
  final VoidCallback? onBookUpdated;
  final VoidCallback? onBookDeleted;

  const DetailBookPage({
    super.key,
    required this.book,
    this.onBookUpdated,
    this.onBookDeleted,
  });

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  late BookModel _currentBook;

  @override
  void initState() {
    super.initState();
    _currentBook = widget.book;
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Hapus Buku'),
            content: Text(
              'Apakah Anda yakin ingin menghapus buku ini secara permanen?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Batal', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () async {
                  await DatabaseHelper.instance.deleteBook(_currentBook.id!);
                  if (mounted) {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  }
                  widget.onBookDeleted?.call();

                  final snackBar = SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.delete_sweep_outlined,
                          color: Colors.red.shade900,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Buku berhasil dihapus',
                            style: TextStyle(
                              color: Colors.red.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.red.shade100,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      // ignore: deprecated_member_use
                      side: BorderSide(color: Colors.red.withOpacity(0.5)),
                    ),
                    margin: EdgeInsets.all(12),
                    elevation: 1.0,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _navigateToEditPage(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditBookPage(book: _currentBook)),
    );
    if (result == true && mounted) {
      final updatedBook = await DatabaseHelper.instance.getBookById(
        _currentBook.id!,
      );
      setState(() {
        _currentBook = updatedBook!;
      });
      widget.onBookUpdated?.call();
    }
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 22),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Detail Buku',
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        foregroundColor: Colors.teal,
        elevation: 0.5,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () => _navigateToEditPage(context),
            tooltip: 'Edit Buku',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded),
            onPressed: () => _showDeleteConfirmation(context),
            tooltip: 'Hapus Buku',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Card(
          elevation: 1.5,
          // ignore: deprecated_member_use
          shadowColor: Colors.teal.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.teal.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: Colors.teal,
                      size: 48,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Center(
                  child: Text(
                    'ID Buku: #${_currentBook.id}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                Divider(height: 32, thickness: 0.8),

                _buildDetailItem(
                  icon: Icons.title_rounded,
                  title: 'Judul Buku',
                  value: _currentBook.title,
                ),
                _buildDetailItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Penulis',
                  value: _currentBook.author,
                ),
                if (_currentBook.description.isNotEmpty) ...[
                  Divider(height: 24, thickness: 0.5, indent: 40),
                  _buildDetailItem(
                    icon: Icons.description_outlined,
                    title: 'Deskripsi',
                    value: _currentBook.description,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

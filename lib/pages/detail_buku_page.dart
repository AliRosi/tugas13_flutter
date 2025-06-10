import 'package:flutter/material.dart';
import 'package:tugas13_flutter/database/database_helper.dart';
import 'package:tugas13_flutter/model/buku_model.dart';
import 'package:tugas13_flutter/pages/edit_buku_page.dart';

class DetailBukuScreen extends StatelessWidget {
  final BookModel book;
  final VoidCallback? onBookUpdated;
  final VoidCallback? onBookDeleted;

  const DetailBukuScreen({
    super.key,
    required this.book,
    this.onBookUpdated,
    this.onBookDeleted,
  });

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Hapus Buku'),
            content: const Text('Apakah Anda yakin ingin menghapus buku ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  await DatabaseHelper.instance.deleteBook(book.id!);
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                  if (onBookDeleted != null) onBookDeleted!();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('📚 Buku berhasil dihapus')),
                  );
                },
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _navigateToEditPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditBookPage(book: book)),
    ).then((_) {
      if (onBookUpdated != null) onBookUpdated!();
      // SnackBar Dihilangkan sesuai permintaan
    });
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: const TextStyle(fontSize: 16),
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
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('Detail Buku'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditPage(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: Colors.teal,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'ID Buku: ${book.id}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal,
                    ),
                  ),
                ),
                const Divider(height: 30, thickness: 0.8),
                _buildDetailItem(
                  icon: Icons.book,
                  title: 'Judul Buku',
                  value: book.title,
                ),
                _buildDetailItem(
                  icon: Icons.person,
                  title: 'Penulis',
                  value: book.author,
                ),
                _buildDetailItem(
                  icon: Icons.description,
                  title: 'Deskripsi',
                  value: book.description,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

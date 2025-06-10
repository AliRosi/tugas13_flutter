import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas13_flutter/database/database_helper.dart';
import 'package:tugas13_flutter/model/buku_model.dart';
import 'package:tugas13_flutter/pages/detail_buku_page.dart';
import 'package:tugas13_flutter/pages/tambah_buku_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BookModel> bookList = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final data = await DatabaseHelper.instance.getBooks();
    setState(() {
      bookList = data;
    });
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Apakah Anda yakin ingin logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('isLoggedIn');
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _onNavTapped(int index) {
    if (index == 2) {
      _showLogoutConfirmation();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildBookList() {
    return Container(
      color: const Color(0xFFF6F6F6),
      child:
          bookList.isEmpty
              ? const Center(child: Text("Belum ada buku"))
              : ListView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: bookList.length,
                itemBuilder: (context, index) {
                  final book = bookList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      leading: const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.teal,
                      ),
                      title: Text(book.title),
                      subtitle: Text(book.author),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DetailBukuScreen(
                                  book: book,
                                  onBookUpdated: _loadBooks,
                                  onBookDeleted: _loadBooks,
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [_buildBookList(), const InfoWidget()];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? 'Daftar Buku'
              : _selectedIndex == 1
              ? 'Tentang Aplikasi'
              : '',
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
      ),
      body: pages[_selectedIndex],
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton(
                backgroundColor: Colors.teal,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddBookPage()),
                  ).then((_) => _loadBooks());
                },
                child: const Icon(Icons.add),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Buku'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F6F6),
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📖 Manajemen Buku Pribadi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Aplikasi ini digunakan untuk mencatat dan mengelola daftar buku yang telah dibaca atau dimiliki pengguna. '
                'Fitur-fitur yang tersedia meliputi tambah buku, edit, hapus, dan lihat detail buku.',
              ),
              SizedBox(height: 16),
              Text('Versi: 1.0.0'),
              SizedBox(height: 8),
              Text('Dibuat oleh: Ali Rosi'),
            ],
          ),
        ),
      ),
    );
  }
}

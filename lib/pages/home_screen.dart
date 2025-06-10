import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas13_flutter/database/database_helper.dart';
import 'package:tugas13_flutter/model/buku_model.dart';
import 'package:tugas13_flutter/pages/detail_book_page.dart';
import 'package:tugas13_flutter/pages/add_book_page.dart';

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
    if (mounted) {
      setState(() {
        bookList = data;
      });
    }
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Logout'),
            content: Text('Apakah Anda yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Batal', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('isLoggedIn');
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBookList() {
    if (bookList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              "Koleksi Buku Kosong",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Ketuk 'Tambahkan Buku' untuk memulai.",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 80),
      itemCount: bookList.length,
      itemBuilder: (context, index) {
        final book = bookList[index];
        return Card(
          elevation: 1.5,
          // ignore: deprecated_member_use
          shadowColor: Colors.teal.withOpacity(0.1),
          margin: EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.menu_book_rounded, color: Colors.teal, size: 30),
                SizedBox(width: 12),
                CircleAvatar(
                  radius: 15,
                  // ignore: deprecated_member_use
                  backgroundColor: Colors.teal.withOpacity(0.1),
                  child: Text(
                    book.id.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.teal.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              book.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              book.author,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => DetailBookPage(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [_buildBookList(), const InfoWidget()];

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _selectedIndex == 0 ? 'Daftar Buku' : 'Tentang Aplikasi',
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.teal),
            onPressed: _showLogoutConfirmation,
            tooltip: 'Logout',
          ),
        ],
      ),

      body: IndexedStack(index: _selectedIndex, children: pages),
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton.extended(
                backgroundColor: Colors.teal,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddBookPage()),
                  ).then((_) => _loadBooks());
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Tambahkan Buku',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey.shade500,
        backgroundColor: Colors.white,
        elevation: 1.0,

        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Buku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: 'Info',
          ),
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
      color: Color(0xFFF9F9F9),
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📖  Bookshelf',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Aplikasi ini digunakan untuk mencatat dan mengelola daftar buku yang telah dibaca atau dimiliki pengguna. '
            'Fitur-fitur yang tersedia meliputi tambah buku, edit, hapus, dan lihat detail buku.',
            textAlign: TextAlign.justify,

            style: TextStyle(
              height: 1.5,
              fontSize: 15,
              color: Colors.grey.shade800,
            ),
          ),
          Spacer(),
          Divider(),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Versi Aplikasi'),
              Text('1.0.0', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dibuat oleh'),
              Text('Ali Rosi', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

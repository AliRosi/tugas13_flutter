import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas13_flutter/database/database_helper.dart';
import 'package:tugas13_flutter/model/buku_model.dart';
import 'package:tugas13_flutter/pages/add_book_page.dart';
import 'package:tugas13_flutter/pages/detail_book_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BookModel> _unreadBooks = [];
  List<BookModel> _readBooks = [];

  int _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final allBooks = await DatabaseHelper.instance.getBooks();
    if (mounted) {
      setState(() {
        _unreadBooks = allBooks.where((book) => !book.isRead).toList();
        _readBooks = allBooks.where((book) => book.isRead).toList();
      });
    }
  }

  Future<void> _toggleReadStatus(BookModel book, bool? newValue) async {
    final updatedBook = BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      description: book.description,
      isRead: newValue ?? false,
    );

    await DatabaseHelper.instance.updateBook(updatedBook);

    _loadBooks();
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
      _bottomNavIndex = index;
    });
  }

  Widget _buildBookPage() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            '📚 Koleksi Buku',
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: Colors.teal),
              onPressed: _showLogoutConfirmation,
              tooltip: 'Logout',
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.teal,
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.grey,
            tabs: [Tab(text: 'Belum Dibaca'), Tab(text: 'Sudah Dibaca')],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookCategoryList(_unreadBooks, 'Belum ada buku di rak ini.'),
            _buildBookCategoryList(
              _readBooks,
              'Anda belum membaca buku apapun.',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.teal,
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddBookPage()),
              ).then((_) => _loadBooks()),
          icon: Icon(Icons.add, color: Colors.white),
          label: Text(
            'Tambahkan Buku',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildBookCategoryList(List<BookModel> books, String emptyMessage) {
    if (books.isEmpty) {
      return Center(
        child: Text(emptyMessage, style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 96),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          elevation: 1.5,
          // ignore: deprecated_member_use
          shadowColor: Colors.teal.withOpacity(0.1),
          margin: EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 8),
            leading: CircleAvatar(
              // ignore: deprecated_member_use
              backgroundColor: Colors.teal.withOpacity(0.1),
              child: Text(
                book.id.toString(),
                style: TextStyle(
                  color: Colors.teal.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
            trailing: Checkbox(
              value: book.isRead,
              onChanged: (bool? newValue) {
                _toggleReadStatus(book, newValue);
              },
              activeColor: Colors.teal,
            ),
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
    final List<Widget> pages = [_buildBookPage(), const InfoWidget()];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      body: IndexedStack(index: _bottomNavIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: _onNavTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: 'Koleksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
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
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32),
          Text(
            '📘 Tentang Aplikasi',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Aplikasi ini dibuat untuk membantu mencatat dan mengelola daftar buku bacaan pengguna.\n\n'
            'Anda dapat menambahkan buku, menandai sudah dibaca, dan melihat detail buku dengan mudah.',
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

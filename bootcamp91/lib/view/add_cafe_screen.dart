import 'package:bootcamp91/product/project_colors.dart';
import 'package:bootcamp91/services/auth_service.dart'; // Auth servisi
import 'package:bootcamp91/services/cafe_service.dart'; // Kafe servisi
import 'package:flutter/material.dart';
import 'package:bootcamp91/view/my_cafe_screen.dart'; // MyCafeScreen'i import ettik

class AddCafeScreen extends StatefulWidget {
  @override
  _AddCafeScreenState createState() => _AddCafeScreenState();
}

class _AddCafeScreenState extends State<AddCafeScreen> {
  final _nameController = TextEditingController();
  final _logoUrlController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  final CafeService _cafeService = CafeService();

  bool _isLoading = false;
  bool _obscureText = true; // Parola görünürlük kontrolü

  Future<void> _createCafe() async {
    final name = _nameController.text;
    final logoUrl = _logoUrlController.text;
    final password = _passwordController.text;

    if (name.isEmpty || logoUrl.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Mevcut kullanıcıyı al
      final user = _authService.currentUserUid;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kullanıcı bulunamadı.')),
        );
        return;
      }

      // Kullanıcının parolasını doğrula
      bool isPasswordCorrect = await _authService.verifyPassword(password);

      if (!isPasswordCorrect) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Parola yanlış.')),
        );
        return;
      }

      // Kullanıcının zaten bir kafesi olup olmadığını kontrol et
      final existingCafes = await _cafeService.getUserCafes(user);

      if (existingCafes.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Zaten bir kafe oluşturmuşsunuz.')),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyCafeScreen(),
        ));
      } else {
        // Yeni kafe oluştur
        await _cafeService.addCafe(name, logoUrl, user);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kafe başarıyla eklendi!')),
        );
        Navigator.pop(context); // Sayfayı kapat
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni Kafe Ekle'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst kısımda resim
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image.asset(
                    'assets/images/ic_create_cafe.png',
                    width: 300,
                    height: 200,
                  ),
                ),
              ),
              SizedBox(height: 50),
              // Kafe adı textfield
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Kafe Adı',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              // Kafe logosu URL textfield
              TextField(
                controller: _logoUrlController,
                decoration: InputDecoration(
                  labelText: 'Kafe Logosu URL',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 20),
              // Parola textfield
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Parola',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: _obscureText
                          ? ProjectColors.default_color
                          : ProjectColors.project_yellow,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
              ),
              SizedBox(height: 20),
              // Buton
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _createCafe,
                      child: Text('Kafe Ekle'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

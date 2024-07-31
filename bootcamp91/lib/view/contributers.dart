import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Contributers extends StatefulWidget {
  const Contributers({super.key});

  @override
  State<Contributers> createState() => _ContributersState();
}

class _ContributersState extends State<Contributers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yapımcılar',
          style: GoogleFonts.kleeOne(),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _buildFAQTile(
            question: 'Özcan Bayram (Developer)',
            answer:
                'Projeye ait tüm kodların yazılması.(GitHub\'da Projedeki commitler) \n\nVeri tabanının Firebase üzerinde kurulması, kullanıcı ve kafe işlemleri için gerekli yapıların kurulması. \n\nUI & UX tasarımları ve görsel oluşturmaları.\n\nTakım yönetimi ve görevlendirme. \n\nProjenin Github üzerindeki README.md dosyasının görsel olarak düzenlenmesi.\n\nProjenin tanıtım veidosunun hazrılanması.',
          ),
          _buildFAQTile(
            question: 'Özgür Boruzancı (Product Owner)',
            answer:
                'Proje fikir sahibi, GitHub reposu oluşturma. \n\nVeri tabanı üzerinde 3 kafenin verilerinin girilmesi.',
          ),
          _buildFAQTile(
            question: 'Sema Erakbıyık (Scrum Master)',
            answer:
                'Github üzerinde README.md dosyasına sprintlerin yazılması ve asistan ile iletişime geçilmesi.\n\nVeri tabnı üzerinde 3 kafenin verilerinin girilmesi.',
          ),
          _buildFAQTile(
            question: 'Sabutay Batuhan Sandalcı (Tasarım)',
            answer:
                'Figma üzerinde uygulamanın ilk taslağının yapılması.\n\nVeri tabnı üzerinde 3 kafenin verilerinin girilmesi.',
          ),
          _buildFAQTile(
            question: 'Yasemin Yılmaz (Destek)',
            answer: 'Ekip üyesi.\n\nVeri tabanı üzerinde 3 kafenin verilerinin girilmesi.',
          ),
        ],
      ),
    );
  }
}

Widget _buildFAQTile({required String question, required String answer}) {
  return ExpansionTile(
    title: Text(
      question,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(answer),
      ),
    ],
  );
}

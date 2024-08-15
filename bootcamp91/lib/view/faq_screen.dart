import 'package:bootcamp91/product/project_texts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sıkça Sorulan Sorular',
          style: GoogleFonts.kleeOne(),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _buildFAQTile(
              question: ProjectTexts().faq1, answer: ProjectTexts().ask1),
          _buildFAQTile(
              question: ProjectTexts().faq2, answer: ProjectTexts().ask2),
          _buildFAQTile(
              question: ProjectTexts().faq3, answer: ProjectTexts().ask3),
          _buildFAQTile(
              question: ProjectTexts().faq4, answer: ProjectTexts().ask4),
          _buildFAQTile(
              question: ProjectTexts().faq5, answer: ProjectTexts().ask5),
          _buildFAQTile(
              question: ProjectTexts().ask6, answer: ProjectTexts().ask6),
          _buildFAQTile(
              question: ProjectTexts().faq7, answer: ProjectTexts().ask7),
          _buildFAQTile(
              question: ProjectTexts().faq8, answer: ProjectTexts().ask8),
          _buildFAQTile(
              question: ProjectTexts().faq9, answer: ProjectTexts().ask9),
          _buildFAQTile(
              question: ProjectTexts().faq10, answer: ProjectTexts().ask10),
          _buildFAQTile(
              question: ProjectTexts().faq11, answer: ProjectTexts().ask11),
        ],
      ),
    );
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
}

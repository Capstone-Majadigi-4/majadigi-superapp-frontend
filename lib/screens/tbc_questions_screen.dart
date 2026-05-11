import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/tbc_question_card.dart';
import '../widgets/tbc_result_dialog.dart';

class TbcQuestionsScreen extends StatefulWidget {
  const TbcQuestionsScreen({super.key});

  @override
  State<TbcQuestionsScreen> createState() => _TbcQuestionsScreenState();
}

class _TbcQuestionsScreenState extends State<TbcQuestionsScreen> {
  final Map<int, bool?> _answers = {};

  final List<String> _keluhanQuestions = [
    'Batuk lebih dari 2 minggu',
    'Demam',
    'Berkeringat malam hari tanpa aktivitas',
    'Sesak nafas',
    'Nyeri dada',
    'Ada benjolan di leher/bawah rahang/bawah telinga/ketiak',
    'Batuk berdarah',
    'Batuk kurang dari 2 minggu',
    'Nafsu makan turun (atau hilang nafsu makan selama berhari-hari)',
    'Mudah lelah (atau sering kecapekan tanpa aktivitas fisik yang berarti)',
  ];

  final List<String> _infoLainnyaQuestions = [
    'Pernah kontak satu rumah dengan pasien TBC',
    'Pernah didiagnosis TBC sebelumnya',
    'Memiliki penyakit penyerta (DM, HIV, dll)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header Background
          Container(
            height: 200,
            width: double.infinity,
            color: const Color(0xFF0065FF),
            child: Stack(
              children: [
                Positioned(
                  left: -50,
                  top: -50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Skrining Mandiri TBC',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(24),
                            children: [
                              _buildCategoryTitle('Keluhan yang dirasakan'),
                              const SizedBox(height: 16),
                              ...List.generate(_keluhanQuestions.length, (index) {
                                return TbcQuestionCard(
                                  question: _keluhanQuestions[index],
                                  value: _answers[index],
                                  onChanged: (val) {
                                    setState(() {
                                      _answers[index] = val;
                                    });
                                  },
                                );
                              }),
                              
                              const SizedBox(height: 24),
                              _buildCategoryTitle('Informasi Lainnya'),
                              const SizedBox(height: 16),
                              ...List.generate(_infoLainnyaQuestions.length, (index) {
                                int questionIndex = _keluhanQuestions.length + index;
                                return TbcQuestionCard(
                                  question: _infoLainnyaQuestions[index],
                                  value: _answers[questionIndex],
                                  onChanged: (val) {
                                    setState(() {
                                      _answers[questionIndex] = val;
                                    });
                                  },
                                );
                              }),
                              const SizedBox(height: 80), // Space for button
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Button
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: CustomButton(
              text: 'Lihat Hasil',
              borderRadius: 12,
              onPressed: () {
                // Check if any question is answered 'Yes'
                bool isAtRisk = _answers.values.any((val) => val == true);
                
                showTbcResultDialog(
                  context,
                  isAtRisk: isAtRisk,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF0A0A0A),
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        height: 1.50,
      ),
    );
  }
}

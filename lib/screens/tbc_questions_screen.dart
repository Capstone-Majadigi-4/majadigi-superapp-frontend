import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/tbc_result_dialog.dart';
import '../providers/etibi_provider.dart';
import '../models/etibi_model.dart';

class TbcQuestionsScreen extends StatefulWidget {
  const TbcQuestionsScreen({super.key});

  @override
  State<TbcQuestionsScreen> createState() => _TbcQuestionsScreenState();
}

class _TbcQuestionsScreenState extends State<TbcQuestionsScreen> {
  final Map<int, bool?> _answers = {};
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EtibiProvider>().fetchQuestions();
    });
  }

  String _formatQuestionText(String text) {
    if (text.endsWith('?')) return text;
    
    final lowerText = text.toLowerCase().trim();
    if (lowerText.startsWith('batuk lebih dari 2 minggu')) {
      return 'Apakah Anda batuk terus-menerus selama lebih dari 2 minggu?';
    } else if (lowerText.startsWith('demam')) {
      return 'Apakah Anda mengalami demam?';
    } else if (lowerText.startsWith('berkeringat malam')) {
      return 'Apakah Anda berkeringat pada malam hari tanpa melakukan aktivitas fisik?';
    } else if (lowerText.startsWith('sesak nafas') || lowerText.startsWith('sesak napas')) {
      return 'Apakah Anda mengalami sesak napas?';
    } else if (lowerText.startsWith('nyeri dada')) {
      return 'Apakah Anda mengalami nyeri dada?';
    } else if (lowerText.startsWith('ada benjolan')) {
      return 'Apakah Anda memiliki benjolan di leher, bawah rahang, bawah telinga, atau ketiak?';
    } else if (lowerText.startsWith('batuk berdarah')) {
      return 'Apakah Anda mengalami batuk berdarah?';
    } else if (lowerText.startsWith('batuk kurang dari 2 minggu')) {
      return 'Apakah Anda mengalami batuk kurang dari 2 minggu?';
    } else if (lowerText.startsWith('nafsu makan turun')) {
      return 'Apakah nafsu makan Anda mengalami penurunan selama berhari-hari?';
    } else if (lowerText.startsWith('mudah lelah')) {
      return 'Apakah Anda mudah lelah tanpa melakukan aktivitas fisik yang berarti?';
    } else if (lowerText.startsWith('pernah kontak')) {
      return 'Apakah Anda pernah melakukan kontak satu rumah dengan pasien TBC?';
    } else if (lowerText.startsWith('pernah didiagnosis')) {
      return 'Apakah Anda pernah didiagnosis menderita TBC sebelumnya?';
    } else if (lowerText.startsWith('memiliki penyakit penyerta')) {
      return 'Apakah Anda memiliki penyakit penyerta seperti DM (Diabetes Melitus) atau HIV?';
    }
    
    return 'Apakah Anda mengalami ${text.toLowerCase()}?';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EtibiProvider>(context);
    final questions = provider.questions;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0078FF), Color(0xFF0046B2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_currentQuestionIndex > 0) {
                          setState(() {
                            _currentQuestionIndex--;
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tes Skrining TBC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Layanan Skrining Mandiri TBC',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (provider.isLoading && questions.isEmpty)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              else if (questions.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'Tidak ada pertanyaan tersedia.',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Inter'),
                    ),
                  ),
                )
              else ...[
                // Progress Info & Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pertanyaan ${_currentQuestionIndex + 1} dari ${questions.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${((_currentQuestionIndex / questions.length) * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _currentQuestionIndex / questions.length,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF00E5FF),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Question Card Container
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Segmented indicator bar inside card
                        Row(
                          children: List.generate(questions.length, (idx) {
                            return Expanded(
                              child: Container(
                                height: 4,
                                margin: EdgeInsets.only(right: idx == questions.length - 1 ? 0 : 6),
                                decoration: BoxDecoration(
                                  color: idx <= _currentQuestionIndex
                                      ? const Color(0xFF00E5FF)
                                      : const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'PERTANYAAN ${_currentQuestionIndex + 1}',
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _formatQuestionText(questions[_currentQuestionIndex].text),
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Answer Cards Side-by-Side
                        Row(
                          children: [
                            Expanded(
                              child: _buildAnswerCard(
                                label: 'Ya',
                                emoji: '😓',
                                isSelected: _answers[questions[_currentQuestionIndex].id] == true,
                                backgroundColor: const Color(0xFFFFECEF),
                                borderCol: const Color(0xFFFCA5A5),
                                textCol: const Color(0xFFDC2626),
                                onTap: () => _handleAnswer(questions, provider, true),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildAnswerCard(
                                label: 'Tidak',
                                emoji: '😊',
                                isSelected: _answers[questions[_currentQuestionIndex].id] == false,
                                backgroundColor: const Color(0xFFE8FDF0),
                                borderCol: const Color(0xFF86EFAC),
                                textCol: const Color(0xFF16A34A),
                                onTap: () => _handleAnswer(questions, provider, false),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerCard({
    required String label,
    required String emoji,
    required bool isSelected,
    required Color backgroundColor,
    required Color borderCol,
    required Color textCol,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderCol,
            width: isSelected ? 2.5 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: borderCol.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: textCol,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAnswer(List<ScreeningQuestion> questions, EtibiProvider provider, bool value) async {
    setState(() {
      _answers[questions[_currentQuestionIndex].id] = value;
    });

    // Short delay for visual feedback of selection
    await Future.delayed(const Duration(milliseconds: 200));

    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Last question completed, submit screening
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );

      final Map<int, bool> answersMap = {};
      for (var q in questions) {
        answersMap[q.id] = _answers[q.id] ?? false;
      }

      try {
        final isAtRisk = await provider.submitScreening(answersMap);
        if (mounted) {
          Navigator.pop(context); // pop loading dialog
          showTbcResultDialog(
            context,
            isAtRisk: isAtRisk,
          );
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); // pop loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Terjadi kesalahan: $e'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }
}


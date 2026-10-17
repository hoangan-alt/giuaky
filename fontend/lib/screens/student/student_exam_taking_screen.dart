import 'dart:async';
import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/exam.dart';
import '../../widgets/common_header.dart';
import '../../widgets/modals.dart';

class StudentExamTakingScreen extends StatefulWidget {
  final VoidCallback onSubmitFinished;
  final VoidCallback onToggleRole;

  const StudentExamTakingScreen({
    super.key,
    required this.onSubmitFinished,
    required this.onToggleRole,
  });

  @override
  State<StudentExamTakingScreen> createState() => _StudentExamTakingScreenState();
}

class _StudentExamTakingScreenState extends State<StudentExamTakingScreen> {
  late List<Question> questions;
  late ReadingPassage passage;
  int currentQuestionIndex = 77; // Question 178 (178 - 101 = 77)

  // Track answers & flagged questions: Map<questionNumber, selectedOptionKey>
  final Map<int, String> userAnswers = {};
  final Set<int> flaggedQuestions = {164, 178, 182, 190};

  // Timer: 14 minutes 32 seconds
  int remainingSeconds = 14 * 60 + 32;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    questions = MockData.getMockQuestions();
    passage = MockData.getMockPassage176to180();

    // Pre-fill 92 answered questions (all except 193 to 200)
    for (int i = 101; i <= 192; i++) {
      if (i == 178) {
        userAnswers[i] = 'A';
      } else {
        userAnswers[i] = ['A', 'B', 'C', 'D'][i % 4];
      }
    }

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get formattedTimer {
    int m = remainingSeconds ~/ 60;
    int s = remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _submitExam() {
    AppModals.showSubmitExamModal(
      context: context,
      answeredCount: userAnswers.length,
      totalCount: 100,
      flaggedCount: flaggedQuestions.length,
      onConfirm: widget.onSubmitFinished,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = questions[currentQuestionIndex];
    final selectedOption = userAnswers[currentQ.number];
    final isFlagged = flaggedQuestions.contains(currentQ.number);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          StudentHeader(
            currentRoute: 'TOEIC Reading Practice 01 · 100 câu · 75 phút',
            onToggleRole: widget.onToggleRole,
          ),

          // Test controls bar
          _buildTestControlsBar(currentQ),

          // Main 3-column workbench
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left: Navigator (240px)
                  SizedBox(
                    width: 250,
                    child: _buildQuestionNavigator(),
                  ),
                  const SizedBox(width: 16),

                  // Middle: Reading scroll pane
                  Expanded(
                    flex: 3,
                    child: _buildReadingPane(currentQ),
                  ),
                  const SizedBox(width: 16),

                  // Right: Current Question pane (380px)
                  SizedBox(
                    width: 390,
                    child: _buildCurrentQuestionPane(currentQ, selectedOption, isFlagged),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestControlsBar(Question currentQ) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('TOEIC Reading Practice 01', style: AppStyles.h3),
              const SizedBox(height: 2),
              Text(
                'Part ${currentQ.part} · Nhóm câu 176–180 · Nhiều tài liệu',
                style: AppStyles.caption,
              ),
            ],
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    'Sắp hết giờ',
                    style: TextStyle(
                      fontFamily: AppStyles.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warning,
                    ),
                  ),
                  Text(
                    'Bài tự nộp khi hết giờ',
                    style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: AppColors.warning, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      formattedTimer,
                      style: const TextStyle(
                        fontFamily: AppStyles.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _submitExam,
                icon: const Icon(Icons.send_rounded, size: 16),
                label: const Text('Nộp bài'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionNavigator() {
    final answered = userAnswers.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Điều hướng câu', style: AppStyles.h4),
              Text(
                '$answered/100',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: answered / 100,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 14),

          // Grid with tabs for Part 5, 6, 7
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavigatorSection('Part 5 (101–130)', 101, 130),
                  const SizedBox(height: 12),
                  _buildNavigatorSection('Part 6 (131–146)', 131, 146),
                  const SizedBox(height: 12),
                  _buildNavigatorSection('Part 7 (147–200)', 147, 200),
                ],
              ),
            ),
          ),

          const Divider(color: AppColors.border),
          const SizedBox(height: 6),
          // Legend
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: const [
              Text('● Đã trả lời', style: TextStyle(fontSize: 10, color: AppColors.primary)),
              Text('○ Chưa trả lời', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
              Text('■ Hiện tại', style: TextStyle(fontSize: 10, color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
              Text('⚑ Xem lại', style: TextStyle(fontSize: 10, color: AppColors.warning)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$answered đã trả lời · ${100 - answered} chưa trả lời\n${flaggedQuestions.length} câu cần xem lại, gồm câu 178',
            style: AppStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigatorSection(String title, int start, int end) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppStyles.overline),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(end - start + 1, (idx) {
            int qNum = start + idx;
            bool isCurrent = (currentQuestionIndex == qNum - 101);
            bool isAns = userAnswers.containsKey(qNum);
            bool isFlg = flaggedQuestions.contains(qNum);

            Color bg;
            Color textCol;
            Border? border;

            if (isCurrent) {
              bg = AppColors.primaryDark;
              textCol = Colors.white;
            } else if (isFlg) {
              bg = AppColors.warningBg;
              textCol = AppColors.warning;
              border = Border.all(color: AppColors.warning.withValues(alpha: 0.5));
            } else if (isAns) {
              bg = AppColors.primaryLight;
              textCol = AppColors.textDark;
            } else {
              bg = AppColors.surfaceMuted;
              textCol = AppColors.textMuted;
            }

            return InkWell(
              onTap: () {
                setState(() => currentQuestionIndex = qNum - 101);
              },
              child: Container(
                width: 32,
                height: 28,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(4),
                  border: border,
                ),
                alignment: Alignment.center,
                child: Text(
                  isFlg && !isCurrent ? '$qNum⚑' : '$qNum',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: textCol,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildReadingPane(Question currentQ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Bài đọc', style: AppStyles.h4),
              Text('Cuộn độc lập ↕', style: AppStyles.caption),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 14),

          // Scrollable Document Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      passage.instruction,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notice Document
                  _buildDocumentCard(passage.documents[0]),
                  const SizedBox(height: 16),

                  // Email Document
                  _buildDocumentCard(passage.documents[1]),
                  const SizedBox(height: 16),

                  // Schedule Document
                  _buildDocumentCard(passage.documents[2]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(ReadingDocument doc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(doc.title, style: AppStyles.h4),
          const SizedBox(height: 10),

          // Metadata block (e.g. email headers)
          if (doc.metadata != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: doc.metadata!.entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            '${e.key}:',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            e.value,
                            style: const TextStyle(fontSize: 11, color: AppColors.textDark),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
          ],

          if (doc.content.isNotEmpty)
            Text(doc.content, style: AppStyles.body),

          // Schedule Rows
          if (doc.scheduleRows != null) ...[
            Table(
              border: TableBorder.all(color: AppColors.border, width: 1),
              children: doc.scheduleRows!.map((r) {
                return TableRow(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.white,
                      child: Text(
                        r['time']!,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.white,
                      child: Text(
                        r['activity']!,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentQuestionPane(Question currentQ, String? selectedOption, bool isFlagged) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question group quick switcher (176 to 180)
          Row(
            children: [176, 177, 178, 179, 180].map((qNum) {
              final isCur = (qNum == currentQ.number);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    onTap: () {
                      setState(() => currentQuestionIndex = qNum - 101);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isCur ? AppColors.primaryDark : AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$qNum',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isCur ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),

          // Header: CÂU 178 / 200 and Flag Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('CÂU ${currentQ.number} / 200', style: AppStyles.overline),
              InkWell(
                onTap: () {
                  setState(() {
                    if (flaggedQuestions.contains(currentQ.number)) {
                      flaggedQuestions.remove(currentQ.number);
                    } else {
                      flaggedQuestions.add(currentQ.number);
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      isFlagged ? Icons.flag : Icons.flag_outlined,
                      size: 16,
                      color: isFlagged ? AppColors.warning : AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isFlagged ? 'Đã đánh dấu' : 'Đánh dấu',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isFlagged ? AppColors.warning : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Question Title
          Text(currentQ.text, style: AppStyles.h3),
          const SizedBox(height: 20),

          // 4 Options (A, B, C, D)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: currentQ.options.map((opt) {
                  final isSelected = (selectedOption == opt.key);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          userAnswers[currentQ.number] = opt.key;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryLight : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryDark : AppColors.surfaceMuted,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                opt.key,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : AppColors.textDark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                opt.text,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Question footer status
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),
          Text(
            selectedOption != null
                ? 'Đã lưu lựa chọn $selectedOption · Không hiển thị đáp án'
                : 'Chưa chọn đáp án',
            style: AppStyles.caption,
          ),
          const SizedBox(height: 12),

          // Pagination buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: currentQuestionIndex > 0
                      ? () {
                          setState(() => currentQuestionIndex--);
                        }
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    '← Câu ${currentQuestionIndex > 0 ? questions[currentQuestionIndex - 1].number : 101}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: currentQuestionIndex < questions.length - 1
                      ? () {
                          setState(() => currentQuestionIndex++);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    'Câu ${currentQuestionIndex < questions.length - 1 ? questions[currentQuestionIndex + 1].number : 200} →',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

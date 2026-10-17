import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/exam_model.dart';
import '../services/api_service.dart';
import '../widgets/modals.dart';
import '../widgets/state_indicators.dart';
import '../widgets/student_header.dart';

class ExamTakingScreen extends StatefulWidget {
  final PublishedExam exam;
  final ValueChanged<String> onFinishExam; // passes attemptId

  const ExamTakingScreen({
    super.key,
    required this.exam,
    required this.onFinishExam,
  });

  @override
  State<ExamTakingScreen> createState() => _ExamTakingScreenState();
}

class _ExamTakingScreenState extends State<ExamTakingScreen> {
  final ApiService apiService = ApiService();

  bool isLoading = true;
  String? loadError;
  ExamContentData? examData;
  String? currentAttemptId;

  int currentQuestionIndex = 77; // default to Q178 (178 - 101)
  final Map<String, String> userAnswers = {}; // questionId -> optionKey ('A', 'B', 'C', 'D')
  final Set<int> flaggedQuestions = {164, 178, 182, 190};

  Timer? countdownTimer;
  int remainingSeconds = 75 * 60;
  bool isSubmitting = false;
  String? networkSyncWarning;

  @override
  void initState() {
    super.initState();
    _startAttemptAndLoadExam();
  }

  Future<void> _startAttemptAndLoadExam() async {
    setState(() {
      isLoading = true;
      loadError = null;
    });

    // 1. Create Attempt
    final attemptRes = await apiService.createAttempt(widget.exam.id);
    if (!attemptRes.isSuccess || attemptRes.data == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
          loadError = attemptRes.errorMessage ?? 'Không thể khởi tạo lượt thi.';
        });
      }
      return;
    }

    final attempt = attemptRes.data!;
    currentAttemptId = attempt.attemptId;

    // 2. Fetch exam content
    final contentRes = await apiService.getExamContent(attempt.attemptId);
    if (!contentRes.isSuccess || contentRes.data == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
          loadError = contentRes.errorMessage ?? 'Không thể tải đề thi.';
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        examData = contentRes.data!;
        remainingSeconds = examData!.remainingSeconds;
        userAnswers.addAll(examData!.initialAnswers);
        isLoading = false;
      });

      _startTimer();
    }
  }

  void _startTimer() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        timer.cancel();
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    // Lock actions and auto submit
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Hết giờ làm bài!'),
        content: const Text(
          'Thời gian làm bài thi 75 phút đã kết thúc. Hệ thống đang tiến hành nộp bài tự động…',
        ),
      ),
    );
    _performSubmit(auto: true);
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  String get formattedTimer {
    int m = remainingSeconds ~/ 60;
    int s = remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get isWarningTime => remainingSeconds <= 15 * 60; // 15 mins or less

  Future<void> _selectOption(QuestionItem question, OptionItem option) async {
    final currentVal = userAnswers[question.id];
    String? newVal;

    if (currentVal == option.key) {
      // Toggle / unselect option as per requirements: "Cho phép chọn, đổi hoặc bỏ chọn đáp án"
      newVal = null;
    } else {
      newVal = option.key;
    }

    setState(() {
      if (newVal == null) {
        userAnswers.remove(question.id);
      } else {
        userAnswers[question.id] = newVal;
      }
    });

    // Save answer to backend
    if (currentAttemptId != null) {
      final saveRes = await apiService.saveAnswer(
        attemptId: currentAttemptId!,
        questionId: question.id,
        selectedOptionId: newVal == null ? null : option.id,
        selectedOptionKey: newVal,
      );

      if (!saveRes.isSuccess && mounted) {
        setState(() {
          networkSyncWarning = 'Mất kết nối tạm thời khi lưu đáp án câu ${question.number}. Dữ liệu đã lưu tạm trên máy.';
        });
      } else if (networkSyncWarning != null && mounted) {
        setState(() => networkSyncWarning = null);
      }
    }
  }

  void _confirmSubmit() {
    final total = examData?.questions.length ?? 100;
    final answered = userAnswers.length;

    AppModals.showSubmitExamModal(
      context: context,
      answeredCount: answered,
      totalCount: total,
      flaggedCount: flaggedQuestions.length,
      onConfirm: () => _performSubmit(auto: false),
    );
  }

  Future<void> _performSubmit({required bool auto}) async {
    if (isSubmitting || currentAttemptId == null) return;
    setState(() => isSubmitting = true);

    final res = await apiService.submitExam(currentAttemptId!);

    if (mounted) {
      setState(() => isSubmitting = false);
      if (res.isSuccess) {
        if (auto) {
          Navigator.of(context, rootNavigator: true).pop(); // dismiss auto dialog
        }
        widget.onFinishExam(currentAttemptId!);
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Lỗi nộp bài thi'),
            content: Text(
              res.errorMessage ??
                  'Kết nối mạng bị gián đoạn. Bài thi chưa được xác nhận nộp thành công. Vui lòng kiểm tra mạng và thử lại.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Đóng'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _performSubmit(auto: auto);
                },
                child: const Text('Thử nộp lại'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            StudentHeader(currentRoute: widget.exam.title),
            const Expanded(
              child: LoadingStateView(message: 'Đang tải đề thi và đồng bộ thời gian từ máy chủ…'),
            ),
          ],
        ),
      );
    }

    if (loadError != null || examData == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            StudentHeader(currentRoute: widget.exam.title),
            Expanded(
              child: ErrorStateView(
                message: loadError ?? 'Không thể tải đề thi.',
                onRetry: _startAttemptAndLoadExam,
              ),
            ),
          ],
        ),
      );
    }

    final questions = examData!.questions;
    final currentQ = questions[currentQuestionIndex];
    final selectedKey = userAnswers[currentQ.id];
    final isFlagged = flaggedQuestions.contains(currentQ.number);

    ReadingPassageItem? passageItem;
    if (currentQ.passageId != null && examData!.passages.containsKey(currentQ.passageId)) {
      passageItem = examData!.passages[currentQ.passageId];
    } else if (currentQ.part == 7 && examData!.passages.isNotEmpty) {
      passageItem = examData!.passages.values.first;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          StudentHeader(
            currentRoute: '${examData!.examTitle} · ${questions.length} câu · 75 phút',
          ),

          if (networkSyncWarning != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              color: AppColors.errorBg,
              child: Row(
                children: [
                  const Icon(Icons.wifi_off, size: 16, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      networkSyncWarning!,
                      style: const TextStyle(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

          // Test controls bar
          _buildTestControlsBar(currentQ),

          // Main 3-column workbench
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left: Navigator (240px)
                  SizedBox(
                    width: 250,
                    child: _buildQuestionNavigator(questions),
                  ),
                  const SizedBox(width: 14),

                  // Middle: Reading scroll pane
                  Expanded(
                    flex: 3,
                    child: _buildReadingPane(currentQ, passageItem),
                  ),
                  const SizedBox(width: 14),

                  // Right: Current Question pane (390px)
                  SizedBox(
                    width: 390,
                    child: _buildCurrentQuestionPane(questions, currentQ, selectedKey, isFlagged),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestControlsBar(QuestionItem currentQ) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 28),
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
              Text(examData!.examTitle, style: AppStyles.h3),
              const SizedBox(height: 2),
              Text(
                'Part ${currentQ.part} · ${currentQ.groupLabel ?? 'Câu hỏi trắc nghiệm'}',
                style: AppStyles.caption,
              ),
            ],
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isWarningTime ? 'Sắp hết giờ' : 'Thời gian còn lại',
                    style: TextStyle(
                      fontFamily: AppStyles.fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isWarningTime ? AppColors.warning : AppColors.primary,
                    ),
                  ),
                  const Text(
                    'Bài tự nộp khi hết giờ',
                    style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isWarningTime ? AppColors.warningBg : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isWarningTime ? AppColors.warning.withValues(alpha: 0.3) : AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: isWarningTime ? AppColors.warning : AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formattedTimer,
                      style: TextStyle(
                        fontFamily: AppStyles.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isWarningTime ? AppColors.warning : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: isSubmitting ? null : _confirmSubmit,
                icon: const Icon(Icons.send_rounded, size: 16),
                label: Text(isSubmitting ? 'Đang nộp…' : 'Nộp bài'),
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

  Widget _buildQuestionNavigator(List<QuestionItem> questions) {
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
                '$answered/${questions.length}',
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
              value: questions.isNotEmpty ? (answered / questions.length) : 0,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 14),

          // Scrollable parts grid
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavigatorSection('Part 5 (101–130)', questions.where((q) => q.part == 5).toList()),
                  const SizedBox(height: 12),
                  _buildNavigatorSection('Part 6 (131–146)', questions.where((q) => q.part == 6).toList()),
                  const SizedBox(height: 12),
                  _buildNavigatorSection('Part 7 (147–200)', questions.where((q) => q.part == 7).toList()),
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
            '$answered đã trả lời · ${questions.length - answered} chưa trả lời\n${flaggedQuestions.length} câu cần xem lại',
            style: AppStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigatorSection(String title, List<QuestionItem> partQuestions) {
    if (partQuestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppStyles.overline),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: partQuestions.map((q) {
            int idx = examData!.questions.indexOf(q);
            bool isCurrent = (currentQuestionIndex == idx);
            bool isAns = userAnswers.containsKey(q.id);
            bool isFlg = flaggedQuestions.contains(q.number);

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
              onTap: () => setState(() => currentQuestionIndex = idx),
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
                  isFlg && !isCurrent ? '${q.number}⚑' : '${q.number}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: textCol,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReadingPane(QuestionItem currentQ, ReadingPassageItem? passage) {
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
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),

          Expanded(
            child: SingleChildScrollView(
              child: passage != null
                  ? Column(
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
                            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: AppColors.textDark),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...passage.documents.map((doc) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildReadingDocumentCard(doc),
                            )),
                      ],
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Text(
                          'Part ${currentQ.part} gồm các câu hỏi ngữ pháp hoặc điền từ độc lập. Vui lòng đọc câu hỏi ở bảng bên phải.',
                          style: AppStyles.bodyMuted,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingDocumentCard(ReadingDoc doc) {
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
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted),
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
          if (doc.scheduleRows != null) ...[
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: AppColors.border, width: 1),
              children: doc.scheduleRows!.map((r) {
                return TableRow(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.white,
                      child: Text(r['time'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.white,
                      child: Text(r['activity'] ?? '', style: const TextStyle(fontSize: 11)),
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

  Widget _buildCurrentQuestionPane(
    List<QuestionItem> questions,
    QuestionItem currentQ,
    String? selectedKey,
    bool isFlagged,
  ) {
    // Quick question switcher for groups (e.g. 176–180 or neighbor questions)
    int startRange = (currentQ.number ~/ 5) * 5;
    if (startRange < 101) startRange = 101;
    final quickTabs = questions.where((q) => q.number >= startRange && q.number < startRange + 5).toList();

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
          // Quick group tabs
          if (quickTabs.isNotEmpty) ...[
            Row(
              children: quickTabs.map((q) {
                final isCur = (q.number == currentQ.number);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: InkWell(
                      onTap: () {
                        setState(() => currentQuestionIndex = questions.indexOf(q));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: isCur ? AppColors.primaryDark : AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${q.number}',
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
            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 14),
          ],

          // Label & Flag Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('CÂU ${currentQ.number} / ${questions.length}', style: AppStyles.overline),
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
          const SizedBox(height: 12),

          // Question Text
          Text(currentQ.text, style: AppStyles.h3),
          const SizedBox(height: 18),

          // Options List (Preserve order provided by Backend)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: currentQ.options.map((opt) {
                  final isSelected = (selectedKey == opt.key);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () => _selectOption(currentQ, opt),
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
                            const SizedBox(width: 12),
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

          // Footer info
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 10),
          Text(
            selectedKey != null
                ? 'Đã lưu lựa chọn $selectedKey (Nhấn lại để bỏ chọn) · Không hiển thị đáp án'
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
                      ? () => setState(() => currentQuestionIndex--)
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
                      ? () => setState(() => currentQuestionIndex++)
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

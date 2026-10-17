class PublishedExam {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final int totalQuestions;
  final String partsInfo;
  final bool isPublished;
  final String? updatedAt;

  PublishedExam({
    required this.id,
    required this.title,
    required this.description,
    this.durationMinutes = 75,
    this.totalQuestions = 100,
    this.partsInfo = 'Part 5, 6 & 7',
    this.isPublished = true,
    this.updatedAt,
  });

  factory PublishedExam.fromJson(Map<String, dynamic> json) {
    return PublishedExam(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Đề thi TOEIC Reading',
      description: json['description']?.toString() ?? '',
      durationMinutes: json['durationMinutes'] is int
          ? json['durationMinutes']
          : int.tryParse(json['durationMinutes']?.toString() ?? '75') ?? 75,
      totalQuestions: json['totalQuestions'] is int
          ? json['totalQuestions']
          : int.tryParse(json['totalQuestions']?.toString() ?? '100') ?? 100,
      partsInfo: json['partsInfo']?.toString() ?? 'Part 5, 6 & 7',
      isPublished: json['isPublished'] == null ? true : (json['isPublished'] == true),
      updatedAt: json['updatedAt']?.toString() ?? '16/10/2026',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'durationMinutes': durationMinutes,
        'totalQuestions': totalQuestions,
        'partsInfo': partsInfo,
        'isPublished': isPublished,
        'updatedAt': updatedAt,
      };
}

class ExamAttempt {
  final String attemptId;
  final String examId;
  final String examTitle;
  final DateTime startTime;
  final DateTime endTime;
  final int remainingSeconds;
  final String status;

  ExamAttempt({
    required this.attemptId,
    required this.examId,
    required this.examTitle,
    required this.startTime,
    required this.endTime,
    required this.remainingSeconds,
    this.status = 'in_progress',
  });

  factory ExamAttempt.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    DateTime end = now.add(const Duration(minutes: 75));
    if (json['endTime'] != null) {
      end = DateTime.tryParse(json['endTime'].toString()) ?? end;
    }

    int remaining = 75 * 60;
    if (json['remainingSeconds'] != null) {
      remaining = int.tryParse(json['remainingSeconds'].toString()) ?? remaining;
    } else {
      remaining = end.difference(now).inSeconds;
      if (remaining < 0) remaining = 0;
    }

    return ExamAttempt(
      attemptId: json['attemptId']?.toString() ?? json['id']?.toString() ?? '',
      examId: json['examId']?.toString() ?? '',
      examTitle: json['examTitle']?.toString() ?? 'TOEIC Reading Practice',
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'].toString()) ?? now
          : now,
      endTime: end,
      remainingSeconds: remaining,
      status: json['status']?.toString() ?? 'in_progress',
    );
  }
}

class OptionItem {
  final String id;
  final String key; // 'A', 'B', 'C', 'D'
  final String text;

  OptionItem({
    required this.id,
    required this.key,
    required this.text,
  });

  factory OptionItem.fromJson(Map<String, dynamic> json) {
    return OptionItem(
      id: json['id']?.toString() ?? '',
      key: json['key']?.toString() ?? 'A',
      text: json['text']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'text': text,
      };
}

/// Question representation during exam taking.
/// IMPORTANT: Does NOT contain the correct answer.
class QuestionItem {
  final String id;
  final int number; // 101 to 200
  final int part;   // 5, 6, 7
  final String text;
  final List<OptionItem> options;
  final String? passageId;
  final String? groupLabel;

  QuestionItem({
    required this.id,
    required this.number,
    required this.part,
    required this.text,
    required this.options,
    this.passageId,
    this.groupLabel,
  });

  factory QuestionItem.fromJson(Map<String, dynamic> json) {
    var rawOptions = json['options'];
    List<OptionItem> opts = [];
    if (rawOptions is List) {
      opts = rawOptions.map((o) => OptionItem.fromJson(o as Map<String, dynamic>)).toList();
    }

    return QuestionItem(
      id: json['id']?.toString() ?? '',
      number: json['number'] is int
          ? json['number']
          : int.tryParse(json['number']?.toString() ?? '0') ?? 0,
      part: json['part'] is int
          ? json['part']
          : int.tryParse(json['part']?.toString() ?? '5') ?? 5,
      text: json['text']?.toString() ?? '',
      options: opts,
      passageId: json['passageId']?.toString(),
      groupLabel: json['groupLabel']?.toString(),
    );
  }
}

class ReadingDoc {
  final String title;
  final String type; // notice, email, schedule
  final String content;
  final Map<String, String>? metadata;
  final List<Map<String, String>>? scheduleRows;

  ReadingDoc({
    required this.title,
    required this.type,
    required this.content,
    this.metadata,
    this.scheduleRows,
  });

  factory ReadingDoc.fromJson(Map<String, dynamic> json) {
    Map<String, String>? meta;
    if (json['metadata'] is Map) {
      meta = (json['metadata'] as Map).map((k, v) => MapEntry(k.toString(), v.toString()));
    }

    List<Map<String, String>>? rows;
    if (json['scheduleRows'] is List) {
      rows = (json['scheduleRows'] as List).map((item) {
        if (item is Map) {
          return item.map((k, v) => MapEntry(k.toString(), v.toString()));
        }
        return <String, String>{};
      }).toList();
    }

    return ReadingDoc(
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? 'notice',
      content: json['content']?.toString() ?? '',
      metadata: meta,
      scheduleRows: rows,
    );
  }
}

class ReadingPassageItem {
  final String id;
  final String title;
  final String instruction;
  final List<ReadingDoc> documents;

  ReadingPassageItem({
    required this.id,
    required this.title,
    required this.instruction,
    required this.documents,
  });

  factory ReadingPassageItem.fromJson(Map<String, dynamic> json) {
    var rawDocs = json['documents'];
    List<ReadingDoc> docs = [];
    if (rawDocs is List) {
      docs = rawDocs.map((d) => ReadingDoc.fromJson(d as Map<String, dynamic>)).toList();
    }

    return ReadingPassageItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      instruction: json['instruction']?.toString() ?? '',
      documents: docs,
    );
  }
}

class ExamContentData {
  final String attemptId;
  final String examTitle;
  final int remainingSeconds;
  final DateTime endTime;
  final List<QuestionItem> questions;
  final Map<String, ReadingPassageItem> passages;
  final Map<String, String> initialAnswers; // questionId -> optionId

  ExamContentData({
    required this.attemptId,
    required this.examTitle,
    required this.remainingSeconds,
    required this.endTime,
    required this.questions,
    required this.passages,
    this.initialAnswers = const {},
  });

  factory ExamContentData.fromJson(Map<String, dynamic> json) {
    var qList = (json['questions'] as List?)
            ?.map((q) => QuestionItem.fromJson(q as Map<String, dynamic>))
            .toList() ??
        [];

    Map<String, ReadingPassageItem> passMap = {};
    if (json['passages'] is List) {
      for (var p in (json['passages'] as List)) {
        var item = ReadingPassageItem.fromJson(p as Map<String, dynamic>);
        passMap[item.id] = item;
      }
    } else if (json['passages'] is Map) {
      (json['passages'] as Map).forEach((k, v) {
        passMap[k.toString()] = ReadingPassageItem.fromJson(v as Map<String, dynamic>);
      });
    }

    Map<String, String> answers = {};
    if (json['savedAnswers'] is Map) {
      (json['savedAnswers'] as Map).forEach((k, v) {
        answers[k.toString()] = v.toString();
      });
    }

    final now = DateTime.now();
    DateTime end = now.add(const Duration(minutes: 75));
    if (json['endTime'] != null) {
      end = DateTime.tryParse(json['endTime'].toString()) ?? end;
    }

    int remaining = 75 * 60;
    if (json['remainingSeconds'] != null) {
      remaining = int.tryParse(json['remainingSeconds'].toString()) ?? remaining;
    } else {
      remaining = end.difference(now).inSeconds;
      if (remaining < 0) remaining = 0;
    }

    return ExamContentData(
      attemptId: json['attemptId']?.toString() ?? '',
      examTitle: json['examTitle']?.toString() ?? 'TOEIC Reading Practice 01',
      remainingSeconds: remaining,
      endTime: end,
      questions: qList,
      passages: passMap,
      initialAnswers: answers,
    );
  }
}

class QuestionResultItem {
  final int questionNumber;
  final int part;
  final String? selectedAnswer; // 'A', 'B', 'C', 'D'
  final String? correctAnswer;   // 'A', 'B', 'C', 'D'
  final bool isCorrect;
  final bool isSkipped;

  QuestionResultItem({
    required this.questionNumber,
    required this.part,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.isSkipped,
  });

  factory QuestionResultItem.fromJson(Map<String, dynamic> json) {
    return QuestionResultItem(
      questionNumber: json['questionNumber'] is int
          ? json['questionNumber']
          : int.tryParse(json['questionNumber']?.toString() ?? '0') ?? 0,
      part: json['part'] is int
          ? json['part']
          : int.tryParse(json['part']?.toString() ?? '5') ?? 5,
      selectedAnswer: json['selectedAnswer']?.toString(),
      correctAnswer: json['correctAnswer']?.toString(),
      isCorrect: json['isCorrect'] == true,
      isSkipped: json['isSkipped'] == true,
    );
  }
}

class ExamResultData {
  final String attemptId;
  final String examTitle;
  final String submittedAt;
  final String durationUsedFormatted;
  final int rawScore;
  final int totalQuestions;
  final int correctCount;
  final int wrongCount;
  final int skippedCount;
  final double accuracyRate;
  final List<QuestionResultItem> detailedResults;

  ExamResultData({
    required this.attemptId,
    required this.examTitle,
    required this.submittedAt,
    required this.durationUsedFormatted,
    required this.rawScore,
    required this.totalQuestions,
    required this.correctCount,
    required this.wrongCount,
    required this.skippedCount,
    required this.accuracyRate,
    required this.detailedResults,
  });

  factory ExamResultData.fromJson(Map<String, dynamic> json) {
    var rawList = json['detailedResults'] as List?;
    List<QuestionResultItem> items = [];
    if (rawList != null) {
      items = rawList
          .map((i) => QuestionResultItem.fromJson(i as Map<String, dynamic>))
          .toList();
    }

    return ExamResultData(
      attemptId: json['attemptId']?.toString() ?? '',
      examTitle: json['examTitle']?.toString() ?? 'TOEIC Reading Practice 01',
      submittedAt: json['submittedAt']?.toString() ?? '10:55, 16/10/2026',
      durationUsedFormatted: json['durationUsedFormatted']?.toString() ?? '70 phút 02 giây',
      rawScore: json['rawScore'] is int
          ? json['rawScore']
          : int.tryParse(json['rawScore']?.toString() ?? '78') ?? 78,
      totalQuestions: json['totalQuestions'] is int
          ? json['totalQuestions']
          : int.tryParse(json['totalQuestions']?.toString() ?? '100') ?? 100,
      correctCount: json['correctCount'] is int
          ? json['correctCount']
          : int.tryParse(json['correctCount']?.toString() ?? '78') ?? 78,
      wrongCount: json['wrongCount'] is int
          ? json['wrongCount']
          : int.tryParse(json['wrongCount']?.toString() ?? '14') ?? 14,
      skippedCount: json['skippedCount'] is int
          ? json['skippedCount']
          : int.tryParse(json['skippedCount']?.toString() ?? '8') ?? 8,
      accuracyRate: (json['accuracyRate'] is num)
          ? (json['accuracyRate'] as num).toDouble()
          : double.tryParse(json['accuracyRate']?.toString() ?? '78.0') ?? 78.0,
      detailedResults: items,
    );
  }
}

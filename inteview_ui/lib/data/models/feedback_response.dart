class InterviewFeedback {
  final int score;
  final String feedback;
  final List<String> areasForImprovement;

  InterviewFeedback({
    required this.score,
    required this.feedback,
    required this.areasForImprovement,
  });

  factory InterviewFeedback.fromJson(Map<String, dynamic> json) {
    return InterviewFeedback(
      score: json['score'] ?? 0,
      feedback: json['feedback'] ?? '',
      areasForImprovement: List<String>.from(json['areas_for_improvement'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'feedback': feedback,
      'areas_for_improvement': areasForImprovement,
    };
  }
}

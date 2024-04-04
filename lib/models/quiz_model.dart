class QuizModel {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  QuizModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      question: json['question'],
      options: (json['options'] as Map<String, dynamic>).values.cast<String>().toList(),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
    );
  }
}



Map kQuestionJson  = {
  "questions": [
    {
      "question": "What does the term 'e-waste' refer to?",
      "options": {
        "option1": "Electronic waste",
        "option2": "Electrical waste",
        "option3": "Environmental waste",
        "option4": "Ecological waste"
      },
      "correctAnswer": "Electronic waste",
      "explanation": "E-waste refers to discarded electronic devices, such as computers, smartphones, and TVs, that have reached the end of their useful life."
    },
    {
      "question": "Which of the following electronic devices can be considered e-waste?",
      "options": {
        "option1": "Microwave oven",
        "option2": "Refrigerator",
        "option3": "Smartphone",
        "option4": "All of the above"
      },
      "correctAnswer": "All of the above",
      "explanation": "All of the listed electronic devices can be considered e-waste when they are no longer functional or are discarded by the owner."
    },
    {
      "question": "What percentage of global e-waste is recycled annually, according to recent estimates?",
      "options": {
        "option1": "Less than 10%",
        "option2": "Around 25%",
        "option3": "Approximately 40%",
        "option4": "Over 60%"
      },
      "correctAnswer": "Approximately 40%",
      "explanation": "Approximately 40% of global e-waste is recycled annually, highlighting the need for improved recycling efforts to address the growing e-waste problem."
    },
    {
      "question": "Which of the following hazardous materials can be found in electronic devices?",
      "options": {
        "option1": "Lead",
        "option2": "Mercury",
        "option3": "Cadmium",
        "option4": "All of the above"
      },
      "correctAnswer": "All of the above",
      "explanation": "Lead, mercury, and cadmium are common hazardous materials found in electronic devices, posing environmental and health risks if not properly managed."
    },
    {
      "question": "Which recycling symbol is commonly associated with electronic waste?",
      "options": {
        "option1": "Recycling symbol with a number inside",
        "option2": "Recycling symbol with arrows in a circle",
        "option3": "Recycling symbol with a crossed-out trash can",
        "option4": "Recycling symbol with a leaf"
      },
      "correctAnswer": "Recycling symbol with a crossed-out trash can",
      "explanation": "The recycling symbol with a crossed-out trash can is commonly associated with electronic waste and indicates that the item should not be disposed of in regular trash but recycled."
    },
    {
      "question": "What is the primary reason for recycling e-waste?",
      "options": {
        "option1": "To reduce landfill waste",
        "option2": "To recover valuable resources",
        "option3": "To prevent environmental pollution",
        "option4": "All of the above"
      },
      "correctAnswer": "All of the above",
      "explanation": "Recycling e-waste helps reduce landfill waste, recover valuable resources like metals and plastics, and prevent environmental pollution by properly disposing of hazardous materials."
    },
    {
      "question": "Which organization provides certification for responsible e-waste recycling practices?",
      "options": {
        "option1": "EPA (Environmental Protection Agency)",
        "option2": "WHO (World Health Organization)",
        "option3": "R2 (Responsible Recycling)",
        "option4": "FDA (Food and Drug Administration)"
      },
      "correctAnswer": "R2 (Responsible Recycling)",
      "explanation": "The R2 (Responsible Recycling) certification program provides certification for responsible e-waste recycling practices, ensuring that recyclers adhere to strict environmental and worker safety standards."
    },
    {
      "question": "What are the potential health risks associated with improper disposal of e-waste?",
      "options": {
        "option1": "Respiratory problems",
        "option2": "Neurological disorders",
        "option3": "Cancer",
        "option4": "All of the above"
      },
      "correctAnswer": "All of the above",
      "explanation": "Improper disposal of e-waste can lead to various health risks, including respiratory problems, neurological disorders, and increased risk of cancer due to exposure to hazardous materials."
    },
    {
      "question": "Which of the following is NOT a proper disposal method for e-waste?",
      "options": {
        "option1": "Donating to a certified recycling facility",
        "option2": "Placing in household trash",
        "option3": "Bringing to an e-waste collection event",
        "option4": "Returning to the manufacturer for recycling"
      },
      "correctAnswer": "Placing in household trash",
      "explanation": "Placing e-waste in household trash is not a proper disposal method as it can lead to environmental pollution and health hazards. It's important to recycle or properly dispose of e-waste through certified recycling facilities or collection events."
    },
    {
      "question": "How can consumers reduce e-waste generation?",
      "options": {
        "option1": "Donate or sell old electronics",
        "option2": "Repair and upgrade existing devices",
        "option3": "Recycle electronics at designated facilities",
        "option4": "All of the above"
      },
      "correctAnswer": "All of the above",
      "explanation": "Consumers can reduce e-waste generation by donating or selling old electronics, repairing and upgrading existing devices to extend their lifespan, and recycling electronics at designated facilities to ensure proper disposal and resource recovery."
    },
    {
      "question": "over",
      "options": {
        "option1": "Donate or sell old electronics",
        "option2": "Repair and upgrade existing devices",
        "option3": "Recycle electronics at designated facilities",
        "option4": "All of the above"
      },
      "correctAnswer": "All of the above",
      "explanation": "Consumers can reduce e-waste generation by donating or selling old electronics, repairing and upgrading existing devices to extend their lifespan, and recycling electronics at designated facilities to ensure proper disposal and resource recovery."
    }
  ]
};

List<QuizModel> ewasteQuizQuestions = [
  QuizModel(
      question: "What does the term 'e-waste' refer to?",
      options: [
        "Electronic waste",
        "Electrical waste",
        "Environmental waste",
        "Ecological waste"
      ],
      correctAnswer: "Electronic waste",
      explanation:
          "E-waste refers to discarded electronic devices, such as computers, smartphones, and TVs, that have reached the end of their useful life."),
  QuizModel(
      question:
          "Which of the following electronic devices can be considered e-waste?",
      options: [
        "Microwave oven",
        "Refrigerator",
        "Smartphone",
        "All of the above"
      ],
      correctAnswer: "All of the above",
      explanation:
          "All of the listed electronic devices can be considered e-waste when they are no longer functional or are discarded by the owner."),
  QuizModel(
      question:
          "What percentage of global e-waste is recycled annually, according to recent estimates?",
      options: ["Less than 10%", "Around 25%", "Approximately 40%", "Over 60%"],
      correctAnswer: "Approximately 40%",
      explanation:
          "Approximately 40% of global e-waste is recycled annually, highlighting the need for improved recycling efforts to address the growing e-waste problem."),
  QuizModel(
      question:
          "Which of the following hazardous materials can be found in electronic devices?",
      options: ["Lead", "Mercury", "Cadmium", "All of the above"],
      correctAnswer: "All of the above",
      explanation:
          "Lead, mercury, and cadmium are common hazardous materials found in electronic devices, posing environmental and health risks if not properly managed."),
  QuizModel(
      question:
          "Which recycling symbol is commonly associated with electronic waste?",
      options: [
        "Recycling symbol with a number inside",
        "Recycling symbol with arrows in a circle",
        "Recycling symbol with a crossed-out trash can",
        "Recycling symbol with a leaf"
      ],
      correctAnswer: "Recycling symbol with a crossed-out trash can",
      explanation:
          "The recycling symbol with a crossed-out trash can is commonly associated with electronic waste and indicates that the item should not be disposed of in regular trash but recycled."),
  QuizModel(
      question: "What is the primary reason for recycling e-waste?",
      options: [
        "To reduce landfill waste",
        "To recover valuable resources",
        "To prevent environmental pollution",
        "All of the above"
      ],
      correctAnswer: "All of the above",
      explanation:
          "Recycling e-waste helps reduce landfill waste, recover valuable resources like metals and plastics, and prevent environmental pollution by properly disposing of hazardous materials."),
  QuizModel(
      question:
          "Which organization provides certification for responsible e-waste recycling practices?",
      options: [
        "EPA (Environmental Protection Agency)",
        "WHO (World Health Organization)",
        "R2 (Responsible Recycling)",
        "FDA (Food and Drug Administration)"
      ],
      correctAnswer: "R2 (Responsible Recycling)",
      explanation:
          "The R2 (Responsible Recycling) certification program provides certification for responsible e-waste recycling practices, ensuring that recyclers adhere to strict environmental and worker safety standards."),
  QuizModel(
      question:
          "What are the potential health risks associated with improper disposal of e-waste?",
      options: [
        "Respiratory problems",
        "Neurological disorders",
        "Cancer",
        "All of the above"
      ],
      correctAnswer: "All of the above",
      explanation:
          "Improper disposal of e-waste can lead to various health risks, including respiratory problems, neurological disorders, and increased risk of cancer due to exposure to hazardous materials."),
  QuizModel(
      question:
          "Which of the following is NOT a proper disposal method for e-waste?",
      options: [
        "Donating to a certified recycling facility",
        "Placing in household trash",
        "Bringing to an e-waste collection event",
        "Returning to the manufacturer for recycling"
      ],
      correctAnswer: "Placing in household trash",
      explanation:
          "Placing e-waste in household trash is not a proper disposal method as it can lead to environmental pollution and health hazards. It's important to recycle or properly dispose of e-waste through certified recycling facilities or collection events."),
  QuizModel(
      question: "How can consumers reduce e-waste generation?",
      options: [
        "Donate or sell old electronics",
        "Repair and upgrade existing devices",
        "Recycle electronics at designated facilities",
        "All of the above"
      ],
      correctAnswer: "All of the above",
      explanation:
          "Consumers can reduce e-waste generation by donating or selling old electronics, repairing and upgrading existing devices to extend their lifespan, and recycling electronics at designated facilities to ensure proper disposal and resource recovery."),
  QuizModel(
      question: "over",
      options: [
        "Donate or sell old electronics",
        "Repair and upgrade existing devices",
        "Recycle electronics at designated facilities",
        "All of the above"
      ],
      correctAnswer: "All of the above",
      explanation:
      "Consumers can reduce e-waste generation by donating or selling old electronics, repairing and upgrading existing devices to extend their lifespan, and recycling electronics at designated facilities to ensure proper disposal and resource recovery."),
];

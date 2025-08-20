int calculateReadingTime(String content){
  final wordCount = content.split(RegExp(r'\s+')).length;
  // A human reads approx. 225 words per minute.

  final readingTime = wordCount/225;

  return readingTime.ceil();
}
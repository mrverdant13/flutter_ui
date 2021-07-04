part of 'screen.dart';

@immutable
class _LetterPageData {
  const _LetterPageData({
    required this.letter,
    required this.primaryColor,
    required this.accentColor,
  });

  final String letter;
  final Color primaryColor;
  final Color accentColor;
}

const pagesData = <_LetterPageData>{
  _LetterPageData(
    letter: 'A',
    primaryColor: Colors.red,
    accentColor: Colors.black,
  ),
  _LetterPageData(
    letter: 'B',
    primaryColor: Colors.yellow,
    accentColor: Colors.black,
  ),
  _LetterPageData(
    letter: 'C',
    primaryColor: Colors.blue,
    accentColor: Colors.black,
  ),
  _LetterPageData(
    letter: 'D',
    primaryColor: Colors.green,
    accentColor: Colors.black,
  ),
};

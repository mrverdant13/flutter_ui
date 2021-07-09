part of 'screen.dart';

class _TerminalWindow extends StatelessWidget {
  const _TerminalWindow({
    Key? key,
    required this.backgroundColor,
    required this.titleBarColor,
    required this.title,
    required this.content,
  }) : super(key: key);

  final Color backgroundColor;
  final Color titleBarColor;
  final Widget title;
  final Widget content;

  @override
  Widget build(BuildContext context) => Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: titleBarColor,
              padding: const EdgeInsets.all(5),
              height: 30.0,
              alignment: Alignment.centerLeft,
              child: title,
            ),
            Expanded(
              child: Container(
                color: backgroundColor,
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: content,
              ),
            ),
          ],
        ),
      );
}

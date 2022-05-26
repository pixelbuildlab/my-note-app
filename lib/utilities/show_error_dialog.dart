Future<void> showErrorDialog(
  BuildContext context,
  String string,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('An Error occurred.'),
        content: Text(string),
        actions: [
          TextButton(
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              child: const Text('OK')),
        ],
      );
    },
  );
}

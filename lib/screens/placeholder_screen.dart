import 'package:flutter/material.dart';
import 'package:sport_news/utils/placeholder_items.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Новости спорта'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: placeholderItems.length,
            itemBuilder: (context, index) {
              return NewsTile(
                item: placeholderItems[index],
              );
            },
          ),
        ),
      ),
    );
  }
}

class NewsTile extends StatelessWidget {
  const NewsTile({Key? key, required this.item}) : super(key: key);

  final PlaceholderItem item;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1, color: Colors.grey.shade200),
      )),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          Image.asset(
            'assets/pics/${item.pictureName}',
            width: 200,
            height: 125,
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: width - 200 - 40 - 20,
            height: 125,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    item.text,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
                Text(
                  item.category,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

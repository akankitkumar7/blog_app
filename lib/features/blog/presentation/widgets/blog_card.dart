import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';
class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: blog.topics.map((e) => Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Chip(label: Text(e)),
                    ),
                  ).toList(),
                ),
                ),
              Text(blog.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),maxLines: 1,overflow: TextOverflow.ellipsis,),
            ],
          ),
          Text('${calculateReadingTime(blog.content)} min'),
        ],
      ),
    );
  }
}

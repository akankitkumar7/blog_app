import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<String> _filteredTopics = [];

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _filteredTopics.clear();
    });
  }

  void _filterBlogs(String query) {
    // Assuming you have access to Constants.topics somewhere
    // For demonstration, I'll use a placeholder list
    const List<String> allTopics = Constants.topics; // Replace with your actual topics

    setState(() {
      if (query.isEmpty) {
        _filteredTopics.clear();
      } else {
        _filteredTopics = allTopics
            .where((topic) => topic.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppPallete.blueColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () {
            Navigator.push(context, AddNewBlogPage.route());
          },
          icon: const Icon(
            CupertinoIcons.add,
            color: AppPallete.whiteColor,
            size: 28,
          ),
        ),
      ),
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search by topic...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _filterBlogs,
        )
            : const Text('Blog App'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _stopSearch,
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _startSearch,
            ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogDisplaySuccess) {
            // If we're searching and have filtered topics, show filtered blogs
            if (_isSearching && _filteredTopics.isNotEmpty) {
              final filteredBlogs = state.blogs.where((blog) {
                return _filteredTopics.any((topic) =>
                    blog.topics.contains(topic));
              }).toList();

              return ListView.builder(
                itemCount: filteredBlogs.length,
                itemBuilder: (context, index) {
                  final blog = filteredBlogs[index];
                  return BlogCard(blog: blog);
                },
              );
            }

            // If we're searching but no results, show message
            if (_isSearching && _filteredTopics.isEmpty && _searchController.text.isNotEmpty) {
              return const Center(
                child: Text('No blogs found for this topic'),
              );
            }

            // Default view - all blogs
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(blog: blog);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
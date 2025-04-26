import 'package:flutter/material.dart';
import 'package:vercel_cookbooks/cookbook.dart';

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: const CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Cookbook',
                            style: TextStyle(
                              fontFamily: 'Geist',
                              fontWeight: FontWeight.w600,
                              fontSize: 36,
                              height: 40 / 36,
                              color: Color(0xFF171717),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'An open-source collection of recipes, guides, and templates for building with the AI SDK.',
                            style: TextStyle(
                              fontFamily: 'Geist',
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              height: 28 / 20,
                              color: Color(0xFF71717A),
                            ),
                          ),
                          SizedBox(height: 40),
                          Text(
                            'Guides',
                            style: TextStyle(
                              fontFamily: 'Geist',
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              height: 32 / 24,
                              color: Color(0xFF171717),
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                    _Cookbooks(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cookbooks extends StatelessWidget {
  const _Cookbooks();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final crossAxisCount = switch (screenWidth) {
      < 400 => 1,
      < 600 => 2,
      < 768 => 3,
      _ => 4,
    };

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        mainAxisExtent: Cookbook.maxWidth / Cookbook.aspectRatio,
      ),
      delegate: SliverChildListDelegate(
        const <Widget>[
          Cookbook(
            title: 'Build a Natural Language Postgres Editor',
            color: Color(0xFF2A3D45),
            textColor: Colors.white,
          ),
          Cookbook(
            title: 'Get Started with Computer Use',
            color: Color(0xFF8B585F),
            textColor: Colors.white,
          ),
          Cookbook(
            title: 'Get Started with OpenAI o1',
            color: Color(0xFFE49273),
            textColor: Colors.black,
          ),
          Cookbook(
            title: 'Get started with Llama 3.1',
            color: Color(0xFFA8D0DB),
            textColor: Colors.black,
          ),
          Cookbook(
            title: 'Multi-Modal Chatbot',
            color: Color(0xFF7E8287),
            textColor: Colors.white,
          ),
          Cookbook(
            title: 'Build a Chatbot with Retrieval Augmented Generation',
            color: Color(0xFF2B4570),
            textColor: Colors.white,
          ),
        ],
        addRepaintBoundaries: false,
      ),
    );
  }
}

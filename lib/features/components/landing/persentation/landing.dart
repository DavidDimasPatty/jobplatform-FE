import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _Landing();
}

class _Landing extends State<Landing> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
          ? _buildDrawer()
          : null,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeroSection(context),
                _buildStatsSection(),
                Container(key: _featuresKey, child: _buildFeaturesSection()),
                Container(
                  key: _howItWorksKey,
                  child: _buildHowItWorksSection(),
                ),
                Container(key: _aboutKey, child: _buildCTASection()),
                _buildFooter(),
              ],
            ),
          ),
          // App Bar
          _buildAppBar(context),
        ],
      ),
    );
  }

  // App Bar and Drawer
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade800],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Skillen',
                  style: GoogleFonts.dancingScript(
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find Your Dream Job',
                  style: TextStyle(color: Colors.blue.shade100, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Features'),
            onTap: () {
              Navigator.of(context).pop();
              _scrollToSection(_featuresKey);
            },
          ),
          ListTile(
            title: const Text('How it Works'),
            onTap: () {
              Navigator.of(context).pop();
              _scrollToSection(_howItWorksKey);
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              Navigator.of(context).pop();
              _scrollToSection(_aboutKey);
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue.shade700),
                      foregroundColor: Colors.blue,
                    ),
                    child: const Text('Sign In'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/signUp');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text('Get Started'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _isScrolled ? Colors.white : Colors.transparent,
        boxShadow: _isScrolled
            ? [BoxShadow(color: Colors.black12, blurRadius: 10)]
            : [],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Text(
                'Skillen',
                style: GoogleFonts.dancingScript(
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const Spacer(),
              if (ResponsiveBreakpoints.of(context).largerThan(MOBILE)) ...[
                TextButton(
                  onPressed: () => _scrollToSection(_featuresKey),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  child: const Text('Features'),
                ),
                TextButton(
                  onPressed: () => _scrollToSection(_howItWorksKey),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  child: const Text('How it Works'),
                ),
                TextButton(
                  onPressed: () => _scrollToSection(_aboutKey),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  child: const Text('About'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue.shade700),
                    foregroundColor: Colors.blue,
                  ),
                  child: const Text('Sign In'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    context.go('/signUp');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Get Started'),
                ),
              ] else
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Hero Section
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade50, Colors.blue.shade100],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 120, 20, 80),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 800;
            return Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: isWide ? 1 : 0,
                  child: Column(
                    crossAxisAlignment: isWide
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Find Your Dream Job',
                        style: TextStyle(
                          fontSize: isWide ? 56 : 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        textAlign: isWide ? TextAlign.left : TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Today',
                        style: TextStyle(
                          fontSize: isWide ? 56 : 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Connect with top employers and discover opportunities that match your skills and ambitions. Your next career move starts here.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                        textAlign: isWide ? TextAlign.left : TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: isWide
                            ? WrapAlignment.start
                            : WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              context.go('/signUp');
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Get Started'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 20,
                              ),
                              textStyle: const TextStyle(fontSize: 16),
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isWide) const SizedBox(width: 60),
                if (!isWide) const SizedBox(height: 40),
                Flexible(flex: isWide ? 1 : 0, child: _buildJobCards()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildJobCards() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildJobCard(
            'Senior Developer',
            'Tech Corp • \$120K-150K',
            Colors.blue,
            Icons.code,
          ),
          const SizedBox(height: 12),
          _buildJobCard(
            'Product Manager',
            'StartupCo • \$100K-130K',
            Colors.green,
            Icons.dashboard,
          ),
          const SizedBox(height: 12),
          _buildJobCard(
            'UX Designer',
            'DesignHub • \$90K-110K',
            Colors.purple,
            Icons.design_services,
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(
    String title,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Stats Section
  Widget _buildStatsSection() {
    return Container(
      width: double.infinity,
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
          return Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _buildStatItem('50K+', 'Active Jobs'),
              _buildStatItem('10K+', 'Companies'),
              _buildStatItem('1M+', 'Job Seekers'),
              _buildStatItem('95%', 'Success Rate'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.blue.shade100),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Features Section
  Widget _buildFeaturesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'Why Choose Skillen?',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Everything you need to land your perfect job',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 1000
                  ? 4
                  : constraints.maxWidth > 600
                  ? 2
                  : 1;
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _buildFeatureCard(
                    Icons.search,
                    'Smart Job Search',
                    'Find your dream job with AI-powered search and personalized recommendations',
                  ),
                  _buildFeatureCard(
                    Icons.work,
                    'Thousands of Jobs',
                    'Access over 50,000+ job listings from top companies worldwide',
                  ),
                  _buildFeatureCard(
                    Icons.people,
                    'Build Your Network',
                    'Connect with recruiters and professionals in your industry',
                  ),
                  _buildFeatureCard(
                    Icons.trending_up,
                    'Career Growth',
                    'Get insights and resources to advance your career journey',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue, size: 32),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // How It Works Section
  Widget _buildHowItWorksSection() {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'How It Works',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _buildStepCard(
                '1',
                'Create Profile',
                'Sign up and build your professional profile',
              ),
              _buildStepCard(
                '2',
                'Search Jobs',
                'Browse thousands of job opportunities',
              ),
              _buildStepCard('3', 'Get Hired', 'Apply and land your dream job'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(String number, String title, String description) {
    return SizedBox(
      width: 250,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Call to Action Section
  Widget _buildCTASection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          Text(
            'Ready to Start Your Journey?',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Join thousands of successful job seekers who found their dream careers with us',
            style: TextStyle(fontSize: 18, color: Colors.blue.shade100),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              context.go('/signUp');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Create Free Account'),
          ),
        ],
      ),
    );
  }

  // Footer Section
  Widget _buildFooter() {
    return Container(
      color: Colors.grey.shade900,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Wrap(
            spacing: 60,
            runSpacing: 40,
            children: [
              _buildFooterColumn('Skillen', [
                'Find your dream job with the best job search platform',
              ]),
              _buildFooterColumn('Company', ['About Us', 'Careers', 'Blog']),
              _buildFooterColumn('Resources', [
                'Help Center',
                'Contact',
                'Privacy',
              ]),
              _buildFooterColumn('Connect', [
                'Twitter',
                'LinkedIn',
                'Facebook',
              ]),
            ],
          ),
          const SizedBox(height: 40),
          Divider(color: Colors.grey.shade800),
          const SizedBox(height: 20),
          Text(
            '© 2025 Skillen. All rights reserved.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterColumn(String title, List<String> items) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(item, style: TextStyle(color: Colors.grey.shade400)),
            ),
          ),
        ],
      ),
    );
  }
}

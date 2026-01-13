import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart'; // ضيف دي عشان نترجم الـ labels
import 'package:masar_app/core/widgets/custom_chat_btn.dart';
import 'package:masar_app/features/login/presentation/manager/auth_cubit.dart';
import 'package:masar_app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../manager/home_cubit.dart';

// الاستيرادات كما هي...
import '../../../add_client/presentation/screens/add_client_screen.dart';
import '../../../add_client/presentation/manager/add_client_cubit.dart';
import '../../../add_client/data/repos/add_client_repo_impl.dart';
import '../../../daily_tasks/presentation/screens/daily_tasks_screen.dart';
import '../../../daily_tasks/presentation/manager/tasks_cubit.dart';
import '../../../daily_tasks/data/repos/daily_tasks_repo_impl.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final currentIndex = context.read<HomeCubit>().state.index;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> _getViews() => [
    const ProfileScreen(),
    BlocProvider(
      create: (context) => AddClientCubit(AddClientRepoImpl()),
      child: const AddClientScreen(),
    ),
    BlocProvider(
      create: (context) {
        
   
      
    
    

    // Index 3: شاشة الإعدادات الحقيقية (تم التعديل هنا) 👇
        final authState = context.read<AuthCubit>().state as AuthCubitAuthenticated;
        return TasksCubit(
          repository: TaskRepositoryImpl(firestore: FirebaseFirestore.instance),
          representativeId: authState.user.uid,
        )..getTasks();
      },
      child: DailyTasksScreen(agentId: (context.read<AuthCubit>().state as AuthCubitAuthenticated).user.uid),
    ),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final views = _getViews();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (_pageController.hasClients) {
          int currentPage = _pageController.page?.round() ?? 0;
          if ((state.index - currentPage).abs() > 1) {
            _pageController.jumpToPage(state.index);
          } else {
            _pageController.animateToPage(
              state.index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          // 2. تحديث خلفية الـ Scaffold
          backgroundColor: isDarkMode ? const Color(0xFF121212) : AppColors.backgroundLight,

          floatingActionButton: CustomChatBtn(
            onPressed: () {
              final currentUserId =
                  (context.read<AuthCubit>().state as AuthCubitAuthenticated)
                      .user
                      .uid;
              context.pushNamed(
                AppRoutes.chat,
                pathParameters: {
                  'agentId': currentUserId, // أو agentId الحقيقي
                },
                extra: currentUserId,
              );
            },
          ),
          body: PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              context.read<HomeCubit>().changeIndex(index);
            },
            children: views,
          ),
          bottomNavigationBar: Container(
            // 1. إضافة Padding من الجوانب ومن تحت عشان ميبقاش لازق
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              // تحديث لون الـ Container الخارجي
              color: isDarkMode ? const Color(0xFF1A1A1A) : AppColors.backgroundWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BottomNavigationBar(
                  currentIndex: state.index,
                  onTap: (index) {
                    context.read<HomeCubit>().changeIndex(index);
                  },
                  type: BottomNavigationBarType.fixed,
                  elevation: 0, // بنصفرها لأن الـ Container هو اللي شايل الـ Shadow
                  backgroundColor: Colors.transparent, // شفاف عشان ياخد لون الـ Container اللي وراه
                  // 4. ألوان تنطق في الـ Dark Mode
                  selectedItemColor: isDarkMode ? const Color(0xFF4FC3F7) : AppColors.bluePrimaryDark,
                  unselectedItemColor: isDarkMode ? Colors.white38 : Colors.grey,
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.person_outline),
                      activeIcon: const Icon(Icons.person),
                      label: 'nav.profile'.tr(),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.person_add_alt_1_outlined),
                      activeIcon: const Icon(Icons.person_add_alt_1),
                      label: 'nav.add_client'.tr(),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.check_box_outlined),
                      activeIcon: const Icon(Icons.check_box),
                      label: 'nav.tasks'.tr(),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.settings_outlined),
                      activeIcon: const Icon(Icons.settings),
                      label: 'nav.settings'.tr(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masar_app/core/widgets/custom_chat_btn.dart';
import 'package:masar_app/features/login/presentation/manager/auth_cubit.dart';
import 'package:masar_app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../manager/home_cubit.dart';

// 1. استيرادات ميزة إضافة عميل
import '../../../add_client/presentation/screens/add_client_screen.dart';
import '../../../add_client/presentation/manager/add_client_cubit.dart';
import '../../../add_client/data/repos/add_client_repo_impl.dart';

// 2. استيرادات ميزة المهام اليومية (Daily Tasks)
import '../../../daily_tasks/presentation/screens/daily_tasks_screen.dart';
import '../../../daily_tasks/presentation/manager/tasks_cubit.dart';
import '../../../daily_tasks/data/repos/daily_tasks_repo_impl.dart';

// 3. استيراد ميزة الإعدادات (التعديل الجديد هنا) 👇
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

  // مصفوفة الصفحات المحدثة
  List<Widget> _getViews() => [
    // Index 0: شاشة البروفايل
    const ProfileScreen(),

    // Index 1: شاشة إضافة عميل
    BlocProvider(
      create: (context) => AddClientCubit(AddClientRepoImpl()),
      child: const AddClientScreen(),
    ),

    // Index 2: شاشة المهام اليومية
    BlocProvider(
      create: (context) => TasksCubit(DailyTasksRepoImpl())..getTasks(),
      child: const DailyTasksScreen(),
    ),

    // Index 3: شاشة الإعدادات الحقيقية (تم التعديل هنا) 👇
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final views = _getViews();

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
          floatingActionButton: CustomChatBtn(
            onPressed: () {
              context.pushNamed(
                AppRoutes.chat,
                extra: {
                  'chatId': 'chat_001',
                  'currentUserId':
                      (context.read<AuthCubit>().state
                              as AuthCubitAuthenticated)
                          .user
                          .uid,
                },
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
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: state.index,
              onTap: (index) {
                context.read<HomeCubit>().changeIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.backgroundWhite,
              selectedItemColor: AppColors.bluePrimaryDark,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'البروفايل',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_add_alt_1_outlined),
                  activeIcon: Icon(Icons.person_add_alt_1),
                  label: 'إضافة عميل',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_box_outlined),
                  activeIcon: Icon(Icons.check_box),
                  label: 'المهام اليومية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'الإعدادات',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

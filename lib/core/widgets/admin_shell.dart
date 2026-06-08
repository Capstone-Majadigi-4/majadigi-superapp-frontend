import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';

class AdminShell extends StatelessWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const _SidebarDrawer(),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 900) const _SidebarNav(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _SidebarNav extends StatelessWidget {
  const _SidebarNav();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: AppColors.sidebarBg,
      child: const Column(
        children: [
          _SidebarHeader(),
          SizedBox(height: 8),
          Expanded(child: _SidebarMenuList()),
          _SidebarFooter(),
        ],
      ),
    );
  }
}

class _SidebarDrawer extends StatelessWidget {
  const _SidebarDrawer();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.sidebarBg,
      child: const Column(
        children: [
          _SidebarHeader(),
          SizedBox(height: 8),
          Expanded(child: _SidebarMenuList()),
          _SidebarFooter(),
        ],
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A1628), Color(0xFF0D2137)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.hub_outlined, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Majadigi',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              Text('Admin Portal',
                  style: TextStyle(color: Color(0xFF64B5F6), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SidebarMenuList extends StatelessWidget {
  const _SidebarMenuList();
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: [
        _SidebarItem(
          icon: Icons.dashboard_outlined,
          label: 'Dashboard',
          route: AppRoutes.dashboard,
          isSelected: location == AppRoutes.dashboard,
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 12, 8, 6),
          child: Text('MODUL LAYANAN',
              style: TextStyle(
                  color: Color(0xFF546E7A),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2)),
        ),
        ...allModules.map((m) => _SidebarItem(
              icon: m.icon,
              label: m.title,
              route: m.route,
              isSelected: location.startsWith(m.route),
              color: m.color,
            )),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isSelected;
  final Color color;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isSelected,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            context.go(route);
            if (MediaQuery.of(context).size.width < 900) {
              Navigator.of(context).pop();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(color: color.withOpacity(0.3))
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withOpacity(0.2)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon,
                      size: 17,
                      color: isSelected ? color : const Color(0xFF90A4AE)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(label,
                      style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFFB0BEC5),
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarFooter extends StatelessWidget {
  const _SidebarFooter();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin Diskominfo',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                Text('DSK • Super Admin',
                    style: TextStyle(color: Color(0xFF64B5F6), fontSize: 10)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.go(AppRoutes.login),
            icon: const Icon(Icons.logout_rounded,
                color: Color(0xFF90A4AE), size: 18),
            tooltip: 'Logout',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// ─── App Bar dengan tombol back otomatis ─────────────────────────────────────
class MobileAdminBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final bool showBack;

  const MobileAdminBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.showBack = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return AppBar(
      title: Text(title),
      leading: isMobile
          ? (showBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => context.go(AppRoutes.dashboard),
                )
              : IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ))
          : null,
      actions: [...actions, const SizedBox(width: 8)],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }
}

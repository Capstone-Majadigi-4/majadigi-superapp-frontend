import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:majadigi_superapp_frontend/providers/module_provider.dart';
import 'package:majadigi_superapp_frontend/models/service_module.dart';

class ModuleCenterScreen extends StatelessWidget {
  const ModuleCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Light grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0065FF),
        title: const Text(
          'Layanan Publik',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Consumer<ModuleProvider>(
        builder: (context, provider, child) {
          // Group modules by category
          final Map<String, List<ServiceModule>> categorizedModules = {};
          for (var module in provider.availableModules) {
            if (!categorizedModules.containsKey(module.category)) {
              categorizedModules[module.category] = [];
            }
            categorizedModules[module.category]!.add(module);
          }

          final categories = categorizedModules.keys.toList()..sort();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final modules = categorizedModules[category]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  ...modules.map((module) {
                    final isInstalled = provider.isInstalled(module.id);
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isInstalled ? const Color(0xFF0065FF) : const Color(0xFFE2E8F0),
                          width: isInstalled ? 1.5 : 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: module.bgColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(module.emoji, style: const TextStyle(fontSize: 24)),
                        ),
                        title: Text(
                          module.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                            fontFamily: 'Inter',
                          ),
                        ),
                        subtitle: Text(
                          isInstalled ? 'Terpasang di Dashboard' : 'Tersedia untuk diunduh',
                          style: TextStyle(
                            color: isInstalled ? const Color(0xFF0065FF) : const Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            if (isInstalled) {
                              provider.uninstallModule(module.id);
                            } else {
                              provider.installModule(module.id);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isInstalled ? Colors.white : const Color(0xFF0065FF),
                            foregroundColor: isInstalled ? const Color(0xFFE11D48) : Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isInstalled ? const Color(0xFFE11D48) : Colors.transparent,
                              ),
                            ),
                          ),
                          child: Text(
                            isInstalled ? 'Hapus' : 'Pasang',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

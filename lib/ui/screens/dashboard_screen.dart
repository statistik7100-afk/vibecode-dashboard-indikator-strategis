import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/dashboard_provider.dart';
import '../widgets/indicator_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppConstants.fabColor,
        child: const Icon(Icons.tune, color: Colors.white),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<DashboardProvider>().fetchDashboardData(),
          child: Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              if (provider.state == DataState.loading && provider.data == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.state == DataState.error && provider.data == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Gagal mengambil data: ${provider.errorMessage}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => provider.fetchDashboardData(),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }

              if (provider.data == null || provider.data!.cards.isEmpty) {
                return const Center(child: Text('Tidak ada data tersedia.'));
              }

              final releaseMonth = provider.data!.meta['release_month'] ?? '';
              final releaseYear = provider.data!.meta['release_year']?.toString() ?? '';

              return ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Indikator Bulanan Provinsi Sulawesi Utara',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Periode Rilis Data: $releaseMonth $releaseYear',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Search Bar Dummy
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search, color: Colors.grey),
                        hintText: 'Cari Indikator. Contoh: Nilai tukar petani',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ..._buildCategorySections(context, provider),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCategorySections(BuildContext context, DashboardProvider provider) {
    final grouped = provider.groupedCards;
    final categories = grouped.keys.toList();
    final isMobile = MediaQuery.of(context).size.width < 600;

    return categories.map((category) {
      final cards = grouped[category]!;

      return Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppConstants.secondaryColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange[700]!, width: 2),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isMobile ? 1.8 : 1.2,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return IndicatorCardWidget(card: cards[index]);
              },
            ),
          ],
        ),
      );
    }).toList();
  }
}

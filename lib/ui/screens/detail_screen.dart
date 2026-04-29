import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/detail_provider.dart';
import '../widgets/historical_line_chart.dart';

class DetailScreen extends StatefulWidget {
  final String indicatorId;
  final String title;

  const DetailScreen({super.key, required this.indicatorId, required this.title});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailProvider>().fetchIndicatorDetail(widget.indicatorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: const TextStyle(fontSize: 16)),
        ),
        body: Consumer<DetailProvider>(
          builder: (context, provider, child) {
            if (provider.state == DataState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.state == DataState.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Gagal memuat detail: ${provider.errorMessage}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => provider.fetchIndicatorDetail(widget.indicatorId),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (provider.detail == null) {
              return const Center(child: Text('Data tidak ditemukan.'));
            }

            final detail = provider.detail!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Download Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.teal[700],
                      side: BorderSide(color: Colors.teal[300]!),
                      minimumSize: const Size(double.infinity, 40),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TabBar(
                    labelColor: AppConstants.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppConstants.primaryColor,
                    tabs: [
                      Tab(text: 'Grafik'),
                      Tab(text: 'Tabel'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        HistoricalLineChart(data: detail.history),
                        _buildTable(detail.history),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Analisis Data (AI Powered)', style: TextStyle(color: Colors.grey[700])),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                        label: const Text('Analisis data', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const Text('Nilai Tukar Petani Bukan merupakan Indikator Komposit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 16),
                  ExpansionTile(
                    title: const Text('Metode Perhitungan', style: TextStyle(fontWeight: FontWeight.w600)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Data metode perhitungan akan ditampilkan di sini.', style: TextStyle(color: Colors.grey[700])),
                      )
                    ],
                  ),
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: const Text('Interpretasi', style: TextStyle(fontWeight: FontWeight.w600)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          detail.description.isEmpty ? 'Tidak ada deskripsi tersedia.' : detail.description,
                          style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTable(List history) {
    return SingleChildScrollView(
      child: Table(
        border: TableBorder.all(color: Colors.grey[300]!),
        children: [
          TableRow(
            decoration: const BoxDecoration(color: AppConstants.primaryColor),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Periode', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Nilai', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          ...history.map((h) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(h.period),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(h.value.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

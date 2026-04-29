# Instruksi Teknis Eksekusi: Dashboard Indikator Strategis BPS

## 1. Objective Singkat
Bangun aplikasi mobile Flutter untuk menampilkan data indikator strategis dari Web API BPS. Aplikasi harus mem-parsing data JSON yang bervariasi secara dinamis menjadi daftar card indikator yang dikategorikan pada dashboard, serta memiliki halaman detail dengan grafik historis. Fokus pada keandalan eksekusi tanpa crash jika menemukan data null atau kosong.

## 2. Scope MVP (Fix)
*   Dashboard utama menampilkan daftar indikator (Card) yang dikelompokkan berdasarkan kategori.
*   Halaman detail indikator yang menampilkan metadata lengkap dan grafik historis (Line Chart).
*   Integrasi HTTP GET request ke Web API BPS untuk mengambil data JSON (`meta` dan `cards`).
*   Parsing JSON dinamis untuk dua tipe data: `single` (Object/Map) dan `multi` (Array/List).
*   Indikator tren (naik/turun/surplus/defisit) pada UI berdasarkan parameter `direction` dan `change_value`.

## 3. Non-Scope (Jangan Dikerjakan)
*   Fitur Autentikasi (Login/Register/Firebase Auth) tidak diperlukan.
*   Mode offline penuh (Offline Support / Local Database SQLite/Hive).
*   State Management yang kompleks (BLoC / Redux / arsitektur over-engineered).
*   Sistem Caching data yang kompleks.
*   Animasi atau transisi UI kustom yang memakan waktu.

## 4. Tech Stack & Aturan
*   **Framework:** Flutter (Versi stabil terbaru).
*   **State Management:** `provider` (Gunakan `ChangeNotifier`).
*   **HTTP Client:** `http` atau `dio` (Pilih salah satu, gunakan metode standar).
*   **Chart Library:** `fl_chart` (Gunakan implementasi LineChart standar).
*   **Aturan Penggunaan:** Dilarang menggunakan package pihak ketiga untuk elemen UI selain grafik. Gunakan Material UI standar bawaan Flutter (Card, ListTile, ListView).

## 5. Arsitektur Implementasi
Gunakan arsitektur berlapis (layered) sederhana berbasis fitur.

**Struktur Folder (WAJIB):**
```text
lib/
├── core/
│   ├── api_client.dart       # Konfigurasi dio/http
│   └── constants.dart        # URL API, color constants
├── models/
│   ├── bps_response.dart     # Root JSON (meta, cards)
│   ├── indicator_card.dart   # Model: id, category, title, type, period
│   ├── single_data.dart      # Model untuk tipe single
│   ├── multi_data.dart       # Model untuk tipe multi
│   └── historical_chart.dart # Model untuk data chart historis
├── services/
│   └── api_service.dart      # Fungsi fetch API (getIndicators, getIndicatorDetail)
├── providers/
│   ├── dashboard_provider.dart # Mengelola state loading/error/data list
│   └── detail_provider.dart    # Mengelola state data detail & chart
└── ui/
    ├── screens/
    │   ├── dashboard_screen.dart
    │   └── detail_screen.dart
    └── widgets/
        ├── indicator_card_widget.dart
        ├── single_value_view.dart
        ├── multi_value_view.dart
        └── historical_line_chart.dart
```

**Alur Data:**
UI (Panggil fungsi fetch saat `initState`) → Provider (Set status Loading) → Service (HTTP Request) → Model (Parsing JSON dengan `fromJson`) → Provider (Update Data List) → UI (Render ulang dengan `Consumer`).

## 6. Task Breakdown (Step-by-step)
*   **Hari 1: Setup Project & Model Data**
    *   Buat project Flutter: `flutter create .`
    *   Buat struktur folder sesuai arsitektur.
    *   Buat class Model (`bps_response.dart`, `indicator_card.dart`). 
    *   Implementasi `fromJson` yang membedakan parsing `type == 'single'` dan `type == 'multi'`.
*   **Hari 2: API Service & Provider**
    *   Implementasikan `api_service.dart`.
    *   Buat `dashboard_provider.dart` dengan fungsi `fetchDashboardData()`.
    *   Handle `try-catch` dan status response (loading, success, error).
*   **Hari 3-4: UI Dashboard & Logika Kategori**
    *   Buat `dashboard_screen.dart` menggunakan `Consumer<DashboardProvider>`.
    *   Kelompokkan data array berdasarkan field `category` (misal: "Makro Ekonomi", "Pertanian").
    *   Buat komponen reusable `indicator_card_widget.dart` yang merender `single_value_view.dart` atau `multi_value_view.dart` sesuai parameter `type`.
*   **Hari 5-6: UI Detail & Charting**
    *   Buat `detail_screen.dart` yang menerima `id` sebagai argumen dari halaman sebelumnya.
    *   Integrasikan library `fl_chart` pada widget `historical_line_chart.dart`.
    *   Petakan array data historis menjadi titik koordinat chart.

## 7. Aturan Coding (WAJIB)
*   **Naming:** Gunakan `camelCase` untuk variabel/fungsi, `PascalCase` untuk Class, `snake_case` untuk nama file (Dart convention).
*   **Struktur File:** Satu file maksimal berisi satu Class utama. Ekstrak sub-widget ke file terpisah.
*   **Larangan Overengineering:** Jangan membuat abstraksi (abstract class/repository interface) untuk API Service. Gunakan pemanggilan konkret.
*   **Readability:** Tambahkan komentar singkat pada blok if-else logika parsing `single` dan `multi`.

## 8. Pola Implementasi (PENTING)

**Cara parsing JSON kompleks (single vs multi):**
Gunakan pengecekan manual pada `fromJson`.
```dart
// Pada factory IndicatorCard.fromJson
final type = json['type'];
dynamic parsedData;

if (type == 'single') {
  parsedData = SingleData.fromJson(json['data'] ?? {});
} else if (type == 'multi') {
  parsedData = (json['data'] as List?)?.map((e) => MultiData.fromJson(e)).toList() ?? [];
}
```

**Cara render UI berdasarkan type:**
Gunakan if/else di dalam fungsi `build`.
```dart
if (card.type == 'single') {
  return SingleValueView(data: card.data as SingleData);
} else {
  return MultiValueView(data: card.data as List<MultiData>);
}
```

**Cara handle null & optional field:**
Selalu asumsikan data bisa kosong.
```dart
// Pada JSON parser
final direction = json['direction']; // biarkan nullable (String?)

// Pada UI
if (data.direction != null) 
  Icon(data.direction == 'up' ? Icons.arrow_upward : Icons.arrow_downward)
```

**Cara handle loading/error:**
Buat property state di Provider: `bool isLoading` dan `String? errorMessage`. Gunakan nilai tersebut untuk menampilkan `CircularProgressIndicator` atau `Text` error di UI.

**Cara buat chart dari data historis:**
Ubah list JSON historis menjadi `List<FlSpot>`. Tentukan nilai X sebagai index waktu dan Y sebagai nilai indikator.

## 9. Definition of Done
*   [ ] Aplikasi sukses melakukan fetch data dari Web API BPS.
*   [ ] Parsing JSON tidak menghasilkan error tipe data (`TypeError` atau `CastError`).
*   [ ] Dashboard menampilkan indikator yang sudah terkelompok berdasarkan kategori (Makro Ekonomi, Pertanian, dll).
*   [ ] Tampilan card menyesuaikan `type` secara otomatis.
*   [ ] Elemen UI seperti icon arah tren (`up`/`down`) tidak error dan tidak tampil jika fieldnya null.
*   [ ] Halaman detail dapat dibuka dari card.
*   [ ] Grafik garis (`fl_chart`) berhasil di-render tanpa crash meskipun data historis hanya sedikit.

---

## Kesalahan Umum yang Harus Dihindari
1.  **Tidak handle type multi:** Mengasumsikan field `data` selalu berbentuk *Map*, padahal pada tipe "multi" berbentuk *List* array (seperti pada indikator inflasi). Aplikasi pasti crash.
2.  **Hardcode UI:** Menulis statik teks di dalam widget (contoh: teks "Makro Ekonomi" ditulis manual bukan dari `card.category`).
3.  **Parsing langsung di widget:** Melakukan operasi `jsonDecode` di dalam method `build()`. Ini membebani *rendering frame*. Lakukan di Model.
4.  **Memaksa unwrap null (!):** Menggunakan bang operator `!` pada field API yang rentan kosong (seperti `change_value` atau `direction`). Selalu gunakan `??` atau lakukan validasi `if (var != null)`.
5.  **State Management berantakan:** Menggunakan `setState` untuk memanggil HTTP Request. Panggilan API WAJIB dilakukan melalui `Provider`.

---

## Pseudo-code untuk Parsing dan Rendering Card

**Model:**
```dart
class IndicatorCard {
  final String id;
  final String category;
  final String title;
  final String type;
  final dynamic data; 

  IndicatorCard({
    required this.id, 
    required this.category, 
    required this.title, 
    required this.type, 
    required this.data
  });

  factory IndicatorCard.fromJson(Map<String, dynamic> json) {
    return IndicatorCard(
      id: json['id'] ?? '',
      category: json['category'] ?? 'Uncategorized',
      title: json['title'] ?? 'Unknown',
      type: json['type'] ?? 'single',
      data: json['type'] == 'multi' 
          ? (json['data'] as List? ?? []).map((i) => MultiData.fromJson(i)).toList()
          : SingleData.fromJson(json['data'] ?? {}),
    );
  }
}
```

**Widget Card Body:**
```dart
Widget buildIndicatorBody(IndicatorCard card) {
  if (card.type == 'single') {
    final single = card.data as SingleData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${single.value} ${single.unit}', style: TextStyle(fontSize: 24)),
        if (single.direction != null) 
           Row(children: [
             Icon(single.direction == 'up' ? Icons.arrow_drop_up : Icons.arrow_drop_down, 
                  color: single.direction == 'up' ? Colors.green : Colors.red),
             Text('${single.changeValue} ${single.changeUnit}'),
           ])
      ]
    );
  } else if (card.type == 'multi') {
    final multiList = card.data as List<MultiData>;
    return Column(
      children: multiList.map((item) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.label),
          Text('${item.value} ${item.unit}'),
        ]
      )).toList(),
    );
  }
  return const SizedBox.shrink(); // Safety fallback
}
```

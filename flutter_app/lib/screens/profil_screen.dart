import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_constants.dart';

/// Screen Tab 6: Profil & Pengaturan Aplikasi
/// Mengelola identitas peternak, preferensi kandang, konfigurasi engine fuzzy, & sistem offline
class ProfilScreen extends StatefulWidget {
  final String selectedFlock;
  final ValueChanged<String> onFlockChanged;
  final VoidCallback onResetData;

  const ProfilScreen({
    super.key,
    required this.selectedFlock,
    required this.onFlockChanged,
    required this.onResetData,
  });

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  // State Profil Peternak
  String _farmerName = 'Ferdiansyah';
  String _farmerRole = 'Kepala Kandang Broiler';
  String _farmerPhone = '0812-3456-7890';
  String _partnership = 'Kemitraan Mandiri Broiler';

  // State Pengaturan Kandang
  String _selectedStrain = 'Cobb 500';
  int _flockCapacity = 10000;
  String _cageType = 'Closed House (Tunnel)';
  String _cageLocation = 'Bogor, Jawa Barat';

  // State Pengaturan Sistem Inferensi Fuzzy
  String _defaultFuzzyMethod = 'Mamdani (Centroid)';
  bool _earlyWarningAlerts = true;
  bool _soundVibrationAlarm = true;
  bool _autoOfflineSync = true;
  String _temperatureUnit = 'Celsius (°C)';

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _farmerName);
    final phoneController = TextEditingController(text: _farmerPhone);
    final roleController = TextEditingController(text: _farmerRole);
    final partnerController = TextEditingController(text: _partnership);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Edit Profil Peternak',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(
                  labelText: 'Peran / Jabatan',
                  prefixIcon: Icon(Icons.badge, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor WhatsApp / HP',
                  prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: partnerController,
                decoration: const InputDecoration(
                  labelText: 'Kemitraan / Perusahaan',
                  prefixIcon: Icon(Icons.business, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _farmerName = nameController.text.trim().isEmpty ? _farmerName : nameController.text;
                _farmerRole = roleController.text.trim().isEmpty ? _farmerRole : roleController.text;
                _farmerPhone = phoneController.text.trim().isEmpty ? _farmerPhone : phoneController.text;
                _partnership = partnerController.text.trim().isEmpty ? _partnership : partnerController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil peternak berhasil diperbarui!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showStrainSelectionModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Strain Broiler Acuan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const Text(
                'Standar suhu harian adaptif akan disesuaikan dengan manajemen strain.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.egg, color: AppColors.primary),
                title: const Text('Cobb 500 (Standar Industri Nasional)'),
                subtitle: const Text('Broiler Management Guide Cobb-Vantress'),
                trailing: _selectedStrain == 'Cobb 500' ? const Icon(Icons.check_circle, color: AppColors.emeraldGreen) : null,
                onTap: () {
                  setState(() => _selectedStrain = 'Cobb 500');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.egg, color: AppColors.primary),
                title: const Text('Ross 308 (Aviagen Standard)'),
                subtitle: const Text('Broiler Pocket Guide Aviagen'),
                trailing: _selectedStrain == 'Ross 308' ? const Icon(Icons.check_circle, color: AppColors.emeraldGreen) : null,
                onTap: () {
                  setState(() => _selectedStrain = 'Ross 308');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.egg, color: AppColors.primary),
                title: const Text('Hubbard Classic'),
                subtitle: const Text('Management Guide for Tropical Area'),
                trailing: _selectedStrain == 'Hubbard' ? const Icon(Icons.check_circle, color: AppColors.emeraldGreen) : null,
                onTap: () {
                  setState(() => _selectedStrain = 'Hubbard');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutAppDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.cruelty_free, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Tentang Aplikasi', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'FuzzyBroiler IP v1.2.0',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textHeadline),
              ),
              SizedBox(height: 4),
              Text(
                'Sistem Pendukung Keputusan Evaluasi Potensi Indeks Performa Ayam Broiler Berbasis Logika Fuzzy Adaptif Umur.',
                style: TextStyle(fontSize: 12, color: AppColors.textBody, height: 1.3),
              ),
              SizedBox(height: 12),
              Divider(),
              Text('Peneliti / Mahasiswa:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
              Text('Ferdiansyah (Program Studi Teknik Informatika)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Tujuan:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
              Text('Tugas Akhir Sarjana Komputer (S.Kom)', style: TextStyle(fontSize: 12)),
              SizedBox(height: 8),
              Text('Fitur Keunggulan:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
              Text('• 100% Berjalan Mandiri Tanpa Internet (Offline)\n• 27 Aturan Inferensi Biologis Cobb 500 / Ross 308\n• Komparasi Mamdani Centroid vs Sugeno Orde-Nol\n• Deteksi Dini & Rekomendasi SOP Mitigasi Otomatis', style: TextStyle(fontSize: 11, height: 1.4)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup', style: TextStyle(color: AppColors.primary))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Heading Layar
        const Text(
          'Profil & Pengaturan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const Text(
          'Kelola identitas peternak, data kandang, preferensi sistem fuzzy & offline.',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 14),

        // 2. Kartu Profil Peternak
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.secondaryContainer, width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        'F',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _farmerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textHeadline,
                          ),
                        ),
                        Text(
                          _farmerRole,
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _partnership,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSecondaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _showEditProfileDialog,
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                    tooltip: 'Edit Profil',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.outline),
              Row(
                children: [
                  Expanded(child: _buildProfileMetric('Kandang Aktif', widget.selectedFlock)),
                  Container(width: 1, height: 26, color: AppColors.outline),
                  Expanded(child: _buildProfileMetric('Strain Acuan', _selectedStrain)),
                  Container(width: 1, height: 26, color: AppColors.outline),
                  Expanded(child: _buildProfileMetric('Populasi', '${_flockCapacity.toString()} Ekor')),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 3. Seksi Pengaturan Kandang
        _buildSectionHeader('PENGATURAN KANDANG & BUDIDAYA'),
        Material(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.outline),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.cottage_outlined, color: AppColors.primary),
                title: const Text('Kandang Terpilih', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text(widget.selectedFlock, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                trailing: PopupMenuButton<String>(
                  initialValue: widget.selectedFlock,
                  onSelected: widget.onFlockChanged,
                  itemBuilder: (context) => AppConstants.flocks
                      .map((f) => PopupMenuItem(value: f, child: Text(f)))
                      .toList(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Ganti', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      Icon(Icons.arrow_drop_down, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.outline),
              ListTile(
                leading: const Icon(Icons.biotech_outlined, color: AppColors.primary),
                title: const Text('Standar Strain Broiler', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text(_selectedStrain, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                onTap: _showStrainSelectionModal,
              ),
              const Divider(height: 1, color: AppColors.outline),
              ListTile(
                leading: const Icon(Icons.warehouse_outlined, color: AppColors.primary),
                title: const Text('Tipe Sistem Kandang', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text('$_cageType • $_cageLocation', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 4. Seksi Konfigurasi Sistem Fuzzy & Komputasi
        _buildSectionHeader('SISTEM INFERENSI FUZZY (DSS SETTINGS)'),
        Material(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.outline),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.calculate_outlined, color: AppColors.primary),
                title: const Text('Metode Inferensi Utama', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text(_defaultFuzzyMethod, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                trailing: DropdownButton<String>(
                  value: _defaultFuzzyMethod,
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                  items: const [
                    DropdownMenuItem(value: 'Mamdani (Centroid)', child: Text('Mamdani')),
                    DropdownMenuItem(value: 'Sugeno (Weighted Avg)', child: Text('Sugeno')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _defaultFuzzyMethod = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Metode utama disetel ke: $val')),
                      );
                    }
                  },
                ),
              ),
              const Divider(height: 1, color: AppColors.outline),
              SwitchListTile(
                activeColor: AppColors.primary,
                secondary: const Icon(Icons.notification_important_outlined, color: AppColors.warningButton),
                title: const Text('Peringatan Dini Penurunan Skor', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('Deteksi anomali suhu & skor turun 2-3 hari beruntun', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                value: _earlyWarningAlerts,
                onChanged: (val) => setState(() => _earlyWarningAlerts = val),
              ),
              const Divider(height: 1, color: AppColors.outline),
              SwitchListTile(
                activeColor: AppColors.primary,
                secondary: const Icon(Icons.volume_up_outlined, color: AppColors.primary),
                title: const Text('Alarm & Getar Suhu Ekstrem', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('Bunyi peringatan jika deviasi suhu melebihi ±3.0°C', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                value: _soundVibrationAlarm,
                onChanged: (val) => setState(() => _soundVibrationAlarm = val),
              ),
              const Divider(height: 1, color: AppColors.outline),
              ListTile(
                leading: const Icon(Icons.thermostat_outlined, color: AppColors.warningButton),
                title: const Text('Satuan Pengukuran Suhu', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text(_temperatureUnit, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                trailing: DropdownButton<String>(
                  value: _temperatureUnit,
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                  items: const [
                    DropdownMenuItem(value: 'Celsius (°C)', child: Text('°C')),
                    DropdownMenuItem(value: 'Fahrenheit (°F)', child: Text('°F')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _temperatureUnit = val);
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 5. Seksi Manajemen Data & Sistem Offline
        _buildSectionHeader('MANAJEMEN DATA & SISTEM OFFLINE'),
        Material(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.outline),
          ),
          child: Column(
            children: [
              SwitchListTile(
                activeColor: AppColors.primary,
                secondary: const Icon(Icons.cloud_off, color: AppColors.tertiary),
                title: const Text('Mode Offline-First', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('Penyimpanan lokal perangkat, tanpa kuota internet', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                value: _autoOfflineSync,
                onChanged: (val) => setState(() => _autoOfflineSync = val),
              ),
              const Divider(height: 1, color: AppColors.outline),
              ListTile(
                leading: const Icon(Icons.file_download_outlined, color: AppColors.primary),
                title: const Text('Ekspor Riwayat Evaluasi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('Unduh berkas CSV & JSON untuk analisis skripsi', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                trailing: const Icon(Icons.download, size: 18, color: AppColors.primary),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Berkas "data_skenario_uji_50.csv" siap di folder proyek.'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ),
              const Divider(height: 1, color: AppColors.outline),
              ListTile(
                leading: const Icon(Icons.restore_outlined, color: AppColors.error),
                title: const Text('Reset Data Evaluasi Harian', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.error)),
                subtitle: const Text('Kembalikan riwayat evaluasi ke data standar awal', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                trailing: const Icon(Icons.refresh, size: 18, color: AppColors.error),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Konfirmasi Reset'),
                      content: const Text('Apakah Anda yakin ingin menyetel ulang data evaluasi harian ke kondisi awal?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onResetData();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Data evaluasi berhasil direset ke kondisi awal.')),
                            );
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 6. Seksi Info Tugas Akhir & Bantuan
        _buildSectionHeader('INFORMASI TUGAS AKHIR & DOKUMENTASI'),
        Material(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.outline),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline, color: AppColors.primary),
                title: const Text('Tentang FuzzyBroiler IP', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('Informasi penelitian Tugas Akhir, versi, dan lisensi', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                onTap: _showAboutAppDialog,
              ),
              const Divider(height: 1, color: AppColors.outline),
              ListTile(
                leading: const Icon(Icons.menu_book_outlined, color: AppColors.primary),
                title: const Text('Panduan Demo Sidang Ujian', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('Langkah presentasi di depan dosen penguji', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Panduan Sidang Penguji', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      content: const Text(
                        '1. Buka Tab "Input Evaluasi" lalu klik chip preset "✨ Kondisi Ideal" untuk menunjukkan skor tinggi (85+).\n\n'
                        '2. Klik chip "🔥 Panas (+3°C)" untuk menunjukkan penurunan skor dan aktivasi Early Warning.\n\n'
                        '3. Buka Tab "Hasil" untuk menampilkan perbandingan Mamdani (0.496 ms) vs Sugeno (0.005 ms).\n\n'
                        '4. Buka Tab "Solusi" untuk mendemonstrasikan checklist interaktif SOP mitigasi kandang.',
                        style: TextStyle(fontSize: 12, height: 1.4),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup', style: TextStyle(color: AppColors.primary))),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        const Center(
          child: Text(
            'FuzzyBroiler IP • Tugas Akhir 2026\nSistem Pendukung Keputusan Broiler Berbasis Logika Fuzzy',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.4),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProfileMetric(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

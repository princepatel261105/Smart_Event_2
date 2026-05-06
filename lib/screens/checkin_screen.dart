import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _manualIdController = TextEditingController();
  final _manualNameController = TextEditingController();
  late MobileScannerController cameraController;
  bool _isProcessing = false;
  bool _showQRGuide = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _manualIdController.dispose();
    _manualNameController.dispose();
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _processCheckIn(String participantId, String? participantName) async {
    final eventProvider = context.read<EventProvider>();
    final checkInProvider = context.read<CheckInProvider>();

    if (eventProvider.currentEvent == null) {
      showCustomSnackBar(
        context,
        message: 'Please select an event first',
        type: SnackBarType.warning,
      );
      Navigator.pushNamed(context, '/setup');
      return;
    }

    final event = eventProvider.currentEvent!;

    // Check capacity
    final checkedInCount = checkInProvider.getEventCheckInCount(event.id);
    if (checkedInCount >= event.maxCapacity) {
      showCustomSnackBar(
        context,
        message: 'Event is at full capacity!',
        type: SnackBarType.error,
      );
      return;
    }

    // Check for duplicate
    if (checkInProvider.isDuplicateCheckIn(event.id, participantId)) {
      showCustomSnackBar(
        context,
        message: '⚠️ Duplicate entry detected! Participant already checked in.',
        type: SnackBarType.warning,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    final name = participantName ?? 'Participant';

    // Perform check-in
    final success = await checkInProvider.checkInParticipant(
      eventId: event.id,
      participantId: participantId,
      participantName: name,
    );

    if (!mounted) return;

    if (success) {
      showCustomSnackBar(
        context,
        message: '✅ $name checked in successfully!',
        type: SnackBarType.success,
      );

      if (_manualIdController.text.isNotEmpty) {
        _manualIdController.clear();
        _manualNameController.clear();
      }
    } else {
      showCustomSnackBar(
        context,
        message: 'Failed to check in participant',
        type: SnackBarType.error,
      );
    }
  }

  void _handleQRDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    _isProcessing = true;

    try {
      final barcode = barcodes.first;
      final participantId = barcode.rawValue ?? '';

      if (participantId.isEmpty) {
        showCustomSnackBar(
          context,
          message: 'Invalid QR code',
          type: SnackBarType.error,
        );
        return;
      }

      _processCheckIn(participantId, null);
    } finally {
      Future.delayed(const Duration(seconds: 1), () {
        _isProcessing = false;
      });
    }
  }

  void _performManualCheckIn() {
    if (_manualIdController.text.isEmpty) {
      showCustomSnackBar(
        context,
        message: 'Please enter Participant ID',
        type: SnackBarType.warning,
      );
      return;
    }

    _processCheckIn(
      _manualIdController.text.trim(),
      _manualNameController.text.isNotEmpty
          ? _manualNameController.text.trim()
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final currentEvent = eventProvider.currentEvent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in Participants'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        actions: [
          if (currentEvent != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  currentEvent.eventName,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Connectivity Banner
          Consumer<ConnectivityProvider>(
            builder: (context, connectivity, _) =>
                ConnectivityBanner(isConnected: connectivity.isConnected),
          ),
          Expanded(
            child: currentEvent == null
                ? _buildNoEventWidget()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildQRScannerTab(),
                      _buildManualEntryTab(),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: currentEvent != null
          ? Material(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.blue.shade700,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Colors.blue.shade700,
                tabs: const [
                  Tab(icon: Icon(Icons.qr_code), text: 'QR Scan'),
                  Tab(icon: Icon(Icons.edit), text: 'Manual Entry'),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildNoEventWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Event Selected',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Create or select an event to start check-ins',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Create Event',
            onPressed: () => Navigator.pushNamed(context, '/setup'),
            width: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildQRScannerTab() {
    return Stack(
      children: [
        MobileScanner(
          controller: cameraController,
          onDetect: _handleQRDetect,
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Align QR code within the frame',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        // QR Guide
        if (_showQRGuide)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tips for best results:',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () =>
                            setState(() => _showQRGuide = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTipText('Ensure good lighting'),
                  _buildTipText('Hold camera steady'),
                  _buildTipText('QR code should be fully visible'),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTipText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildManualEntryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manual Check-In',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter participant details manually',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            label: 'Participant ID',
            hint: 'e.g., PART001',
            controller: _manualIdController,
            prefixIcon: Icons.badge,
            validator: ValidationUtils.validateParticipantId,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: 'Participant Name (Optional)',
            hint: 'e.g., John Doe',
            controller: _manualNameController,
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'Check In',
            onPressed: _performManualCheckIn,
            icon: Icons.check_circle,
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            label: 'View Check-ins',
            onPressed: () => Navigator.pushNamed(context, '/logs'),
          ),
        ],
      ),
    );
  }
}

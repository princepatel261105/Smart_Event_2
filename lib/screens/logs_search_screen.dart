import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/index.dart';
import '../providers/index.dart';
import '../utils/index.dart';
import '../widgets/index.dart';

class LogsSearchScreen extends StatefulWidget {
  const LogsSearchScreen({super.key});

  @override
  State<LogsSearchScreen> createState() => _LogsSearchScreenState();
}

class _LogsSearchScreenState extends State<LogsSearchScreen> {
  final _searchController = TextEditingController();
  List<CheckInRecord> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    final eventProvider = context.read<EventProvider>();
    final checkInProvider = context.read<CheckInProvider>();

    if (eventProvider.currentEvent == null) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    final results = checkInProvider.searchParticipant(
      eventProvider.currentEvent!.id,
      query,
    );

    setState(() {
      _searchResults = results;
      _isSearching = true;
    });
  }

  void _showQRDialog(CheckInRecord record) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Check-In QR Code',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              QrImageView(
                data: record.id,
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: 16),
              Text(
                'ID: ${record.participantId}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Name: ${record.participantName}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Close',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportDialog() {
    final eventProvider = context.read<EventProvider>();
    final checkInProvider = context.read<CheckInProvider>();

    if (eventProvider.currentEvent == null) {
      showCustomSnackBar(
        context,
        message: 'Please select an event first',
        type: SnackBarType.warning,
      );
      return;
    }

    final event = eventProvider.currentEvent!;
    final checkIns = checkInProvider.getEventCheckIns(event.id);

    String csvContent = 'Participant ID,Name,Checked In At,Status\n';
    for (var checkIn in checkIns) {
      csvContent +=
          '${checkIn.participantId},${checkIn.participantName},${DateTimeUtils.formatDateTime(checkIn.checkedInAt)},Checked In\n';
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Export Check-In Data',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  csvContent,
                  style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Total: ${checkIns.length} check-ins',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Close',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Copy',
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: csvContent));
                        if (!context.mounted) return;
                        showCustomSnackBar(
                          context,
                          message: 'Data copied to clipboard',
                          type: SnackBarType.success,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final checkInProvider = context.watch<CheckInProvider>();
    final currentEvent = eventProvider.currentEvent;

    final allCheckIns = currentEvent != null
        ? checkInProvider.getEventCheckIns(currentEvent.id)
        : <CheckInRecord>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In Logs & Search'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _showExportDialog,
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
                : Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentEvent.eventName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Total Check-ins: ${allCheckIns.length} / ${currentEvent.maxCapacity}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _performSearch,
                          decoration: InputDecoration(
                            hintText: 'Search by ID or name...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon:
                                Icon(Icons.search, color: Colors.grey[600]),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchResults = [];
                                        _isSearching = false;
                                      });
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // List
                      Expanded(
                        child: _isSearching
                            ? _buildCheckInList(_searchResults)
                            : allCheckIns.isEmpty
                                ? _buildEmptyState()
                                : _buildCheckInList(allCheckIns),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: currentEvent != null
          ? FloatingActionButton(
              backgroundColor: Colors.blue.shade700,
              onPressed: () {
                context.read<EventProvider>().setCurrentEvent(currentEvent);
                Navigator.pushNamed(context, '/checkin');
              },
              tooltip: 'Check In',
              child: const Icon(Icons.person_add),
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
            'Select an event to view check-in logs',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'View Events',
            onPressed: () => Navigator.pushNamed(context, '/dashboard'),
            width: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Check-ins Yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Check-in participants to see logs',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInList(List<CheckInRecord> checkIns) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: checkIns.length,
      itemBuilder: (context, index) {
        final checkIn = checkIns[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.check_circle, color: Colors.green.shade700),
            ),
            title: Text(
              checkIn.participantName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'ID: ${checkIn.participantId}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  DateTimeUtils.formatDateTime(checkIn.checkedInAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('View QR'),
                  onTap: () => _showQRDialog(checkIn),
                ),
                PopupMenuItem(
                  child: const Text('Details'),
                  onTap: () {
                    showCustomSnackBar(
                      context,
                      message: 'Checked in ${DateTimeUtils.formatTimeAgo(checkIn.checkedInAt)}',
                      type: SnackBarType.info,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
